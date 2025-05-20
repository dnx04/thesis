#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Giới thiệu
]
#show: body => first_line_indent_all_body(body)

== Tổng quan

Hiện nay, công cuộc chuyển đổi số đã và đang diễn ra rất mạnh mẽ trong mọi lĩnh vực của cuộc sống. Hầu hết các tổ chức, doanh nghiệp từ nhỏ đến lớn đều sở hữu các hệ thống, ứng dụng trực tuyến cho dù chỉ là một trang web tĩnh hay là một ứng dụng đa nền tảng phức tạp chạy trên hàng triệu thiết bị. Bên cạnh đó, các tổ chức tội phạm ngày càng tinh vi và nguy hiểm khi luôn tìm cách áp dụng các công nghệ cao vào các mục đích phá hoại, đánh cắp thông tin, tống tiền,... Hệ thống thông tin càng lớn thì càng dễ bị tấn công và những kẻ tấn công thì đôi khi chỉ cần lợi dụng một sai lầm nhỏ từ các nhà phát triển là đã có thể gây ra các tác hại không lồ. Vì lý do này, nhiệm vụ đánh giá an toàn thông tin luôn có ý nghĩa rất quan trọng.

Trong mọi hình thức đánh giá an toàn thông tin, việc đầu tiên bắt buộc phải thực hiện đó là Trinh sát. Công việc này bao gồm nhiều giai đoạn khác nhau, trong đó đặc trưng là: Thu thập tên miền phụ, xác định địa chỉ IP, dò quét các cổng mở, xác định và thu thập thông tin các ứng dụng web, rà quét các lỗ hổng đơn giản. Mục tiêu của nó là giúp người kiểm thử xâm nhập khám phá ra nhiều nhất có thể các tài nguyên trực tuyến mà mục tiêu sở hữu, từ đó định hình được cấu trúc và các bề mặt tấn công (attack surface) để tập trung đánh giá. Chính vì vậy mà Trinh sát thông tin đóng vai trò rất quan trọng, là tiền đề thiết yếu cho cả quá trình đánh giá an toàn thông tin. Tuy nhiên, công việc này thường cần đầu tư rất nhiều thời gian và công sức do lượng tài nguyên trực tuyến mà các tổ chức, doanh nghiệp ngày nay sở hữu có thể rất lớn, lên tới hàng trăm, hàng nghìn tên miền, ứng dụng web. 

== Mục tiêu của dự án

Mục tiêu của dự án, là xây dựng một hệ thống quản lý bề mặt tấn công mã nguồn mở cho các tổ chức. Hệ thống đáp ứng được các tiêu chí cốt lõi sau

== Báo cáo dự án

Báo cáo này được trình bày theo như sau:

1. Chương 1: Giới thiệu dự án
2. Chương 2: Trình bày các khái niệm cơ sở về pentest, Red Team và ASM
3. Chương 3: Thiết kế và triển khai hệ thống ASM phục vụ cho Red Team
4. Chương 4: Kết quả thực nghiệm
5. Chương 5: Các định hướng phát triển