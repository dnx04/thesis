#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Các khái niệm cơ sở <chuong2>
]

#show: body => first_line_indent_all_body(body)

== Các hình thức đánh giá an toàn thông tin

Đánh giá an toàn thông tin là một phần quan trọng trong chiến lược bảo vệ an ninh mạng một cách chủ động. Các cuộc tấn công và xâm nhập mạng ngày càng tinh vi và phức tạp hơn, điều này đòi hỏi những người kiểm thử xâm nhập phải sử dụng nhiều kỹ thuật tấn công khác nhau để tìm ra các lỗ hổng trong hệ thống của họ trước khi kẻ tấn công khác làm điều đó. Các hình thức đánh giá an toàn thông tin hiện nay có thể chia thành 3 loại chính:

=== Kiểm thử xâm nhập (Penetration Testing)

Là hình thức đánh giá phổ biến nhất. Phạm vi mục tiêu của hình thức này thường khá nhỏ, có thể chỉ là một ứng dụng, một trang web, thường được thực hiện trong thời gian ngắn khoảng 1-2 tuần. Mục đích của Penetration Testing là để tìm ra các lỗ hổng ở tất cả các mức độ trên các bề mặt bên ngoài cùng của hệ thống.

=== Red Team

Ra đời từ việc học hỏi các chiến lược tấn công thực tế, Red Team là một đội ngũ chuyên gia an ninh mạng giả lập thành địch thủ, tấn công như hacker chuyên nghiệp để đánh giá khả năng phòng thủ của các tổ chức. Quá trình này không chỉ nhằm tìm ra lỗ hổng kỹ thuật mà còn đánh giá quy trình, con người và công cụ an ninh đang vận hành, từ đó cung cấp các kịch bản tấn công thành công cùng khuyến nghị cải tiến toàn diện.

Thời gian thực hiện Red Team có thể kéo dài hàng tháng, thậm chí là hàng năm, là các chiến dịch có quy mô bài bản. Hình thức này chỉ yêu cầu những người thực hiện không gây ra ảnh hưởng tới các dịch vụ đang chạy và người dùng thực tế, còn các kỹ thuật tấn công không bị hạn chế, có thể sử dụng mọi thủ đoạn như cài đặt mã độc, spam email, lừa nhân viên bằng kỹ thuật Social Engineering,... Người kiểm thử xâm nhập cũng được phép tấn công bất kỳ tài nguyên trực tuyến nào thuộc sở hữu của hệ thống thông tin của khách hàng. Sau khi phát hiện được các lỗ hổng có mức độ nghiêm trọng và cao trên các tài nguyên ở bề mặt bên ngoài, người kiểm thử xâm nhập sẽ lợi dụng chúng để tiếp tục tấn công leo thang vào các máy chủ nội bộ bên trong. Cho đến khi đạt được mục tiêu cuối cùng là xâm nhập thành công vào các máy chủ tối quan trọng như Domain Controller, Core Banking,... thì mới dừng lại.

=== Bug Bounty

Là hình thức mở rộng của Penetration Testing nhưng mang tính công khai hơn và phạm vi cũng rộng hơn, dưới dạng các chương trình tìm kiếm lỗ hổng có phần thưởng. Do lượng các tài nguyên trực tuyến hiện nay được gia tăng với tốc độ nhanh chóng, dẫn đến các bề mặt tấn công cũng ngày càng được mở rộng. Nhiều tổ chức, doanh nghiệp tuy đã có đội ngũ an toàn thông tin nội bộ nhưng vẫn không thể đảm bảo bao phủ hết lượng tài nguyên khổng lồ. Do đó, họ sẵn sàng tổ chức các chương trình trao thưởng cho bất kỳ ai tìm thấy và báo cáo lỗ hổng bảo mật có thể bị kẻ xấu khai thác trong bất kỳ sản phẩm nào của họ. Các phần thưởng thường là một số tiền tương ứng với mức độ ảnh hưởng của lỗ hổng được báo cáo. Xu hướng này đã và đang lan rộng trong những năm gần đây, dẫn đến sự hình thành của các nền tảng trung gian kết nối giữa tổ chức, doanh nghiệp với những nhà kiểm thử xâm nhập trên toàn thế giới. Các nền tảng quốc tế nổi tiếng nhất hiện nay là HackerOne, Bugcrowd và Intigriti. Ở Việt Nam cũng đã có các nền tảng như SafeVuln, WhiteHub,...

== Trinh sát thông tin (Reconnaissance)

Trinh sát thông tin (hay còn gọi là Reconnaissance, Information Gathering) là công việc đầu tiên, bắt buộc phải thực hiện trong bất kỳ hình thức đánh giá an toàn thông tin nào. Đây là quá trình thu thập thông tin về hệ thống thông tin mục tiêu và tìm kiếm các tài nguyên trực tuyến tiềm năng trước khi tiến hành đánh giá, tấn công cụ thể. Nó giúp người kiểm thử xâm nhập có cái nhìn tổng quan về mục tiêu, những bề mặt tấn công có thể được khai thác, cũng như xác định các phương thức tấn công có thể sử dụng.

Trong các hình thức đánh giá an toàn thông tin, đặc biệt là Red Team và Bug Bounty, phạm vi diện rộng (Wide Scope) thường được các tổ chức, doanh nghiệp lựa chọn. Với phạm vi này, việc kiểm thử xâm nhập có thể bao quát toàn bộ các thành phần của hệ thống thông tin, cho phép người thực hiện có thể kiểm tra, khám phá thêm nhiều hướng tấn công mới. Thông tin về mục tiêu mà tổ chức, doanh nghiệp cung cấp thường chỉ đơn giản là tên của một hoặc nhiều tên miền gốc (root domain) cần được kiểm thử. Với phạm vi này, vai trò của Trinh sát thông tin càng trở nên quan trọng hơn. Một tên miền gốc như trên có thể sở hữu tới hàng chục nghìn các tên miền phụ. Người kiểm thử xâm nhập không thể đánh giá lần lượt toàn bộ, mà phải thực hiện Trinh sát thông tin để có thể xác định các tài nguyên cần được ưu tiên.

=== Bề mặt tấn công (Attack Surface)

#figure(
  image("image-10.png"),
  caption: [Bề mặt tấn công số của tổ chức, có thể quản lý bằng External Attack Surface Management (EASM)],
)


Bề mặt tấn công của một tổ chức bao gồm tất cả các thông tin của tổ chức công khai (một cách chủ động hoặc bị động) ra ngoài Internet, trong đó chủ yếu có tên miền, IP, dịch vụ web, hệ thống, ứng dụng, cũng như các thông tin OSINT khác chẳng hạn như thông tin về nhân viên, tài khoản, mật khẩu... Các tài nguyên này có mối liên kết với nhau, từ tài nguyên này có thể khám phá ra tài nguyên khác qua sơ đồ sau:

#figure(
  image("image-5.png"),
  caption: [Minh hoạ sự liên kết giữa các tài nguyên trực tuyến],
) <attack-surface>

=== Attack Surface Management (ASM)

Như đã nói ở trên, bước trinh sát thông tin là nút thắt rất quan trọng trong các chiến dịch Red Team.

Một trong những công cụ hữu ích phục vụ cho các tổ chức Red Team là hệ thống quản lý bề mặt tấn công (Attack Surface Management - ASM). Hệ thống này giúp tổ chức phát hiện, phân tích và quản lý các lỗ hổng bảo mật trong hệ thống của mình. ASM cung cấp cái nhìn tổng quan về bề mặt tấn công của tổ chức, từ đó giúp các chuyên gia an ninh mạng xác định các điểm yếu và rủi ro tiềm ẩn. Trong quy trình Red Team chủ động, ASM phục vụ chính trong công cuộc trinh sát thông tin, là hệ thống tập trung dữ liệu trinh sát thông tin và từ các nguồn bên thứ ba, giúp người kiểm thử xâm nhập có thể dễ dàng tìm kiếm, phân tích và quản lý các thông tin này. ASM cũng có thể được sử dụng để theo dõi và phát hiện các thay đổi trong bề mặt tấn công của tổ chức theo thời gian thực, từ đó giúp tổ chức nhanh chóng phát hiện và ứng phó với các mối đe dọa mới.

#figure(
  image("image-4.png"),
  caption: [Vòng đời của Red Team, và vai trò của ASM trong quy trình Red Team],
) <red-team-lifecycle>


