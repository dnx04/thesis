#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Thực nghiệm và đánh giá <chuong4>
]

#show: body => first_line_indent_all_body(body)

== Môi trường thực nghiệm

=== Cấu hình phần cứng

Hiện tại, hệ thống đang được triển khai thử nghiệm trên máy cá nhân với cấu hình như sau, được triển khai tự động bằng Docker gồm ứng dụng Web, cơ sở dữ liệu và message queue.

- RAM: 16GB
- CPU: Intel i7-12700T (20 CPUs)

=== Tham số và dữ liệu kiểm thử

Cấu hình Scan Engine được sử dụng trong thực nghiệm như sau:

#grid(
  columns: 2,
  gutter: 3pt,
  image("image-8.png"),
  image("image-9.png")
)

Tên miền gốc mục tiêu trong kịch bản được lấy từ nhiều nguồn khác nhau. Để đảm bảo tuân thủ các chính sách về an toàn thông tin và bảo mật, hạn chế ảnh hưởng đối với hệ thống, quá trình thực nghiệm sẽ chỉ gồm các giai đoạn là quét tên miền, IP, dò quét cổng mở và xác định thu thập thông tin ứng dụng Web.

== Kết quả và đánh giá

Kết quả cho thấy ứng dụng hoạt động đúng với mục tiêu đề ra. Các module có khả năng xử lý đúng theo như thiết kế. 