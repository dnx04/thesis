#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Báo cáo chi tiết <chuong3>
]

#show: body => first_line_indent_all_body(body)

== Các chức năng chính

Dự án xây dựng một hệ thống quản lý bề mặt tấn công đa nhiệm, với các chức năng chính như sau:

- Chức năng Trinh sát thông tin cho phép tùy chỉnh linh hoạt các giai đoạn sẽ thực hiện và các công cụ đơn nhiệm thông qua cấu hình Scan Engine với ngôn ngữ YAML.
- Lưu trữ, sắp xếp các kết quả thu được theo cấu trúc gọn gàng, dễ quản lý, hỗ trợ truy vấn tùy chỉnh để lọc dữ liệu dễ dàng hơn.
- Giao diện trực quan, dễ nhìn, dễ sử dụng.
- Cho phép giám sát liên tục, lên lịch quét nhiều mục tiêu theo các khoảng thời gian định kỳ.
- Gửi thông báo cho người dùng trên các kênh thông báo như Discord, Slack và Telegram đối với bất kỳ tên miền phụ mới hoặc lỗ hổng nào được xác định hoặc các thay đổi dữ liệu trinh sát.
- Trích xuất báo cáo với định dạng PDF về dữ liệu thu thập được theo mục tiêu.

== Kiến trúc tổng quan

=== Sơ đồ hệ thống

Ứng dụng được xây dựng theo kiến trúc Microservices, được viết bằng framework Django của Python. Hệ thống có thể được triển khai trên một máy chủ hoặc nhiều máy chủ khác nhau thông qua Docker. Dưới đây là sơ đồ các thành phần chính của hệ thống:

#figure(
  image("structure-diagram.png"),
  caption: [Sơ đồ kiến trúc Microservice của hệ thống],
) <structure-diagram>

- *Web Application (Django):* Thành phần này đóng vai trò là ứng dụng web xử lý trực tiếp hầu hết các chức năng của một trang web thông thường như quản lý người dùng, quản lý mục tiêu, giao diện ứng dụng,... Khi người kiểm thử xâm nhập gửi lên yêu cầu trinh sát thông tin về một đối tượng, ứng dụng sẽ chỉ lưu trữ đối tượng này trong Database và Message Queue rồi lập tức trả về trạng thái đã tiếp nhận. Quá trình xử lý đối tượng sau đó sẽ được thực thi bởi Celery Worker.

- *Database (PostgreSQL):* Dữ liệu về người dùng, các mục tiêu,... cùng toàn bộ kết quả thu thập được sẽ được lưu trữ trong hệ quản trị cơ sở dữ liệu PostgreSQL. Đây là một trong những hệ quản trị cơ sở dữ liệu phổ biến nhất, có độ tin cậy cao. 

- *Message Queue (Redis):* Redis được chọn để đóng vai trò làm hàng đợi cho các tác vụ cần được xử lý bất đồng bộ trong hệ thống. Đây là một trong những kho lưu trữ dữ liệu dạng key-value có tốc độ cao nhất hiện nay. Các tác vụ sẽ được thư viện Celery tuần tự hóa (serialization) dưới định dạng JSON với nội dung bao gồm tên hàm, các tham số đầu vào,... rồi gửi tới đây.

- *Task Executor và Task Scheduler (Celery):* Celery Worker là một phần của thư viện Celery Python. Thư viện này cho phép xử lý liên tục các công việc được lấy từ Message Queue. Đây là thành phần chính thực hiện quá trình Trinh sát thông tin. Celery Worker cũng được kết nối trực tiếp tới Database thông qua các đối tượng ORM để nhanh chóng lưu trữ các kết quả thu được. Scheduler sử dụng Celery Beat sẽ thực hiện quét theo lịch trình xác định.

#figure(
  image("principle.png"),
  caption: [Ứng dụng cơ chế Asynchronous Task Queue bằng tích hợp Redis và Celery],
) <principle>

Hệ thống ứng dụng cơ chế Asynchronous Task Queue. Cơ chế này cho phép các tác vụ nặng nhọc được xử lý một cách bất đồng bộ bởi thành phần Celery Worker, tách biệt so với ứng dụng web Django. Số lượng Celery Worker cũng có thể được mở rộng theo chiều ngang. Nhờ vậy, người dùng vẫn có thể sử dụng trơn tru các tính năng khác của ứng dụng trong lúc các giai đoạn của Trinh sát thông tin đang được thực hiện.

== Chức năng thu thập và trinh sát thông tin

#figure(
  image("image-7.png"),
  caption: [Sơ đồ tóm tắt các chức năng trinh sát thông tin],
) <functions>

=== Scan Engine

Để có thể sử dụng chức năng Trinh sát thông tin thì người dùng cần phải cung cấp 2 thông tin: tên miền mục tiêu và cấu hình Scan Engine muốn thực thi. Scan Engine giống như là một bản thiết kế chuỗi các công việc sẽ được thực thi nối tiếp nhau, dữ liệu đầu ra của công việc này có thể là dữ liệu đầu vào của công việc khác. Một cấu hình Scan Engine thông thường sẽ gồm các phần sau:

1. Tìm kiếm các tên miền phụ (Subdomain Discovery)
2. Xác định các ứng dụng web (Http Crawler)
3. Chụp ảnh màn hình các ứng dụng web (Grab Screenshot)
4. Dò quét các cổng mở (Port Scan)
5. Rà quét các lỗ hổng đơn giản (Vulnerability Scan)

Người kiểm thử xâm nhập có thể dễ dàng bật tắt các bước trên với giao diện web đơn giản hoặc tùy chỉnh sâu bằng ngôn ngữ YAML, ví dụ như: chọn tập các công cụ đơn nhiệm sẽ sử dụng, số thread (luồng CPU), đường dẫn tệp từ từ điển (wordlist),...

Đối với cấu hình Scan Engine cơ bản, luồng công việc được thực hiện thông qua các hàm `subdomain_scan`, `http_crawler`, `grab_screenshot`, `port_scanning` và `vulnerability_scan`. Các hàm này sẽ được thực thi tuần tự theo thứ tự đã định sẵn.

==== Hàm `subdomain_scan`

Thực hiện các kỹ thuật thu thập tên miền phụ:

- Thu thập thụ động (passive): lấy từ các cơ sở dữ liệu bên thứ ba như Google, Shodan, SecurityTrails. Do không tương tác với tên miền mục tiêu nên phương pháp này tốn rất ít thời gian và công sức để thực hiện. Phương pháp này bao gồm các kỹ thuật: Certificate Transparency, Dorking, DNS Aggregators, ASN Enumeration, ...
- Thu thập chủ động (active): gửi các yêu cầu tới tên miền mục tiêu để tìm kiếm các tên miền phụ. Phương pháp này tốn nhiều thời gian và công sức hơn, nhưng có thể thu được nhiều thông tin hơn. Phương pháp này bao gồm các kỹ thuật: DNS Brute Forcing, DNS Zone Transfer, Subdomain Permutation,...

Cấu hình Scan Engine mặc định sử dụng các công cụ mã nguồn mở: `subfinder`, `amass-passive`, có thể kèm với các API của các bên thứ ba để tăng hiệu quả tìm kiếm, chúng đều có hiệu năng cao, nhanh và dễ tích hợp.

Dữ liệu đầu ra của mỗi công cụ sẽ được lưu vào các tệp tin tương ứng, sau đó tổng hợp lại, loại bỏ trùng lặp, các tên miền wildcard (phân giải ra được nhưng không hợp lệ). Sau đó chúng được chuẩn hoá thành các đối tượng ORM của Django và lưu vào cơ sở dữ liệu.

==== Hàm `http_crawler`

Thực hiện kỹ thuật thu thập thông tin về các ứng dụng web, sử dụng công cụ đơn nhiệm `httpx` với đầu vào là các tên miền phụ đã tìm được ở trên.

Sau khi xử lý xong toàn bộ dữ liệu đầu vào, các kết quả thu được sẽ được lưu và chuẩn hoá thành các đối tượng ORM sau:

- `IpAddress`: Địa chỉ IP của tên miền phụ, kết quả xác định có phải là CDN không.
- `Endpoint`: lưu trữ URL, status code, tiêu đề, độ dài, định dạng của phản hồi, các bản ghi DNS dạng CNAME.
- `Technology`: các công nghệ được sử dụng trên ứng dụng web.

==== Hàm `grab_screenshot`

Thực hiện kỹ thuật chụp màn hình các ứng dụng web. Nhận đầu vào là danh sách các địa chỉ url. Công cụ đơn nhiệm được sử dụng ở đây là `eyewitness`.

`eyewitness` được viết bằng ngôn ngữ Python, có hơn 5300 Github Star [23]. Ngoài chức năng chính là chụp ảnh màn hình, nó còn giúp thu thập thông tin máy chủ và rà quét lỗ hổng mật khẩu mặc định theo 1 danh sách signature có sẵn [24].

Các địa chỉ url từ tệp tin `alive.txt` sẽ được `eyewitness` mở lên bằng trình duyệt headless thông qua webdriver của thư viện Selenium. Dữ liệu đầu ra sẽ được lưu trong thư mục screenshots bao gồm các ảnh chụp, tệp tin Requests.csv, các tệp tin .html, .js, .css tải về từ trang web,... Hàm `grab_screenshot()` sẽ dựa theo thông tin ảnh xạ url với đường dẫn của ảnh chụp để lưu trữ vào trường `screenshot_path` của đối tượng orm Subdomain tương ứng. Cuối cùng, ngoại trừ các tệp tin ảnh chụp, các tệp tin khác sẽ bị xóa bỏ để tiết kiệm bộ nhớ.

==== Hàm `port_scanning`

Thực hiện dò quét cổng mở bằng các công cụ:

- `naabu`: được tài trợ và phát triển bởi Project Discovery, viết bằng ngôn ngữ Go, có hơn 3,3 nghìn GitHub Star [25]. Được xây dựng với tiêu chí ổn định, đơn giản và tốc độ nhanh, công cụ này tập trung vào việc xác định trạng thái của cổng có phải là mở hay không. Ngoài ra nó còn giúp việc loại bỏ các địa chỉ IP bị trùng lặp sau quá trình phân giải các tên miền đầu vào. Với cấu hình Scan Engine cơ bản, naabu sẽ được khởi chạy ở chế độ chỉ rà quét top 1000 cổng phổ biến nhất và loại trừ các IP là CDN (dựa trên thư viện `projectdiscovery/cdncheck`).

- `whatportis`: được viết bằng ngôn ngữ Python, có hơn 600 Github Star [26]. Công cụ này giúp việc định danh dịch vụ bằng chạy theo phương pháp thụ động. Cụ thể, thay vì xác định dựa trên dữ liệu phản hồi, công cụ này sẽ dựa trên cơ sở dữ liệu từ IANA để xác định tên dịch vụ thường được sử dụng ở cổng đó. Phương pháp này thường có độ chính xác thấp, nhưng bù lại có tốc độ rất nhanh

Dữ liệu đầu ra sẽ được chuyển thành các đối tượng ORM `Port` để lưu trữ.

==== Hàm `vulnerability_scan`

Thực hiện các kỹ thuật rà quét lỗ hổng đơn giản. Hàm này sử dụng công cụ `Nuclei`, với các template kiểm tra các lỗ hổng công khai đơn giản, hoặc các lỗ hổng bí mật trong hệ tri thức của người kiếm thử xâm nhập:

- Lỗ hổng lộ lọt các tệp tin nhạy cảm: `.git/config`, `.env`, `web.bak`,... 
- Sử dụng các template của `project-discovery/nuclei-templates` để rà quét các lỗ hổng CVE đã có sẵn template, hoặc tự tạo.

Người dùng có thể thay đổi các giá trị như `template`, `severity` trong cấu hình YAML của Scan Engine để chỉ định các nhóm template muốn rà quét, như nhóm CVE, takeover, critical,...

Dữ liệu đầu ra sẽ được chuyển thành các đối tượng ORM `Vulnerability` để lưu trữ.

== Tính năng tổ chức, truy vấn và sắp xếp dữ liệu

Dữ liệu thu thập được từ quá trình Trinh sát thông tin sẽ được lưu trữ, tổ chức thành các Project, theo sự phân bố mục đích của người kiểm thử. Mỗi Project có thể chứa dữ liệu của nhiều root domain. Thông qua giao diện web, người kiểm thử có thể dễ dàng truy vấn, lọc dữ liệu theo các tiêu chí như tên miền, địa chỉ IP, trạng thái của các tên miền phụ, các lỗ hổng đã được phát hiện. 

== Tính năng xuất báo cáo tự động

Dữ liệu thu thập được từ quá trình Trinh sát thông tin sẽ được xuất ra dưới dạng báo cáo PDF. Báo cáo này sẽ bao gồm các thông tin như tên miền, địa chỉ IP, các tên miền phụ đã tìm được, các ứng dụng web đã phát hiện, các cổng mở, các lỗ hổng đã phát hiện, có thể tuỳ chỉnh theo mục đích của tổ chức kiểm thử xâm nhập. Báo cáo này có thể được gửi tới người kiểm thử xâm nhập qua email hoặc tải về trực tiếp từ giao diện web để gửi cho khách hàng.