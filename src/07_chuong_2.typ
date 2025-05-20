#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Các khái niệm cơ sở <chuong2>
]

#show: body => first_line_indent_all_body(body)

== Penetration Testing

Trong thế giới CNTT ngày nay, máy chủ, thiết bị số và hệ thống mạng luôn tiềm ẩn vô số lỗ hổng, từ khai thác phần mềm ở cấp độ thấp đến tấn công thẳng vào các dịch vụ mạng. Kiểm thử xâm nhập là một hình thức bảo đảm an toàn thông tin: các chuyên gia được ủy quyền sẽ tiến hành các cuộc tấn công mô phỏng, săn lùng và phơi bày những lỗ hổng tiềm ẩn nhất trong hệ thống trước khi kẻ xấu kịp lợi dụng.

== Hacking

Hầu hết các cuộc tấn công đều xoay quanh hai giai đoạn then chốt: thu thập thông tin (reconnaissance) và khai thác (exploitation).

Trước hết, hacker sẽ tiến hành khảo sát mục tiêu: quét cổng (port scanning), lập bản đồ website để khám phá thư mục gốc, xác định tham số đầu vào của các script phía server,... Thăm dò hệ thống để thu thập thông tin cần thiết nhằm xác định sự hiện diện của một lỗ hổng cụ thể thường là nút thắt trong quá trình tấn công. Kẻ tấn công thường phải dựa vào một loạt các kỹ năng, từ logic con người, trực giác, đến chuyên môn kỹ thuật và kinh nghiệm trước đây.

Sau khi khai thác thành công, kẻ tấn công có thể tiếp tục theo nhiều cách khác nhau tùy thuộc vào mục đích của cuộc tấn công. Chúng có thể giữ một kênh truy cập trái phép mở tới mục tiêu, trích xuất thông tin riêng tư hoặc được bảo vệ, hoặc sử dụng mục tiêu làm bàn đạp để thực hiện các cuộc tấn công tiếp theo.

== Red Team

Ra đời từ việc học hỏi các chiến lược tấn công thực tế, Red Team là một đội ngũ chuyên gia an ninh mạng giả lập thành địch thủ, tấn công như hacker chuyên nghiệp để đánh giá khả năng phòng thủ của các tổ chức. Quá trình này không chỉ nhằm tìm ra lỗ hổng kỹ thuật mà còn đánh giá quy trình, con người và công cụ an ninh đang vận hành, từ đó cung cấp các kịch bản tấn công thành công cùng khuyến nghị cải tiến toàn diện.

Vai trò của Red Team không chỉ gói gọn trong việc “chọc thủng” hệ thống mà còn giúp tổ chức định hình văn hoá an ninh, nâng cao ý thức cảnh giác tại mọi cấp độ nhân sự. Bên cạnh đó, kết quả từ Red Team thường là báo cáo chi tiết về đường đi tấn công (attack path), thời gian trung bình để phát hiện (MTTR) và các điểm cần cải thiện, từ đó đội ngũ phòng thủ có cơ sở để xây dựng quy trình phát hiện và phản hồi sâu sát hơn.

Hiện nay, có xuất hiện một xu hướng mới trong các tổ chức Red Team, đó là Red Team chủ động (Continuous Automated Red Teaming - CART). Các cuộc tấn công được thực hiện liên tục thay vì định kỳ, tự động khám phá tài sản mới, ưu tiên lỗ hổng dựa trên mức độ rủi ro và triển khai tự động hoá các kỹ thuật tấn công mô phỏng theo kịch bản thực tế. Quá trình CART thường bao gồm việc tích hợp với khung MITRE ATT&CK để mô phỏng kỹ thuật, chiến thuật và quy trình (TTP) của địch thủ, từ giai đoạn xâm nhập ban đầu đến hành động cuối cùng, giúp tạo ra các “đường dẫn tấn công” (kill chains) rõ ràng. 

== Attack Surface Management

Như đã nói ở trên, bước trinh sát thông tin là nút thắt rất quan trọng trong các chiến dịch Red Team.

Một trong những công cụ hữu ích phục vụ cho các tổ chức Red Team chủ động là hệ thống quản lý bề mặt tấn công (Attack Surface Management - ASM). Hệ thống này giúp tổ chức phát hiện, phân tích và quản lý các lỗ hổng bảo mật trong hệ thống của mình. ASM cung cấp cái nhìn tổng quan về bề mặt tấn công của tổ chức, từ đó giúp các chuyên gia an ninh mạng xác định các điểm yếu và rủi ro tiềm ẩn.

Bề mặt tấn công của một tổ chức bao gồm tất cả các thông tin của tổ chức công khai (một cách chủ động hoặc bị động) ra ngoài Internet, trong đó chủ yếu có tên miền, IP, dịch vụ web, hệ thống, ứng dụng, cũng như các thông tin OSINT khác chẳng hạn như thông tin về nhân viên, tài khoản, mật khẩu. Việc quản lý và giúp truy vấn nhanh các thông tin này để nhanh chóng đưa ra các quyết định tiếp theo, cũng như báo cáo các lỗ hổng cho các tổ chức là rất quan trọng.
