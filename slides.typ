#import "@preview/touying:0.5.3": *
#import "stargazer.typ": *
#import "@preview/fletcher:0.5.3" as fletcher: diagram, node, edge

#import "@preview/numbly:0.1.0": numbly

#show: stargazer-theme.with(
  aspect-ratio: "16-9",
  config-info(
    subtitle: [Tích hợp các phép biến hình cấu trúc cây cải tiến suy luận tiến hóa trong MPBoot],
    author: [Huỳnh Tiến Dũng],
    instructor: [TS. Hoàng Thị Điệp],
    date: "17/12/2024",
    institution: [Trường Đại học Công Nghệ - ĐHQGHN],
  ),
)
#set text(font: "New Computer Modern", lang: "vi")
#set heading(numbering: numbly("{1}.", default: "1.1."))
#set par(justify: true)
#show figure.caption: set text(15pt)

#slide(navigation: none, progress-bar: false, self => [
  #v(0.5cm)
  #grid(
    columns: (auto, 1fr, 1fr, 1fr, 8fr),
    align: auto,
    [#h(105pt)],
    [#v(-20pt)#image("images/dhqg.png")],
    [#v(-20pt)#image("images/UET.png", width: 75%)],
    [#v(-20pt)#image("images/cntt.png", width: 75%)],
    align(center, [
      #set text(size: 15pt)
      ĐẠI HỌC QUỐC GIA HÀ NỘI \
      TRƯỜNG ĐẠI HỌC CÔNG NGHỆ \
      #text(10pt, strong("———————o0o——————–"))
    ])
  )
  #v(0.4cm)
  #align(center, text(27pt, upper(strong("Tích hợp các phép biến hình\n cấu trúc cây cải tiến suy luận tiến hóa trong MPBoot"))))
  #v(0.5cm)
  #align(center, [
    #set text(size: 18pt)
    #grid(
      columns: (auto, auto),   
      align: (left, left),
      column-gutter: 26pt,
      row-gutter: 18pt,
      [Sinh viên thực hiện:], [*Huỳnh Tiến Dũng*], 
      [Giảng viên hướng dẫn:], [*TS. Hoàng Thị Điệp*],
      [Lớp khóa học:], [QH-2021-I/CQ-I-IT15],
      [Khoa:], [Công nghệ thông tin]
    )
  ])

  #v(1fr)
])

#outline-slide(title: "Mục lục")

// == Outline <touying:hidden>

// #components.adaptive-columns(outline(title: none, indent: 1em))

= Giới thiệu
== Tiến hóa sinh học <touying:hidden>
#v(1cm)
#grid(
  columns: (240pt, 510pt),
  gutter: 10pt,
  align: center + horizon,
  [
    #v(0.4cm)
    #text(27pt, "Phylogenetic\n")
    #text(17pt, "(Tiến hóa sinh học)")
  ],
  grid.cell(rowspan: 2)[
    #image("images/treeoflife.png", height: 92%)
  ],
  [
    #image("images/darwin.png", height: 70%)
  ]
)
== Một cây tiến hóa đơn giản <touying:hidden>
#v(0.7cm)
#align(center, 
[
  #image("images/phytree.png", width: 93%)
])
== Ứng dụng rộng rãi trong dịch tễ học <touying:hidden>
#v(0.7cm)
#align(center, 
[
  #image("images/covid.png", width: 105%)
])
== Xây dựng cây tiến hóa <touying:hidden>
#v(0.7cm)
#grid(
  columns: (auto, auto),
  gutter: 40pt,
  align: horizon,
  [
    #pad(left: 20pt, [
      *Đầu vào*:\
      Sắp hàng đa\ chuỗi (MSA) \ \
      *Đầu ra*:\
      Cây tiến hóa\ tương ứng
    ])
  ],
  [
    #image("images/phytree1.png", height: 94%)
  ],
)

== Xây dựng cây tiến hóa bootstrap <touying:hidden>
#v(0.3cm)
#grid(
  columns: (290pt, auto),
  gutter: 35pt,
  align: horizon,
  [
    #pad(left: 20pt, [
      1. Thực hiện xây dựng tìm kiếm cây tối ưu nhất.

      2. Đánh giá độ tin cậy của các phân nhánh/cạnh trong cây bằng tần suất tương ứng trên tập các cây bootstrap.
    ])
  ],
  [
    #image("images/boot1.png", width: 99%)
  ],
)
#pagebreak()
#v(0.8cm)
#image("images/boot.png", width: 105%)
== Mô hình Bootstrap chuẩn (SBS; Felsenstein 1985) <touying:hidden>
#v(0.7cm)
#align(center, [
  #image("images/boot2.png", width: 85%)
])

== Mô hình Bootstrap xấp xỉ (MPBoot; Hoang 2018) <touying:hidden>
#v(0.7cm)
#align(center, [
  #image("images/boot3.png", width: 75%)
])

== Tiêu chí Maximum Parsimony <touying:hidden>
#v(1.3cm)
- Điểm số MP là số lượng tối thiểu các đột biến của cây cần thiết để giải thích MSA.

- Xây dựng cây MP là bài toán NP-hard (Foulds & Graham 1982)
- Phương pháp chung: Khám phá mẫu không gian các cây nhị phân n lá. Với mỗi cây tìm thấy, tính điểm MP. Chọn cây có điểm MP thấp nhất.
  - sử dụng Fitch cho chi phí đột biến đều.
  - sử dụng Sankoff cho chi phí đột biến không đều.

#align(center, [
  #image("images/mp.png")
])

== Các phép biến đổi cây thường dùng <touying:hidden>

#v(0.9cm)
#align(center, [
  #image("images/3-ops.png", width: 80%)
])

== Câu hỏi nghiên cứu <touying:hidden>
*Làm thế nào để cải thiện hiệu quả lấy mẫu cây tiến hóa trong MPBoot?*

- Tích hợp phép Tree Bisection and Reconnection (TBR) vào các thủ tục leo đồi trong MPBoot.

- Kết hợp leo đồi sử dụng cả NNI, SPR, TBR bằng phương pháp học tăng cường giải thuật đàn kiến (ACO) nhằm lựa chọn phép biến đổi phù hợp nhất với dữ liệu đầu vào.

= Tích hợp phép TBR vào MPBoot 

== Khung thuật toán MPBoot gốc <touying:hidden>
#v(0.8cm)
#grid(
  columns: (1fr, auto),
  gutter: 40pt,
[
  #set text(size: 17pt)
- *Pha 1.* Khởi tạo
  - Tạo tập ứng cử viên $cal(C)$ gồm $C$ cây sử dụng thuật toán randomized stepwise addition, sau đó tối ưu bằng leo đồi *SPR*.
- *Pha 2*. Khám phá
  - Chọn một cây ngẫu nhiên $T$ từ tập $cal(C)$.
  - Thực hiện chiến lược phá cây trên $T$, xen kẽ giữa NNI ngẫu nhiên và ratchet với leo đồi *SPR*.
  - Thực hiện leo đồi *SPR* theo sau với cây nhận được.
  - Tập cây bootstrap $cal(B)$ được cập nhật cùng với bước tìm kiếm cây.

- *Pha 3*. Tinh chỉnh
  - Mỗi cây bootstrap sẽ được tối ưu sử dụng leo đồi *SPR* thực hiện trên MSA tương ứng.
],
  grid.cell(align: center)[
    #pause
    Phép *SPR* được sử dụng\ trong toàn bộ framework
    #pause
    *$ arrow.b.double $*
    Sử dụng *TBR* toàn diện\ hơn SPR có thể dẫn đến cây MP\ và tập bootstrap tốt hơn.
  ]
)

== Ví dụ về một phép TBR <touying:hidden>
#v(1.2cm)
- Cây $T^"lst"$
- Cạnh cắt $R$
- Cạnh nối $I_1$ và $I_1$ (thuộc 2 cây con khác nhau sau khi cắt cạnh $R$)
- Cây kết quả $T$

#v(0.1cm)
#align(center, [
  #image("images/tbr.png", width: 107%)
])
== Tính toán nhanh một phép biến đổi TBR <touying:hidden>

== Thuật toán leo đồi sử dụng TBR <touying:hidden>

== Chiến lược tìm kiếm "tốt nhất" <touying:hidden>

#pagebreak()
== Chiến lược tìm kiếm "tốt hơn <touying:hidden>
= Đề xuất MPBoot2
== Đề xuất MPBoot2 <touying:hidden>
= Đề xuất MPBoot-RL
== Giải thuật đàn kiến <touying:hidden>
== Cấu trúc đồ thị <touying:hidden>
== Thông tin Heuristics <touying:hidden>

== Quy tắc cập nhật mùi pheromone - SMMAS-once <touying:hidden>
#diagram({
  let (a, b, c, d, e) = ((0,3), (1, 0),(1,3), (4,0), (4,3))
  node(a, "Quy tắc SMMAS\n(sau một thế hệ kiến)")
  node(b)
  node(d, $tau_e arrow.l (1- rho) dot.c tau_e + rho dot.c tau_"max"$)
  node(e, $tau_e arrow.l (1- rho) dot.c tau_e + rho dot.c tau_"min"$)
  edge(a, b, "->", $in "lời giải tốt"$, label-side: left, stroke: 3pt + rgb("#93c47d"))
  edge(a, e, "->", $in.not "lời giải tốt"$, label-side: right, stroke: 3pt + rgb("#990000"))
  edge(b, d, "->", $"MP"_"new" <= "MP"_"cur_best"$, stroke: 3pt + rgb("#93c47d"),label-sep: 15pt)
  edge(b, e, "->", label: "fallback\nto NNI", label-side: left, stroke: 3pt + rgb("#c27ba0"))
})
== Quy tắc cập nhật mùi pheromone - SMMAS-multiple <touying:hidden>

== Quy trình bước đi ngẫu nhiên <touying:hidden>
$ "prob"_(A arrow.r B) = (tau_(A arrow.r B) dot.c eta_B) / (sum_(C in "adj"(A)) tau_(A arrow.r C) dot.c eta_C) $

trong đó:
#[

#set list(indent: 0.8em)
- $"prob"_(A arrow.r B)$ là xác suất con kiến ở đỉnh $A$ di chuyển đến đỉnh $B$.
- $tau_(A arrow.r B)$ là mức độ pheromone của cạnh từ $A$ đến $B$.
- $eta_B$ là thông tin heuristic của đỉnh $B$.
- $"adj"(A)$ là tập các đỉnh mà $A$ nối tới.
]

= Thực nghiệm và kết quả
== Cài đặt thực nghiệm <touying:hidden>

== Các bộ dữ liệu <touying:hidden>

== TreeBASE DNA và Protein <touying:hidden>

== Dữ liệu Morphology và nhị phân <touying:hidden>

== Độ chính xác Bootstrap <touying:hidden>
#grid(
  columns: 2,
  align: center,
  row-gutter: 10pt,
  column-gutter: 68pt,
  [*TBR\**], [*ACO\**],
  image("images/bootstrap.png", width: 125%),
  image("images/bootstrap-aco.png", width: 125%)
)
== Khảo sát liên quan độ khó bộ dữ liệu <touying:hidden>
#grid(
  columns: 2,
  align: center,
  row-gutter: 10pt,
  column-gutter: 80pt,
  [*ACO-MUL*], [#h(0.8cm)*ACO-ONCE*],
  image("images/acomul_diff.png", width: 125%),
  image("images/acoonce_diff.png", width: 125%)
)
= Kết luận
== Kết luận <touying:hidden>
#v(0.8cm)
- *Kết quả đạt được*:

  - Tích hợp phép TBR vào MPBoot, đề xuất phiên bản MPBoot2 cùng với nhiều tính năng mới.

  - Kết hợp các phép biến đổi NNI, SPR, TBR sử dụng giải thuật đàn kiến, đề xuất phiên bản MPBoot-RL; đồng thời mở rộng khảo sát về độ khó bộ dữ liệu.

- *Định hướng phát triển*:

  - Phân tích độ khó bộ dữ liệu dựa trên thông số sử dụng các phép biến đổi cây kết hợp với các đặc tính khác của bộ dữ liệu.

  - Ý tưởng áp dụng giải thuật đàn kiến có thể áp dụng tương tự vào quá trình phá cây (các thuật toán phá cây như ratchet, random NNIs, IQP...)

== Công bố liên quan <touying:hidden>
- *T. D. Huynh*, Q. T. Vu, V. D. Nguyen and D. T. Hoang, "Employing tree bisection and reconnection rearrangement for parsimony inference in MPBoot," 2022 14th International Conference on Knowledge and Systems Engineering (KSE), Nha Trang, Vietnam, 2022, pp. 1-6, doi: 10.1109/KSE56063.2022.9953773.

== Lời cảm ơn <touying:hidden>

#v(0.5cm)
#align(center, [
  #strong(text(size: 34pt, [Xin cảm ơn Thầy Cô và Hội đồng \ đã theo dõi và lắng nghe!]))
])
#v(0.5cm)
#align(center, [
  #set text(size: 18pt)
  #grid(
    columns: (auto, auto),   
    align: (left, left),
    column-gutter: 26pt,
    row-gutter: 18pt,
    [Sinh viên thực hiện:], [*Huỳnh Tiến Dũng*], 
    [Giảng viên hướng dẫn:], [*TS. Hoàng Thị Điệp*],
    [Lớp khóa học:], [QH-2021-I/CQ-I-IT15],
    [Khoa:], [Công nghệ thông tin]
  )
])


