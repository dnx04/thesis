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

- *Web Application:* ứng dụng web sử dụng framework Django. Thành phần này đóng vai trò là ứng dụng web xử lý trực tiếp hầu hết các chức năng của một trang web thông thường như quản lý người dùng, quản lý mục tiêu, giao diện ứng dụng,... Khi người kiểm thử xâm nhập gửi lên yêu cầu trinh sát thông tin về một đối tượng, ứng dụng sẽ chỉ lưu trữ đối tượng này trong Database và Message Queue rồi lập tức trả về trạng thái đã tiếp nhận. Quá trình xử lý đối tượng sau đó sẽ được thực thi bởi Celery Worker.

- *Database:* Dữ liệu về người dùng, các mục tiêu,... cùng toàn bộ kết quả thu thập được sẽ được lưu trữ trong hệ quản trị cơ sở dữ liệu PostgreSQL. Đây là một trong những hệ quản trị cơ sở dữ liệu phổ biến nhất, có độ tin cậy cao. 

- *Message Queue:* Redis được chọn để đóng vai trò làm hàng đợi cho các tác vụ cần được xử lý bất đồng bộ trong hệ thống. Đây là một trong những kho lưu trữ dữ liệu dạng key-value có tốc độ cao nhất hiện nay. Các tác vụ sẽ được thư viện Celery tuần tự hóa (serialization) dưới định dạng JSON với nội dung bao gồm tên hàm, các tham số đầu vào,... rồi gửi tới đây.

- *Task Executor và Task Scheduler:* Celery Worker là một phần của thư viện Celery Python. Thư viện này cho phép xử lý liên tục các công việc được lấy từ Message Queue. Đây là thành phần chính thực hiện quá trình Trinh sát thông tin. Celery Worker cũng được kết nối trực tiếp tới Database thông qua các đối tượng ORM để nhanh chóng lưu trữ các kết quả thu được. Scheduler sử dụng Celery Beat sẽ thực hiện quét theo lịch trình xác định.

#figure(
  image("principle.png"),
  caption: [Ứng dụng cơ chế Asynchronous Task Queue bằng tích hợp Redis và Celery],
) <principle>

Hệ thống ứng dụng cơ chế Asynchronous Task Queue. Cơ chế này cho phép các tác vụ nặng nhọc được xử lý một cách bất đồng bộ bởi thành phần Celery Worker, tách biệt so với ứng dụng web Django. Số lượng Celery Worker cũng có thể được mở rộng theo chiều ngang. Nhờ vậy, người dùng vẫn có thể sử dụng trơn tru các tính năng khác của ứng dụng trong lúc các giai đoạn của Trinh sát thông tin đang được thực hiện.

== Các cấu phần chức năng chính

=== Scan Engine

Để có thể sử dụng chức năng Trinh sát thông tin thì người dùng cần phải cung cấp 2 thông tin: tên miền mục tiêu và cấu hình Scan Engine muốn thực thi. Scan Engine giống như là một bản thiết kế chuỗi các công việc sẽ được thực thi nối tiếp nhau, dữ liệu đầu ra của công việc này có thể là dữ liệu đầu vào của công việc khác. Một cấu hình Scan Engine thông thường sẽ gồm các phần sau:

1. Tìm kiếm các tên miền phụ (Subdomain Discovery)
2. Xác định các ứng dụng web (Http Crawler)
3. Chụp ảnh màn hình các ứng dụng web (Grab Screenshot)
4. Dò quét các cổng mở (Port Scan)
5. Rà quét các lỗ hổng đơn giản (Vulnerability Scan)

Người kiểm thử xâm nhập có thể dễ dàng bật tắt các bước trên với giao diện web đơn giản hoặc tùy chỉnh sâu bằng ngôn ngữ YAML, ví dụ như: chọn tập các công cụ đơn nhiệm sẽ sử dụng, số thread (luồng CPU), đường dẫn tệp từ từ điển (wordlist),...