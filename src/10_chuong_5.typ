#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Đề xuất phương pháp MPBoot-RL <chuong5>
]

#show: body => first_line_indent_all_body(body)

== Áp dụng ACO vào MPBoot2

Như đã phân tích ở @spr-vs-tbr, dù leo đồi sử dụng TBR5 nhìn chung có cải thiện hơn so với sử dụng SPR6, nhưng vẫn có nhiều bộ dữ liệu mà SPR6 tỏ ra hiệu quả hơn so với TBR5. Không những thế, với những bộ dữ liệu dễ, sử dụng thuật toán NNI khi đó sẽ tăng tốc độ tìm kiếm đáng kể. Vì những lí do trên, việc kết hợp NNI, SPR và TBR có tiềm năng cải thiện hiệu suất thuật toán, cải thiện điểm số, và từ đó tăng cường độ chính xác của bootstrap. Kết hợp các phép biến đổi cây có thể được thực hiện ở bước leo đồi ở pha khám phá của MPBoot (xem @mpboot-iter).

Chúng tôi đề xuất thuật toán MPBoot-RL để tăng cường pha khám phá (pha 2) của thuật toán MPBoot2 bằng cách sử dụng một phương pháp học tăng cường, cụ thể là giải thuật tối ưu đàn kiến (ACO). Thuật toán MPBoot-RL thay thế quá trình tối ưu hóa cây, trước đây chỉ sử dụng leo đồi SPR, bằng việc chọn một trong ba phép toán biến đổi cây: NNI, SPR và TBR (xem @mpboot-rl).

#figure(
  image("/images/mpboot-rl.png"),
  caption: [Minh họa cho khung thuật toán MPBoot-RL],
) <mpboot-rl>

=== Cấu trúc đồ thị

Cấu trúc đồ thị bao gồm một đỉnh khởi đầu $V_s$, một đỉnh kết thúc $V_e$ và một lớp giữa. Lớp này bao gồm ba đỉnh biểu diễn việc sử dụng các thuật toán leo đồi NNI, SPR và TBR. Đỉnh khởi đầu $V_s$ sẽ có các cạnh kết nối với ba đỉnh của lớp giữa. Cuối cùng, các đỉnh trong lớp sẽ kết nối với đỉnh kết thúc $V_e$. Tổng cộng, mạng bao gồm 5 đỉnh và 6 cạnh (xem @network-aco). 

#figure(
  image("/images/network.png"),
  caption: [Cấu trúc đồ thị ACO],
) <network-aco>

=== Thông tin heuristic

Thông tin heuristics được cung cấp dưới dạng các tham số đầu vào, bao gồm các chi tiết heuristics cho các thuật toán leo đồi NNI, SPR và TBR. Do đó, thông tin heuristics cho một bước đi của con kiến sẽ được trích xuất tương ứng với đỉnh đích, cụ thể là NNI, SPR hoặc TBR. 

=== Vết mùi pheromone và các quy tắc cập nhật

Thông tin về vết mùi pheromone được đặt trên mỗi cạnh của cấu trúc đồ thị và được cập nhật theo các quy tắc cụ thể được sử dụng.

==== Quy tắc SMMAS

Quy tắc cập nhật của vết pheromone với hệ thống kiến SMMA (Smooth Max-Min Ant System) @do2008pheromone có thể được tổng kết như sau. Ban đầu, pheromone trên tất cả các cạnh được giảm ('bốc hơi') theo tỷ lệ $rho$ $(0 < rho < 1)$. Sau đó, nếu một cạnh thuộc giải pháp tốt nhất được tìm thấy trong thế hệ hiện tại, mức độ pheromone được cập nhật bổ sung tiến gần đến một giá trị tối đa $tau_"max"$; nếu không, nó được điều chỉnh về một giá trị tối thiểu $tau_"min"$.

Chúng tôi đề xuất áp dụng quy tắc SMMAS vào thuật toán MPBoot-ML như sau. Trong mỗi thế hệ kiến của thuật toán MPBoot-RL, quá trình cập nhật bao gồm một quy trình lựa chọn cẩn thận các giải pháp tốt nhất nhằm tối đa hóa điểm MP. Thuật toán xác định các con kiến có giải pháp tìm ra một cây có điểm MP tốt hơn hoặc bằng với điểm MP tốt nhất hiện tại đã tìm được của thuật toán. Những giải pháp này được coi là đáng kỳ vọng và được chọn cho quá trình cập nhật tiếp theo. Tuy nhiên, nếu không có giải pháp nào đáp ứng tiêu chí này, phép biến đổi cây nhanh nhất (phép NNI) sẽ được chọn.

Sau khi thế hệ con kiến hoàn thành, thuật toán tiến hành cập nhật vết mùi pheromone trên các cạnh. Tất cả các cạnh tồn tại trong ít nhất một trong các giải pháp tốt được lựa chọn được cập nhật lên mức pheromone tối đa $tau_"max"$, phản ánh sự đóng góp của chúng vào các giải pháp có triển vọng.

$ tau_e arrow.l.long (1- rho) dot.c tau_e + rho dot.c tau_"max" $

Ngược lại, các cạnh không thuộc bất kỳ giải pháp được lựa chọn nào sẽ được cập nhật xuống mức pheromone tối thiểu $tau_"min"$.

$ tau_e arrow.l.long (1- rho) dot.c tau_e + rho dot.c tau_"min" $

Quá trình này hiệu quả trong việc củng cố các đường đi liên quan đến các giải pháp thành công và ngăn chặn những đường đi không đóng góp đáng kể vào việc cải thiện điểm MP.

==== Quy tắc thử nghiệm SMMAS-multiple

Quy tắc thử nghiệm SMMAS-multiple giới thiệu một sự tinh chỉnh cho mô hình cập nhật vết mùi pheromone đã được mô tả trước đó trong thuật toán MPBoot-ACO. Khác với quy tắc SMMAS ban đầu, nơi mỗi cạnh được cập nhật một lần duy nhất trong một thế hệ kiến, quy tắc SMMAS-multiple thích nghi với sự tham gia của một cạnh trong nhiều giải pháp được chọn. 

Theo quy tắc SMMAS-multiple, tiêu chí lựa chọn để xác định các giải pháp triển vọng vẫn được giữ nguyên. Tuy nhiên, khác với quy tắc SMMAS gốc, cách tiếp cận này cho phép cạnh tham gia trong nhiều giải pháp được chọn được cập nhật nhiều lần lên mức pheromone tối đa. Cụ thể, nếu một cạnh đóng góp $k$ lần trong các giải pháp được chọn, nó sẽ được cập nhật $k$ lần để đạt đến mức pheromone tối đa $tau_"max"$.

$ tau_e arrow.l.long (1- rho) dot.c tau_e + rho dot.c tau_"max" space space "(lặp lại" k "lần)" $ 

Các cạnh không đóng góp vào bất kỳ giải pháp được chọn nào vẫn tuân theo quy tắc cập nhật SMMAS gốc, được cập nhật một lần đến mức pheromone tối thiểu $tau_"min"$.

Bằng cách cho phép các cạnh tích lũy cập nhật dựa trên sự tham gia của chúng trong các giải pháp được chọn, cơ chế cập nhật SMMAS-multiple củng cố sự ảnh hưởng của các cạnh liên quan đến các giải pháp đã thể hiện thành công liên tục qua nhiều vòng lặp.

=== Quy trình bước đi ngẫu nhiên để xây dựng giải pháp

Con kiến di chuyển tuần tự từ $V_s$ đến lớp đầu tiên và sau đó trở lại $V_e$. Giả sử con kiến đang ở đỉnh $A$, nó sẽ di chuyển ngẫu nhiên dọc theo một cạnh đến một đỉnh trong lớp tiếp theo. Xác suất cho con kiến tại đỉnh $A$ di chuyển đến đỉnh $B$ tỉ lệ phụ thuộc vào mức độ của vết mùi pheromone và thông tin heuristic của đường đi $A arrow.r B$. 

$ "prob"_(A arrow.r B) = (tau_(A arrow.r B) dot.c eta_B) / (sum_(C in "adj"(A)) tau_(A arrow.r C) dot.c eta_C) $
trong đó:
- $"prob"_(A arrow.r B)$ là xác suất con kiến ở đỉnh $A$ di chuyển đến đỉnh $B$.
- $tau_(A arrow.r B)$ là mức độ pheromone của cạnh từ $A$ đến $B$.
- $eta_B$ là thông tin heuristic của đỉnh $B$.
- $"adj"(A)$ là tập các đỉnh nối với $A$.

=== Cài đặt

== Đánh giá thực nghiệm
=== Cài đặt thực nghiệm
#pagebreak()
