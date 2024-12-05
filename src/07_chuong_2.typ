#import "/template.typ" : *

#[
  #set heading(numbering: "Chương 1.1")
  = Các khái niệm cơ sở <chuong2>
]

#show: body => first_line_indent_all_body(body)

== Bài toán xây dựng cây bootstrap tiến hóa
=== Mô hình bài toán

Bài toán xây dựng cây tiến hóa bootstrap nhận vào một ma trận $A^("data")$ kích thước $n times m$,
đại diện cho $n$ chuỗi, mỗi chuỗi có $m$ ký tự. Mỗi chuỗi trong số $n$ chuỗi này tương ứng
với chuỗi sinh học của một loài đang được nghiên cứu. Các đặc điểm sinh học rất đa dạng và
có thể bao gồm DNA, protein, hình thái học hoặc dữ liệu nhị phân. Ngoài ra, một số $B$ (thông
thường $B=1000$) được cung cấp, đại diện cho số lượng các mẫu bootstrap. Mỗi cây tiến hóa
ứng viên $T$ cho $A^"data"$ là một cây nhị phân có gốc với $n$ lá, trong đó mỗi lá tương
ứng với một chuỗi.

Kết quả đầu ra của bài toán là cây tốt nhất $T^"best"$, giải thích tốt nhất sắp hàng $A^"data"$,
và một tập hợp $beta$ các cây tốt nhất $T^"best"_b$ cho các mẫu bootstrap $A_b$ (với $b = 1, dots , B$).
Mỗi mẫu bootstrap $A_b$ là một mẫu bootstrap của sắp hàng ban đầu $A^"data"$, được tạo ra
với cùng kích thước như sắp hàng ban đầu bằng cách lấy mẫu cột (cho phép lặp lại) đúng $m$ lần
từ sắp hàng ban đầu. Chất lượng của một cây được đánh giá dựa trên một tiêu chí xác định
trước.

Tập hợp các cây bootstrap $beta$ thường được tóm tắt dưới dạng một vectơ tần suất của các
phân hoạch nhị phân được ánh xạ lên $T^"best"$ (xem @boot-example) hoặc dưới dạng một cây
đồng thuận. Hai phương pháp tóm tắt phổ biến là bootstrap chuẩn và bootstrap xấp xỉ.
Phương pháp bootstrap chuẩn @efron1992bootstrap@felsenstein1985confidence xây dựng các cây
trong tập $beta$ một cách độc lập bằng cách thực hiện các lần duyệt không gian tìm kiếm
riêng biệt cho từng mẫu bootstrap. Tần suất được gán cho mỗi phân hoạch nhị phân trên $T^"best"$ được
gọi là giá trị hỗ trợ bootstrap cho cạnh đó.

Do mỗi cây bootstrap được tối ưu bằng cách thực hiện một lần tìm kiếm độc lập trên mỗi sắp
hàng bootstrap, phương pháp này tiêu tốn khá nhiều chi phí tính toán. MPBoot tối ưu bằng
phương pháp bootstrap xấp xỉ, chỉ thực hiện một lần duyệt không gian tìm kiếm duy nhất, và
tập hợp các cây $beta$ được chọn từ các cây đã được đánh giá trong lần tìm kiếm này.

#figure(
  image("/images/boot-example.png"),
  caption: [Ví dụ minh họa tổng hợp kết quả bootstrap],
) <boot-example>

Các nghiên cứu về việc xây dựng cây tiến hóa thường dựa vào hai giả định quan trọng sau
đây @dhar2015maximum:

- Sự tiến hóa giữa các cột trong dữ liệu (trên một cây nhất định) là độc lập.
- Quá trình tiến hóa là độc lập giữa các phân hoạch nhị phân trên cây.

=== Tiêu chuẩn đánh giá cây tiến hóa

Trong bài toán xây dựng cây tiến hóa, ba tiêu chuẩn thường được sử dụng để đánh giá một
cây tiến hóa là:
- Tiêu chuẩn Bayesian
- Tiêu chuẩn Maximum Likelihood
- Tiêu chuẩn Maximum Parsimony

==== Tiêu chuẩn Bayesian

Tiêu chí Bayes sử dụng suy diễn Bayes để đánh giá một cấu trúc cây. Với một vectơ độ dài nhánh $"l"$ và mô hình thay thế $theta$, công thức @bayesian sau đánh giá mức độ phù hợp của cấu trúc cây $T$ với sắp xếp $A^"data"$:

#numbered_equation(
    $ P(T, l, theta | A^"data") = (P(A^"data" | T, l, theta) dot.c P(T, l, theta)) /  P(D) $, 
    <bayesian>
)
Trong đó:
- $P(A^"data" | T, "l", theta)$ là xác suất hợp lý của $A^"data"$ cho cây $T$.
- $P(T, l, theta)$ là xác suất tiên nghiệm.
- $P(D)$ là xác suất biên.

Xác suất hợp lý $P(A^"data" | T, l, theta)$ được tính bằng thuật toán cắt tỉa Felsenstein. Do không gian tìm kiếm rất lớn, tiêu chí Bayes thường được sử dụng cùng các thuật toán Markov Chain Monte Carlo (MCMC) để xấp xỉ.
 
==== Tiêu chuẩn Maximum Likelihood

Ước lượng hợp lý cực đại (Maximum Likelihood Estimation - MLE) là phương pháp ước lượng tham số tối ưu để tối đa hóa xác suất quan sát dữ liệu thực tế dưới một mô hình. Trong xây dựng cây tiến hóa loài, MLE dùng hàm likelihood để tính xác suất dữ liệu trình tự sinh học dọc theo cấu trúc cây và độ dài nhánh.

Hàm likelihood $L(T, l, theta)$ cho sắp xếp dữ liệu $A^"data"$, cấu trúc cây $T$, độ dài nhánh $l$, và mô hình thay thế $theta$ được định nghĩa theo công thức @llh1 (dựa trên giả định về sự tiến hóa của các cột $A^"data"_i$ là độc lập):

#numbered_equation(
    $ L(A^"data" | T, l, theta) = product_(i=1)^n P(A^"data"_i | T, l, theta) $,
    <llh1>
)
Trong đó:
- $A^"data"_i$ là cột thứ $i$ của sắp xếp dữ liệu $A^"data"$,
- $P(A^"data"_i | T, l, theta)$ là xác suất hợp lý cho cột thứ $i$ của sắp xếp dữ liệu.

Xác suất $P(A^"data"_i | T, l, theta)$ được tính qua thuật toán cắt tỉa Felsenstein, là tổng hợp các xác suất chuyển trạng thái dọc theo các nhánh của cây, tính theo công thức @llh2:
#numbered_equation(
    $ P(A^"data"_i | T, l, theta) = sum_x pi_x L_(u)(x) = sum_x pi_x product_v ( sum_y L_(v)(y) dot.c p_(x y)(l_v) ) $,
    <llh2>
)
Trong đó:
- $pi_x$ là tần số ổn định của ký tự $x$,
- $L_(v)(y)$ là xác suất tại nút $v$ giả định ký tự $y$ tại nút đó,
- $p_(x y)(l_v)$ là xác suất chuyển từ ký tự $x$ sang $y$ dọc theo nhánh có độ dài $l_v$.

Phương pháp này giúp tìm ra các tham số cây tiến hóa sao cho xác suất quan sát dữ liệu là cao nhất.

==== Tiêu chuẩn Maximum Parsimony

Tiêu chí Tiết kiệm Tối đa (Maximum Parsimony - MP) sử dụng điểm MP để đánh giá mức độ phù hợp của một cấu trúc cây $T$ trong việc giải thích sắp xếp trình tự $A^"data"$. Điểm MP của $T$ là chi phí tối thiểu của các thay đổi ký tự cần thiết để giải thích các trình tự quan sát tại các nút lá, dựa trên tổ tiên chung gần nhất của chúng. Điểm MP cho toàn bộ sắp hàng được tính theo công thức @mp:

#numbered_equation(
    $ "MP"(T | A^"data") = sum_(i=1)^m "MP"(T | D_i) $,
    <mp>
)

Ở đây, $"MP"(T | D_i)$ là điểm MP của cây $T$ cho cột $D_i$. Điểm MP cho một cột được tính bằng thuật toán Fitch @fitch1971toward (cho các thay đổi có chi phí đồng nhất) hoặc thuật toán Sankoff @sankoff1975minimal (cho các thay đổi có chi phí không đồng nhất).

Trong việc dựng cây tiến hóa, mục tiêu là tìm cây có điểm MP nhỏ nhất cho $A^"data"$, gọi là cây MP.

#figure(
  image("/images/mp-score.png", width: 90%),
  caption: [Ví dụ đơn giản về tiêu chí MP],
)

=== Các kĩ thuật biến đổi cây thông dụng

Khi xây dựng cây tiến hóa, một trong những thách thức lớn là tìm ra cấu trúc cây tối ưu nhất phù hợp với dữ liệu sinh học. Do không gian cây tiến hóa rất rộng lớn (hàm giai thừa của $n$ với cây có $n$ lá), các phương pháp đơn giản như so sánh trực tiếp giữa tất cả các cấu trúc cây có thể không thực tế do chi phí tính toán quá lớn. Vì vậy, các chiến lược heuristics để tìm kiếm cây đủ tốt thường được áp dụng @lemey2009phylogenetic. Từ đây, các kỹ thuật biến đổi cây đã được phát triển để cải thiện hiệu quả tìm kiếm và tối ưu hóa cây tiến hóa.

Các kỹ thuật biến đổi cây giúp thay đổi cấu trúc của cây hiện tại thông qua các phép toán chỉnh sửa cây, nhằm khám phá các cấu trúc cây khác có thể phù hợp hơn với dữ liệu. Những phép toán này giúp tối ưu hóa cây tiến hóa bằng cách điều chỉnh các nhánh và cấu trúc của cây mà không cần phải xây dựng lại cây từ đầu. Trong đó, các kỹ thuật như nearest-neighbor interchange (NNI), subtree pruning and regrafting (SPR), và tree bisection and reconnection (TBR) là những phương pháp biến đổi cây thông dụng trong phân tích tiến hóa.

#figure(
  image("/images/3-operations.png", width: 95%),
  caption: [Minh họa các phép biến đổi cây],
)

==== Nearest Neighbor Interchange (NNI)

Nearest Neighbor Interchange (NNI) là một trong những phép toán cây đơn giản và phổ biến nhất trong phân tích phát sinh loài. Nó liên quan đến việc hoán đổi vị trí của hai nhánh liền kề trong cây. Cụ thể, NNI thực hiện trên một cặp nhánh kề nhau, thay thế chúng bằng hai cấu trúc cây thay thế. Phép toán này có phạm vi hạn chế vì chỉ cho phép thay đổi giữa hai nút liền kề, có nghĩa là nó không khám phá tất cả các khả năng sắp xếp cây. Tuy nhiên, sự đơn giản và chi phí tính toán tương đối thấp khiến nó trở thành phương pháp phổ biến để tối ưu hóa cây.

NNI đặc biệt hữu ích trong việc khám phá nhanh chóng các thay đổi nhỏ trong một phần cây, làm cho nó hiệu quả trong việc cải thiện khả năng (likelihood) hoặc điểm tính toán parsimony của cây mà không cần thay đổi cấu trúc lớn. Phép toán này cũng dễ tính toán, vì chỉ thay đổi cấu trúc của một phần nhỏ trong cây.

#figure(
  image("/images/NNI.png"),
  caption: [Minh họa phép biến đổi cây NNI],
)

==== Subtree pruning and regrafting (SPR)

Subtree Pruning and Regrafting (SPR) là một phép toán cây phức tạp hơn so với NNI. Nó bao gồm ba bước chính:

- Cắt bỏ một nhánh con (prune) khỏi cây (loại bỏ một nhóm các nút và các cạnh nối với chúng).
- Cắm lại nhánh con đã cắt vào một nhánh khác trong cây gốc.

SPR cho phép thực hiện các thay đổi lớn hơn trong cấu trúc cây so với NNI vì nó có thể di chuyển nhánh con qua các phần lớn hơn của cây. Phép toán này mở ra một phạm vi rộng hơn các thay đổi cấu trúc cây, có thể dẫn đến các giải pháp tốt hơn về khả năng (likelihood) hoặc điểm parsimony.

Mặc dù tốn kém về mặt tính toán hơn NNI, SPR có thể cung cấp những cái nhìn sâu hơn về các mối quan hệ phát sinh loài giữa các taxon. Nó đặc biệt hữu ích trong các trường hợp cây có thể có các mối quan hệ phát sinh loài phức tạp, yêu cầu các thay đổi sâu hơn để tối ưu hóa.

#figure(
  image("/images/SPR.png"),
  caption: [Minh họa phép biến đổi cây SPR],
)

==== Tree bisection and reconnection (TBR)

Tree Bisection and Reconnection (TBR) là một trong những phép toán cây mạnh mẽ nhất trong phân tích phát sinh loài, cho phép thực hiện các thay đổi lớn nhất về cấu trúc cây. TBR hoạt động bằng cách chia đôi cây thành hai phần, thường là cắt một cạnh, sau đó kết nối lại hai phần này theo một cấu trúc mới. Phép toán này có thể được thực hiện theo nhiều cách khác nhau, cung cấp một số lượng lớn các khả năng tái kết nối để khám phá.

TBR rất linh hoạt và có khả năng khám phá không gian cây toàn diện hơn so với NNI hoặc SPR. Điều này làm cho nó trở thành phương pháp mạnh mẽ để tối ưu hóa cây phát sinh loài, vì nó có thể tìm ra các cấu trúc cây chính xác hơn, phù hợp với dữ liệu tốt hơn. Tuy nhiên, vì độ phức tạp của nó, TBR tốn kém về mặt tính toán và có thể yêu cầu nhiều tài nguyên và thời gian hơn để thực hiện. Dù vậy, TBR thường được sử dụng trong các trường hợp mà các phương pháp tìm kiếm cây phức tạp hơn là cần thiết để bao quát hết sự đa dạng của các cấu trúc cây có thể có.

#figure(
  image("/images/TBR.png"),
  caption: [Minh họa phép biến đổi cây TBR],
) 

=== Các công trình liên quan
==== Các công trình sử dụng phương pháp bootstrap chuẩn
==== Phương pháp MPBoot

Phương pháp MPBoot sử dụng tiêu chuẩn maximum parsimony (với ưu điểm là tính đơn giản, dễ cài đặt và hiệu quả trong thiết kế cấu trúc dữ liệu) cùng với phương pháp xấp xỉ bootstrap để giải quyết bài toán xây dựng cây bootstrap tiến hóa. Phương pháp xấp xỉ bootstrap trong MPBoot xác định tập hợp $beta$ bằng cách thực hiện một lần tìm kiếm cây trong không gian cây biểu diễn sắp hàng gốc $A^"data"$ (xem @approx-boot). 

#figure(
  image("/images/approx-boot.png", width: 85%),
  caption: [Phương pháp xấp xỉ bootstrap],
) <approx-boot>

Đối với một cây $T$ gặp phải trong quá trình tìm kiếm leo đồi SPR, MPBoot tính toán điểm số của cây này trên từng sắp hàng bootstrap $b$ ($A^"data"_b$), sau đó cập nhật cây bootstrap cho $A^"data"_b$ nếu $T$ có điểm số MP tốt hơn. Vì quy trình này tiêu tốn nhiều thời gian nên cần phải tính toán hiệu quả điểm MP của $T$ trên $A^"data"_b$. Để tối ưu hóa công đoạn này, MPBoot sử dụng Resampling parsimony score (REPS) @hoang2018mpboot cho từng sắp hàng bootstrap (xem @reps).  

Đối với một cây $T$ và điểm MP tại các cột $D_i$ ($"MP"(T | D_i)$) được tính từ $A^"data"$, điểm MP cho $A^"data"_b$ được tính nhanh chóng dưới dạng tổng điểm MP tại các cột tương ứng được sử dụng trong sắp hàng bootstrap $b$:  

$ "MP"(T | A^"data"_b) = sum_(i=1)^k "MP"(T | D_i) dot.c d^b_i $
trong đó $d^b_i$ là tần suất xuất hiện của cột $D_i$ trong $A^"data"_b$. Nhờ vậy, không cần phải tính lại điểm tiết kiệm cho từng cột, từng lần lặp bootstrap và từng cây.

#figure(
  image("/images/reps.png", width: 70%),
  caption: [Minh họa sử dụng kĩ thuật REPS để tính điểm MP của sắp hàng bootstrap],
) <reps>

MPBoot hiện tại cài đặt hai kỹ thuật biến đổi cây bao gồm NNI và SPR, trong đó SPR được sử dụng chủ đạo trong suốt quá trình tìm kiếm của MPBoot.

== Giải thuật đàn kiến (Ant Colony Optimization)

#pagebreak()
