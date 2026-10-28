globals [
  malonil-CoA-metabolizada
]

turtles-own [
  tipo       ; "insulina", "glucagon", "ACC", "acetil-CoA", "malonil-CoA", "acil-CoA", "carnitina", "carnitina-acil-transferase"
  ativo?     ; usado para ACC e acil-CoA: true se ativa, false se inativa
]

to setup
  clear-all
  set-default-shape turtles "circle"
  set malonil-CoA-metabolizada 0

  cria-ACC
  cria-acetil-CoA 20
  cria-acil-CoA 20
  cria-carnitina-acil-transferase 10
  cria-hormonios "insulina" nível-insulina
  cria-hormonios "glucagon" nível-glucagon

  reset-ticks
end

to cria-ACC
  create-turtles 20 [
    set tipo "ACC"
    set color red
    setxy random-xcor random-ycor
    set ativo? false
    set label "ACC (off)"
  ]
end

to cria-acetil-CoA [n]
  create-turtles n [
    set tipo "acetil-CoA"
    set color white
    setxy random-xcor random-ycor
    set label "acetil-CoA"
  ]
end

to cria-acil-CoA [n]
  create-turtles n [
    set tipo "acil-CoA"
    set color cyan
    setxy random-xcor random-ycor
    set label "acil-CoA"
    set ativo? true
  ]
end

to cria-carnitina-acil-transferase [n]
  create-turtles n [
    set tipo "carnitina-acil-transferase"
    set color magenta
    setxy random-xcor random-ycor
    set label "CAT"
  ]
end

to cria-hormonios [horm tipo-qtd]
  create-turtles tipo-qtd [
    set tipo horm
    set color ifelse-value (horm = "insulina") [blue] [orange]
    setxy random-xcor random-ycor
    set label horm
  ]
end

to go
  move-hormonios
  move-ACC
  move-substratos
  move-acil-CoA
  move-CAT
  move-carnitina

  interacoes-hormonais
  conversao-acetil-para-malonil
  inativa-acil-por-malonil         ; inativa primeiro
  conversao-acil-para-carnitina    ; só acil-CoA ativas se convertem
  beta-oxidacao

  atualiza-plot
  atualiza-plot2
  tick
end

to move-hormonios
  ask turtles with [tipo = "insulina" or tipo = "glucagon"] [
    rt random 20 - random 20
    fd 1
  ]
end

to move-ACC
  ask turtles with [tipo = "ACC"] [
    rt random 20 - random 20
    fd 0.5
  ]
end

to move-substratos
  ask turtles with [tipo = "acetil-CoA" or tipo = "malonil-CoA"] [
    rt random 10 - random 10
    fd 0.5
  ]
end

to move-acil-CoA
  ask turtles with [tipo = "acil-CoA"] [
    if ativo? [
      rt random 20 - random 20
      fd 0.5
    ]
    if not ativo? [
      rt random 20 - random 20
      fd 0.2  ; mais lento, por estar inativa
    ]
  ]
end


to move-CAT
  ask turtles with [tipo = "carnitina-acil-transferase"] [
    rt random 10 - random 10
    fd 0.3
  ]
end

to move-carnitina
  ask turtles with [tipo = "carnitina"] [
    rt random 20 - random 20
    fd 0.7
  ]
end

to interacoes-hormonais
  ask turtles with [tipo = "insulina"] [
    let alvo one-of turtles with [tipo = "ACC" and distance myself < 1.5]
    if alvo != nobody [
      ask alvo [
        set ativo? true
        set color green
        set label "ACC (on)"
      ]
    ]
  ]

  ask turtles with [tipo = "glucagon"] [
    let alvo one-of turtles with [tipo = "ACC" and distance myself < 1.5]
    if alvo != nobody [
      ask alvo [
        set ativo? false
        set color red
        set label "ACC (off)"
      ]
    ]
  ]
end

to conversao-acetil-para-malonil
  ask turtles with [tipo = "ACC" and ativo?] [
    let proximos-acetil turtles with [tipo = "acetil-CoA" and distance myself < 1.5]
    ask proximos-acetil [
      set tipo "malonil-CoA"
      set color brown
      set label "malonil-CoA"
    ]
  ]
end

to inativa-acil-por-malonil
  ask turtles with [tipo = "malonil-CoA"] [
    let alvos-acil turtles with [tipo = "acil-CoA" and distance myself < 1.5 and ativo?]
    ask alvos-acil [
      set ativo? false
      set color gray
      set label "acil-CoA (off)"
    ]
  ]
end

to conversao-acil-para-carnitina
  ask turtles with [tipo = "acil-CoA" and ativo?] [
    let enzima one-of turtles with [tipo = "carnitina-acil-transferase" and distance myself < 1.5]
    if enzima != nobody [
      set tipo "carnitina"
      set color yellow
      set label "carnitina"
    ]
  ]
end

to beta-oxidacao
  ask turtles with [tipo = "malonil-CoA"] [
    if random-float 1 < 0.05 [
      set malonil-CoA-metabolizada malonil-CoA-metabolizada + 1
    ]
  ]
end
to atualiza-plot
  set-current-plot "Malonil-CoA Metabolizada"
  set-current-plot-pen "malonil-CoA"
  plot count turtles with [tipo = "malonil-CoA"]
end

to atualiza-plot2
 set-current-plot "Carnitina no Tempo"
  set-current-plot-pen "carnitina"
  plot count turtles with [tipo = "carnitina"]
end
