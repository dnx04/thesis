#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Giới thiệu
]
#show: body => first_line_indent_all_body(body)

== Tổng quan

Hiện nay, công cuộc chuyển đổi số đã và đang diễn ra rất mạnh mẽ trong mọi lĩnh vực của cuộc sống. Hầu hết các tổ chức, doanh nghiệp từ nhỏ đến lớn đều sở hữu các hệ thống, ứng dụng trực tuyến cho dù chỉ là một trang web tĩnh hay là một ứng dụng đa nền tảng phức tạp chạy trên hàng triệu thiết bị. Bên cạnh đó, các tổ chức tội phạm ngày càng tinh vi và nguy hiểm khi luôn tìm cách áp dụng các công nghệ cao vào các mục đích phá hoại, đánh cắp thông tin, tống tiền,... Hệ thống thông tin càng lớn thì càng dễ bị tấn công và những kẻ tấn công thì đôi khi chỉ cần lợi dụng một sai lầm nhỏ từ các nhà phát triển là đã có thể gây ra các tác hại không lồ. Vì lý do này, nhiệm vụ đánh giá an toàn thông tin luôn có ý nghĩa rất quan trọng.

Trong mọi hình thức đánh giá an toàn thông tin, việc đầu tiên bắt buộc phải thực hiện đó là Trinh sát thông tin. Công việc này bao gồm nhiều giai đoạn khác nhau, trong đó đặc trưng là: Thu thập tên miền phụ, xác định địa chỉ IP, dò quét các cổng mở, xác định và thu thập thông tin các ứng dụng web, rà quét các lỗ hổng đơn giản. Mục tiêu của nó là giúp người kiểm thử xâm nhập khám phá ra nhiều nhất có thể các tài nguyên trực tuyến mà mục tiêu sở hữu, từ đó định hình được cấu trúc và các bề mặt tấn công (attack surface) để tập trung đánh giá. Chính vì vậy mà Trinh sát thông tin đóng vai trò rất quan trọng, là tiền đề thiết yếu cho cả quá trình đánh giá an toàn thông tin. Tuy nhiên, công việc này thường cần đầu tư rất nhiều thời gian và công sức do lượng tài nguyên trực tuyến mà các tổ chức, doanh nghiệp ngày nay sở hữu có thể rất lớn, lên tới hàng trăm, hàng nghìn tên miền, ứng dụng web. Do đó, rất nhiều công cụ tự động hóa mã nguồn mở đã được cộng đồng an ninh mạng trên toàn thế giới phát triển và chia sẻ, nhằm giảm thiểu các thao tác lặp đi lặp lại và tăng tốc quá trình Quản lý bề mặt tấn công và trinh sát thông tin.

Hầu hết các công cụ tự động hóa phổ biến nhất đều được cộng đồng công bố trên nền tảng GitHub. Chúng có thể được phân loại thành: các công cụ đơn nhiệm và các ứng dụng đa nhiệm. Công cụ đơn nhiệm thường được phát triển để chuyên biệt, tối ưu cho một trong các giai đoạn của Trinh sát thông tin. Các ứng dụng đa nhiệm có mức độ tự động hóa cao hơn, chúng liên kết các công cụ đơn nhiệm lại theo các mô hình như workflow hay pipeline để thực hiện cả quá trình.

Báo cáo này trình bày chi tiết Dự án xây dựng một hệ thống quản lý bề mặt tấn công cho kiểm thử xâm nhập, dưới dạng một ứng dụng Web đa nhiệm, tập trung cho các đội ngũ kiểm thử xâm nhập. Hệ thống này được phát triển dựa trên các công cụ mã nguồn mở phổ biến nhất hiện nay, theo kiến trúc micro-services để đảm bảo tính linh hoạt và khả năng mở rộng.

Hệ thống thực hiện quy trình trinh sát chủ động và thụ động song song, tận dụng các công cụ nguồn mở và API của các dịch vụ OSINT bên thứ ba để thu thập thông tin mạng lưới và tên miền phụ, kết hợp với các công cụ quét cổng như naabu, masscan để xác định các dịch vụ đang chạy. Kết quả thu thập được lưu trữ tập trung, cho phép truy vấn nhanh các mối quan hệ giữa địa chỉ IP, tên miền, máy chủ và ứng dụng web, làm giàu dữ liệu thông qua các module fingerprinting, probing... hỗ trợ các đội nhóm kiểm thử xâm nhập trong việc lập kế hoạch và thực hiện đánh giá an toàn thông tin.

Giao diện người dùng của hệ thống được thiết kế dưới dạng dashboard web, cung cấp những biểu đồ trực quan về quy mô bề mặt tấn công, số lượng cổng mở, dịch vụ, ứng dụng, cũng như sơ đồ luồng dữ liệu giữa các thành phần. Các báo cáo định kỳ được xuất ra dưới định dạng PDF để kết xuất cho các đối tác và tổ chức.

== Mục tiêu của dự án

Mục tiêu của dự án, là xây dựng một hệ thống quản lý bề mặt tấn công dễ sử dụng và triển khai, phục vụ cho cả mục đích quản lý và đánh giá an toàn thông tin, đáp ứng được các tiêu chí cốt lõi sau:

- Tự động hóa quy trình trinh sát thông tin, giúp tiết kiệm thời gian và công sức cho các đội nhóm kiểm thử xâm nhập.
- Cung cấp một giao diện người dùng thân thiện, dễ sử dụng, giúp người dùng có thể dễ dàng truy vấn và phân tích dữ liệu.
- Hỗ trợ các đội nhóm kiểm thử xâm nhập trong việc lập kế hoạch và thực hiện đánh giá an toàn thông tin.
- Cung cấp các báo cáo định kỳ về tình trạng bề mặt tấn công của tổ chức, giúp các tổ chức có cái nhìn tổng quan về an toàn thông tin, nhất là Shadow IT của đơn vị mình.


