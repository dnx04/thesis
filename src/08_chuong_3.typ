#import "/template.typ" : *
#import "@preview/algo:0.3.4": algo, i, d, comment, code

#[
  #set heading(numbering: "Chương 1.1")
  = Tích hợp phép biến đổi TBR vào MPBoot <chuong3>
]

#show: body => first_line_indent_all_body(body)

== Khung thuật toán MPBoot

Để giải bài xây dựng cây tiến hóa bootstrap, thuật toán MPBoot duy trì một tập cây $cal(C)$ gồm $C$ cây
tốt nhất tìm được cho tập sắp hàng (MSAs) ban đầu. Tập hợp này được sinh ở pha khởi tạo
(pha 1) nhờ chạy 100 lần thủ tục thêm từng bước ngẫu nhiên rồi tối ưu bằng leo đồi SPR và
chọn ra $C$ cây tốt nhất. Tập hợp $cal(C)$ tiếp tục được cải thiện qua pha khám phá (pha
2) (xem @mpboot-iter) nhờ chiến lược lặp phá cây chọn ngẫu nhiên trong 𝐶 rồi leo đồi SPR
trên kết quả. Việc phá cây ở pha khám phá được thực hiện nhờ luân phiên (i) random NNI và
(ii) ratchet dùng leo đồi SPR. Ngoài ra, tập cây bootstrap $cal(B)$ được cập nhật cùng với
việc tìm kiếm cây. Ở pha tinh chỉnh bootstrap (pha 3), mỗi cây bootstrap sẽ được tối ưu
nhờ leo đồi SPR trên từng MSA bootstrap.

#figure(
  image("/images/mpboot-iter.png"),
  caption: [Một vòng lặp trong pha khám phá (pha 2) của khung thuật toán MPBoot.],
) <mpboot-iter>

== Việc áp dụng phép biến đổi cây trong thuật toán MPBoot gốc

Như vậy trong MPBoot phép biến đổi cây xuất hiện ở cả 3 pha. Việc tối ưu tất cả những thủ
tục leo đồi nhờ SPR bằng leo đồi dựa trên một phép biến đổi cây mạnh hơn (ví dụ như TBR)
có thể giúp vừa tìm được cây $T^"best"$ có điểm số MP tốt hơn vừa tìm được tập cây
bootstrap tốt hơn.

== Đề xuất tính toán nhanh một phép biến đổi TBR

Xét một phép biến đổi TBR trên cây $T^"lst"$ (xem #ref(label("tbr-example"))A). Gọi cạnh $R$ là
cạnh cắt của phép TBR. Trong trường hợp tổng quát, cắt cây $T^"lst"$ tại $R$ tạo ra hai
cây con $T_1$, $T_2$ và cạnh $R$ tạm thời tách biệt với nhau (xem #ref(label("tbr-example"))B).
Cạnh $R$ sau đó sẽ được dùng làm cạnh trung gian để nối $T_1$ và $T_2$ (xem #ref(label("tbr-example"))C).
Giả sử cặp cạnh nối là ($I_1$, $I_2$) với $I_1$ thuộc cây con $T_1$, $I_2$ thuộc cây con $T_2$.
Gọi $T^*$ là cây kết quả nối $I_1$ và $I_2$.

Theo tiếp cận trực tiếp thì việc đánh giá lại điểm của cây $T^*$ được thực hiện thuần bằng
việc duyệt post-order lại toàn bộ cây và tính theo thuật toán Fitch hoặc Sankoff. Tuy
nhiên, trước và sau khi nối tạo thành cây $T^*$ điểm parsimony của nhiều cây con không
thay đổi.

Sau đây, chúng tôi đề xuất phương pháp chỉ tính lại điểm của những đỉnh có thay đổi điểm
số như sau. Giả sử cây $T^"lst"$ đã được tính toán điểm parsimony cho từng đỉnh sử dụng
gốc đặt trên cạnh gốc (_$"root"$_) nối 2 đỉnh $"root"_1$ và $"root"_2$. Mỗi đỉnh sẽ lưu
điểm parsimony của cây con tương ứng (xem #ref(label("tbr-fast"))A). Xét cây $T^*$ với gốc
đặt trên cạnh $R$. Khi đó những đỉnh cần phải tính lại điểm parsimony là những đỉnh của
cây $T^"lst"$ thuộc đường đi nối hai cạnh $I_1$ và $"root"$ và những đỉnh thuộc đường đi
nối hai cạnh $I_2$ và $"root"$ (xem #ref(label("tbr-fast"))B). Để xác định được những đỉnh
cần tính lại điểm như trên, với mỗi đỉnh, ta lưu thêm một biến con trỏ tới đỉnh cha ứng
với cây $T^"lst"$ . Khi đó, việc tìm kiếm và đánh dấu những đỉnh cần tính lại được thực
hiện bằng vòng lặp từ $I_1$ và $I_2$ nhảy lên đỉnh cha cho tới khi lên tới gốc của $T^"lst"$ .
Cuối cùng, trên cây $T^*$ xét gốc ở cạnh $R$, ta thực hiện tính toán điểm và chỉnh sửa
biến con trỏ tới đỉnh cha tương ứng ở những đỉnh được đánh dấu tính lại. Sau mỗi phép biến
hình cây TBR, cây $T^*$ sẽ chính là cây $T^"lst"$ cho lượt thử tiếp theo.

#figure(
  image("/images/tbr-example.png"),
  caption: [Một phép biến đổi TBR với cạnh cắt $R$ và hai cạnh nối $I_1$ và $I_2$],
) <tbr-example>

#figure(
  image("/images/tbr-fast.png"),
  caption: [Nhận diện những đỉnh cần phải tính lại điểm với cạnh cắt $R$ và hai cạnh nối $I_1$ và $I_2$],
) <tbr-fast>

== Đề xuất tìm kiếm cây lân cận sử dụng TBR
=== Chiến lược tìm kiếm "tốt nhất"
Thuật toán tìm kiếm lân cận sử dụng các phép biến hình cây TBR trên một cây $T$ với cạnh
cắt $R$ được thực hiện như sau:
- Chọn cạnh $R$ là cạnh cắt của các phép TBR cần khảo sát. Trong trường hợp tổng quát, cắt
  cây
  $T$ tại $R$ tạo ra hai cây con $T_1$, $T_2$ và cạnh $R$ tạm thời tách biệt với nhau. Cạnh $R$ sau
  đó sẽ được dùng làm cạnh trung gian để nối $T_1$ và $T_2$.

- Xét lần lượt các cặp cạnh nối ($I_1$, $I_2$) với $I_1$ thuộc cây con $T_1$, $I_2$ thuộc
  cây con $T_2$ và khoảng cách giữa $I_1$, $I_2$ ở trên cây ban đầu nằm trong khoảng $["mintrav", "maxtrav"]$ cho
  trước.
  - Thực hiện nối hai cạnh $I_1$ và $I_2$ thông qua cạnh $R$. (xem #ref(label("tbr-example"))C)
  - Cây kết quả nhận được là cây $T^*$. Tính toán, đánh giá cây $T^*$ thông qua điểm
    parsimony. Cập nhật cây lân cận tốt nhất tìm được $T^"best"$ .
  - Thực hiện cắt cạnh $R$ một lần nữa, nhằm khảo sát những cặp ($I_1$, $I_2$) tiếp theo.
- Sau khi tìm kiếm kết thúc, ta sẽ tìm được cây $T^"best"$ tốt nhất khi thực hiện các phép
  TBR trên cây $T$ với cạnh cắt $R$.
- Nối lại cạnh $R$ vào vị trí ban đầu, rollback về cây $T$ ban đầu.

Thuật toán được mô tả bằng mã giả trong @algo1 sau đây. Khi đó, với cây $T$, cạnh $R$, giá
trị $"mintrav"$ và $"maxtrav"$ sau khi thực hiện thủ tục #smallcaps("ComputeTBR")$(R, "mintrav", "maxtrav")$ sẽ
tìm được cây $T^"best"$ (tương đương với tìm được cặp cạnh tốt nhất ($I_1$, $I_2$)).

Những trường hợp đặc biệt như $R$ không phải là cạnh trong (nối với một đỉnh lá) được xử
lí riêng do công đoạn cắt cạnh và nối cạnh có phần khác biệt. Ngoài ra, để tính nhanh điểm $"MP"(T^*)$,
ta cũng sẽ đổi cạnh gốc của cây $T^"lst"$ thành chính cạnh cắt $R$ sau lượt #smallcaps("TestTBRMove") đầu
tiên và giữ nguyên cho tới khi xét cạnh cắt tiếp theo. Điều này đảm bảo số lượng đỉnh cần
phải tính lại sẽ không quá $O("maxtrav")$ đỉnh (không xét lượt thử đầu tiên do gốc có thể
khác $R$).
#outline_algo(
  [
    #algo(
      header: [
        #table(
          columns: (auto, 1fr),
          inset: 7pt,
          row-gutter: (0pt, 0pt, 3pt),
          stroke: none,
          align: horizon,
          [*Input*],
          [Tree $T$],
          [],
          [Remove-branch $R$],
          [],
          [Radius criteria _mintrav_ and _maxtrav_ for insert-branches $I_1$, $I_2$],
          table.hline(stroke: 0.5pt),
          [*Output*],
          [Best found tree $T^"bestNei"$ (best $(I_1,I_2)$) with remove-branch $R$],
          table.hline(stroke: 0.5pt),
        )
      ],
      strong-keywords: false,
      indent-guides: 1pt + gray,
      breakable: true,
    )[
      #smallcaps("ComputeTBR")$(R, "mintrav", "maxtrav")$\
      \
      *Function* #smallcaps("TestTBRMove")$(I_1,I_2)$#i\
      #text(
        fill: rgb("#7d6f6f"),
        [\/\/ $T$ is already cut into $R$, $T_1$, $T_2$ when called #smallcaps("TestTBRMove()")],
      )\
      Connect branch $I_1$ and $I_2$ using $R$, result in $T^*$\
      Evaluate parsimony score $"MP"(T^*)$ of $T^*$\
      *if* $"MP"(T^*) < "MP"(T^"bestNei")$ *then*#i\
      $T^"bestNei" := T^*$\
      $I_1^"bestNei" := I_1$\
      $I_2^"bestNei" := I_2$#d\
      *end if*\
      Remove branch $R$, rollback the changes#d\
      \
      *Function* #smallcaps("ComputeTBR")$(R, "mintrav", "maxtrav")$#i\
      Remove branch $R$ from tree $T$\
      #text(
        fill: rgb("#7d6f6f"),
        [\/\/ Find all valid $(I_1,I_2)$ can be done recursively via DFS],
      )\
      *for* each $(I_1,I_2)$ satisfied#i\
      #smallcaps("TestTBRMove")$(I_1,I_2)$#d\
      *end for*\
      Reconnect branch $R$, rollback to $T$\
      $T =$ #smallcaps("ApplyTBR")$(R, I_1^"bestNei", I_2^"bestNei")$\
    ]
  ],
  [Thực hiện phép biến đổi TBR với cạnh cắt $R$ trên cây $T$],
  <algo1>,
)

=== Chiến lược tìm kiếm "tốt hơn"

Chúng tôi cũng đề xuất một thuật toán tìm kiếm lân cận TBR tương tự @algo1 nhưng với một
số thay đổi nhỏ. Ở thuật toán trên, với mỗi cạnh cắt $R$, ta cập nhật cây hiện tại tối đa
1 lần (nếu như cây $T^"best"$ cho kết quả tốt hơn). Ở thuật toán thay đổi này (xem
@algo2), với mỗi cặp cạnh cắt $R$ và cạnh nối $I_1$ ta cập nhật cây hiện tại tối đa 1 lần.
Chi tiết hơn, ta sẽ xét mọi cạnh nối $I_2$ thỏa mãn, tìm cây $T^"best"$ và cập nhật cho
cây hiện tại nếu cho kết quả tốt hơn.

#outline_algo(
  [
    #algo(
      header: [
      ],
      strong-keywords: false,
      indent-guides: 1pt + gray,
      breakable: true,
    )[

      *Function* #smallcaps("ComputeTBR")$(R, "mintrav", "maxtrav")$#box(width: 1fr)#i\
      *for* each $I_1$ satisfied#i\
      Remove branch $R$ from tree $T$\
      *for* each $I_2$ satisfied#i\
      #smallcaps("TestTBRMove")$(I_1, I_2)$#d\
      *end for*\
      Reconnect branch $R$, rollback to $T$\
      $T =$ #smallcaps("ApplyTBR")$(R, I_1, I_2^"bestNei")$#d\
      *end for*\
    ]
  ],
  [Chiến thuật tìm kiếm "tốt hơn" sử dụng TBR],
  <algo2>,
)

== Đề xuất thuật toán leo đồi TBR

Thuật toán leo đồi TBR thực hiện leo đồi cập nhật cây $T$ bằng cây $T^"best"$ tìm được
(nếu $T^"best"$ cho kết quả tốt hơn) với mỗi cạnh cắt $R$ khảo sát bằng thuật toán được mô
tả ở @algo1 và @algo2. Vòng lặp leo đồi sẽ tiếp tục trong khi cây $T$ vẫn được cập nhật
bởi một cây tối ưu hơn. Thuật toán leo đồi TBR được mô tả bằng mã giả trong @algo3 sau
đây.

Khi leo đồi sử dụng hai cách tìm kiếm lân cận TBR khác nhau (sau đây gọi tắt là hai cách
leo đồi "tốt nhất" và "tốt hơn") thì mẫu không gian cây khảo sát được cũng khác nhau.

#outline_algo(
  [
    #algo(
      header: [
        #table(
          columns: (auto, 1fr),
          inset: 7pt,
          row-gutter: (0pt, 3pt),
          stroke: none,
          [*Input*],
          [Tree $T$],
          [],
          [Radius criteria _mintrav_ and _maxtrav_ for insert-branches $I_1$, $I_2$],
          table.hline(stroke: 0.5pt),
          [*Output*],
          [Tree $T$ updated to best found neighbor tree $T^"bestNei"$ consider every remove-branch $R$],
          table.hline(stroke: 0.5pt),
        )
      ],
      strong-keywords: false,
      indent-guides: 1pt + gray,
      breakable: true,
    )[
      *do*#i\
      *for* each branch $R$ in $T$#i\
      $T^"bestNei" := "NULL"$\
      #smallcaps("ComputeTBR")$(R, "mintrav", "maxtrav")$\
      *if* $"MP"(T^"bestNei") < "MP"(T)$ *then*#i\
      $T := T^"bestNei"$#d\
      *end if*#d\
      *end for*#d\
      *while* $"MP"(T)$ still improves\
      *end do*
    ]
  ],
  [Thuật toán leo đồi sử dụng TBR trên cây $T$],
  <algo3>,
)
== Đề xuất thuật toán MPBoot-TBR

Chúng tôi đề xuất MPBoot-TBR (xem @algo4) bằng cách thay thế toàn bộ leo đồi SPR bằng leo
đồi TBR. Nếu một lượt lặp tìm kiếm ở pha 2 không tìm được một cây có điểm số MP thấp hơn
so với điểm số của $T^"best"$ , thì lượt lặp sẽ được coi là unsuccessful (thất bại). Thuật
toán duy trì biến $n_"unsuccess"$ lưu số lượt lặp tìm kiếm liên tiếp unsuccessful (thất
bại). MPBoot gốc dừng nếu $n_"unsuccess"$ đạt $n^'$ (giá trị làm tròn lên tới số hàng trăm
gần nhất của $n$). Do tập lân cận của TBR lớn hơn, chúng tôi hiệu chỉnh giới hạn của $n_"unsuccess"$ thành $n^'=100$ giống
với IQ-TREE @minh2020iq.

#outline_algo(
  [
    #algo(
      header: [
        #table(
          columns: (auto, 1fr),
          inset: 7pt,
          row-gutter: (0pt, 0pt, 3pt),
          stroke: none,
          [*Input*],
          [an MSA $A^"data"$ with $n$ sequences],
          [],
          [the number of bootstrap MSAs $B$],
          [],
          [an upperbound for TBR radius _maxtrav_],
          table.hline(stroke: 0.5pt),
          [*Output*],
          [A tree $T^"best"$ with best found $"MP"(T^"best" | A^"data")$ and a set $cal(B)$ of
            bootstrap trees ${T_1, T_2, dots, T_B}$],
          table.hline(stroke: 0.5pt),
          [],
          [],
        )
      ],
      strong-keywords: false,
      indent-guides: 1pt + gray,
      breakable: true,
    )[
      *Phase 1: Initialization*#i\
      Generate bootstrap MSAs and initialize bootstrap tree set $cal(B)$.\
      Initialize the threshold $"MP"_"max" := +infinity$.\
      Initialize the candidate set $C$ for $A^"data"$ with 100 random stepwise addition
      procedures followed by TBR hill-climbing.#d\
      \
      *Phase 2: Exploration*#i\
      *do*#i\
      Improve $C$ by performing perturbation on a randomly selected tree from the candidate set $C$ and
      a subsequent TBR hill-climbing step.\
      *if* a new tree $T$ with $"MP"(T | A^"data") < "MP"_"max"$ is found *then*#i\
      Execute REPS to update the bootstrap tree set $cal(B)$.#d\
      *end if*\
      Update $T^"best"$, $"MP"_"max"$, $n_"unsuccess"$.#d\
      *while* $n_"unsuccess" < n^'$#d\
      \
      *Phase 3: Bootstrap Refinement*#i\
      *for* each MP-tree $T_b$ in $cal(B)$ *do*#i\
      Perform TBR hill-climbing search and replace $T_b$ if a better parsimony score is found.#d\
      *end for*\
      Output $T^"best"$, the best MP tree that was found for $A^"data"$.\
      Output set $cal(B)$ and/or map the support values onto $T^"best"$.
    ]
  ],
  [Thuật toán MPBoot-TBR xấp xỉ bootstrap],
  <algo4>,
)
#pagebreak()
