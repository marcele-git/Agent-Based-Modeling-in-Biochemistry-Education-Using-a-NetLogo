globals [
   enzimas-visiveis?    ; Controla se as enzimas estão visíveis ou não
 ]

 breed [acil-coas acil-coa] ; Acil-CoA Citosólico. Cor: blue
 breed [mitocondrial-acil-coas mitocondrial-acil-coa] ; Acil-CoA Mitocondrial. Cor: blue (rótulo distinguirá)
 breed [acil-coas-n-2 acil-coa-n-2] ; NOVO: Acil-CoA n-2. Cor: blue (rótulo distinguirá)

 breed [acil-carns acil-carn]                 ; Cor: orange
 breed [trans-delta2-enoil-coas trans-delta2-enoil-coa] ; Cor: violet
 breed [beta-hidroxiacil-coas beta-hidroxiacil-coa] ; Cor: cyan
 breed [beta-cetoacil-coas beta-cetoacil-coa]     ; Cor: magenta
 breed [acetil-coas acetil-coa]                 ; Cor: yellow
 breed [nads nad]                             ; Cor: gray (NAD+)
 breed [nadhs nadh]                           ; Cor: red (NADH)
 breed [fads fad]                             ; Cor: gray + 2 (FAD)
 breed [fadh2s fadh2]                         ; Cor: lime (FADH2)

 ; --- Enzyme Breeds ---
 breed [carnitina-aciltransferases carnitina-aciltransferase]
 breed [acil-carnitina-translocases acil-carnitina-translocase]
 breed [acil-coa-desidrogenases acil-coa-desidrogenase]
 breed [enoil-coa-hidratases enoil-coa-hidratase]
 breed [beta-hidroxiacil-coa-desidrogenases beta-hidroxiacil-coa-desidrogenase]
 breed [tiolases tiolase]


 to setup
   clear-all
   ask patches [ set pcolor white ]

   if not is-number? acil-coa-inicial [ set acil-coa-inicial 10 ]
   if not is-number? quantidade-nad-inicial [ set quantidade-nad-inicial 50 ]
   if not is-number? quantidade-fad-inicial [ set quantidade-fad-inicial 50 ]
   if not is-number? quantidade-cpt1-inicial [ set quantidade-cpt1-inicial 1 ]
   if not is-number? quantidade-translocase-inicial [ set quantidade-translocase-inicial 1 ]
   if not is-number? quantidade-acd-inicial [ set quantidade-acd-inicial 1 ]
   if not is-number? quantidade-ech-inicial [ set quantidade-ech-inicial 1 ]
   if not is-number? quantidade-bhcd-inicial [ set quantidade-bhcd-inicial 1 ]
   if not is-number? quantidade-tiolase-inicial [ set quantidade-tiolase-inicial 1 ]

   criar-acil-coa-citosolico acil-coa-inicial
   criar-cofatores
   criar-enzimas

   set enzimas-visiveis? true
   aplicar-visibilidade-enzimas
   reset-ticks
 end

 to criar-cofatores
   create-nads quantidade-nad-inicial [
     set-up-agent-props self "NAD+" gray "circle"
   ]
   create-fads quantidade-fad-inicial [
     set-up-agent-props self "FAD" (gray + 2) "circle"
   ]
 end

 to set-up-agent-props [target-agent new-label new-color new-shape]
   ask target-agent [
     set shape new-shape
     set color new-color
     set label new-label
     set label-color black
     move-to one-of patches
   ]
 end

 to criar-acil-coa-citosolico [quantidade]
   create-acil-coas quantidade [
     set shape "circle"
     set color blue
     set size 1.5
     move-to one-of patches
     set label "Acil-CoA"
     set label-color black
   ]
 end

 to criar-enzimas
   create-carnitina-aciltransferases quantidade-cpt1-inicial [
     setup-single-enzyme "Carn-AcilTransferase I"
   ]
   create-acil-carnitina-translocases quantidade-translocase-inicial [
     setup-single-enzyme "AcilCarn-Translocase/CPTII"
   ]
   create-acil-coa-desidrogenases quantidade-acd-inicial [
     setup-single-enzyme "AcilCoA-Desidrogenase"
   ]
   create-enoil-coa-hidratases quantidade-ech-inicial [
     setup-single-enzyme "EnoilCoA-Hidratase"
   ]
   create-beta-hidroxiacil-coa-desidrogenases quantidade-bhcd-inicial [
     setup-single-enzyme "β-HidroxiacilCoA-Desidrogenase"
   ]
   create-tiolases quantidade-tiolase-inicial [
     setup-single-enzyme "Tiolase"
   ]
 end

 to setup-single-enzyme [nome-label]
   set shape "circle"
   set color pink
   set size 2
   set label nome-label
   set label-color black
   move-to one-of patches
 end

 to toggle-enzyme-visibility-button
   set enzimas-visiveis? not enzimas-visiveis?
   aplicar-visibilidade-enzimas
 end

 to aplicar-visibilidade-enzimas
   ask carnitina-aciltransferases [ ifelse enzimas-visiveis? [show-turtle] [hide-turtle] ]
   ask acil-carnitina-translocases [ ifelse enzimas-visiveis? [show-turtle] [hide-turtle] ]
   ask acil-coa-desidrogenases [ ifelse enzimas-visiveis? [show-turtle] [hide-turtle] ]
   ask enoil-coa-hidratases [ ifelse enzimas-visiveis? [show-turtle] [hide-turtle] ]
   ask beta-hidroxiacil-coa-desidrogenases [ ifelse enzimas-visiveis? [show-turtle] [hide-turtle] ]
   ask tiolases [ ifelse enzimas-visiveis? [show-turtle] [hide-turtle] ]
 end

 to go
   ask turtles [
     rt random-float 360
     fd 0.2
     if not can-move? 0.2 [ rt 180 ]
   ]

   if enzimas-visiveis? [
     mover-enzimas-para-substrato carnitina-aciltransferases acil-coas
     mover-enzimas-para-substrato acil-carnitina-translocases acil-carns
     mover-enzimas-para-substrato acil-coa-desidrogenases mitocondrial-acil-coas
     mover-enzimas-para-substrato enoil-coa-hidratases trans-delta2-enoil-coas
     mover-enzimas-para-substrato beta-hidroxiacil-coa-desidrogenases beta-hidroxiacil-coas
     mover-enzimas-para-substrato tiolases beta-cetoacil-coas
     update-plot

     ask carnitina-aciltransferases [ interagir-com-substrato self acil-coas "carnitina-aciltransferase-I" ]
     ask acil-carnitina-translocases [ interagir-com-substrato self acil-carns "acil-carnitina-translocase" ]
     ask acil-coa-desidrogenases [ interagir-com-substrato self mitocondrial-acil-coas "acil-coa-desidrogenase" ]
     ask enoil-coa-hidratases [ interagir-com-substrato self trans-delta2-enoil-coas "enoil-coa-hidratase" ]
     ask beta-hidroxiacil-coa-desidrogenases [ interagir-com-substrato self beta-hidroxiacil-coas "beta-hidroxiacil-coa-desidrogenase" ]
     ask tiolases [ interagir-com-substrato self beta-cetoacil-coas "tiolase" ]
   ]
   tick
 end

 to interagir-com-substrato [enzima p-substrato-agentset funcao-enzima] ; Parâmetro renomeado para clareza
   if not [hidden?] of enzima [
     ; p-substrato-agentset já é um agentset (ex: acil-coas, mitocondrial-acil-coas)
     ; nas chamadas atuais. A verificação ifelse foi removida.
     let proximos-substratos (p-substrato-agentset in-radius 1)

     if any? proximos-substratos [
       let alvo one-of proximos-substratos
       if funcao-enzima = "carnitina-aciltransferase-I" [ reacao-cpt1 enzima alvo ]
       if funcao-enzima = "acil-carnitina-translocase" [ reacao-translocase-cpt2 enzima alvo ]
       if funcao-enzima = "acil-coa-desidrogenase" [ reacao-acd enzima alvo ]
       if funcao-enzima = "enoil-coa-hidratase" [ reacao-ech enzima alvo ]
       if funcao-enzima = "beta-hidroxiacil-coa-desidrogenase" [ reacao-bhcd enzima alvo ]
       if funcao-enzima = "tiolase" [ reacao-tiolase enzima alvo ]
     ]
   ]
 end

 ; --- Funções de Reação Bioquimicamente Corrigidas ---

 to reacao-cpt1 [enzima acil-coa-citosol-alvo]
   hatch 1 [
     set breed acil-carns
     set shape "circle"
     set color orange
     set size 1.5
     set label "Acil-Carn"
     set label-color black
     move-to acil-coa-citosol-alvo
   ]
   ask acil-coa-citosol-alvo [die]
 end

 to reacao-translocase-cpt2 [enzima acil-carn-alvo]
   hatch 1 [
     set breed mitocondrial-acil-coas
     set shape "circle"
     set color blue
     set size 1.5
     set label "Acil-CoA (m)"
     set label-color black
     move-to acil-carn-alvo
   ]
   ask acil-carn-alvo [die]
 end

 to reacao-acd [enzima acil-coa-mitocondrial-alvo]
   if any? fads in-radius 1.5 [
     let fad-consumido one-of fads in-radius 1.5
     hatch 1 [
       set breed trans-delta2-enoil-coas
       set shape "circle"
       set color violet
       set size 1.5
       set label "trans-Δ2-Enoil-CoA"
       set label-color black
       move-to acil-coa-mitocondrial-alvo
     ]
     ask fad-consumido [ die ]
     hatch 1 [
       set breed fadh2s
       set shape "circle"
       set color lime
       set size 1.5
       set label "FADH2"
       set label-color black
       move-to acil-coa-mitocondrial-alvo
     ]
     ask acil-coa-mitocondrial-alvo [die]
   ]
 end

 to reacao-ech [enzima enoil-coa-alvo]
   hatch 1 [
     set breed beta-hidroxiacil-coas
     set shape "circle"
     set color cyan
     set size 1.5
     set label "β-Hidroxiacil-CoA"
     set label-color black
     move-to enoil-coa-alvo
   ]
   ask enoil-coa-alvo [die]
 end

 to reacao-bhcd [enzima beta-hidroxiacil-alvo]
   if any? nads in-radius 1.5 [
     let nad-consumido one-of nads in-radius 1.5
     hatch 1 [
       set breed beta-cetoacil-coas
       set shape "circle"
       set color magenta
       set size 1.5
       set label "β-Cetoacil-CoA"
       set label-color black
       move-to beta-hidroxiacil-alvo
     ]
     ask nad-consumido [ die ]
     hatch 1 [
       set breed nadhs
       set shape "circle"
       set color red
       set size 1.5
       set label "NADH"
       set label-color black
       move-to beta-hidroxiacil-alvo
     ]
     ask beta-hidroxiacil-alvo [die]
   ]
 end

 to reacao-tiolase [enzima beta-cetoacil-alvo]
   hatch 1 [
     set breed acetil-coas
     set shape "circle"
     set color yellow
     set size 1.5
     set label "Acetil-CoA"
     set label-color black
     move-to beta-cetoacil-alvo
   ]
   hatch 1 [
     set breed acil-coas-n-2 ; ALTERADO AQUI: Agora cria a nova breed
     set shape "circle"
     set color blue
     set size 1.5
     set label "Acil-CoA (n-2)" ; Rótulo para diferenciar no ambiente
     set label-color black
     move-to beta-cetoacil-alvo
   ]
   ask beta-cetoacil-alvo [die]
 end

 to mover-enzimas-para-substrato [enzimas-da-breed p-tipo-substrato-agentset] ; Parâmetro renomeado
   ask enzimas-da-breed [
     if not hidden? [
       ; p-tipo-substrato-agentset já é um agentset nas chamadas atuais.
       ; A verificação ifelse foi removida.
       let alvos-para-procurar p-tipo-substrato-agentset

       ifelse any? alvos-para-procurar [
         let alvos-possiveis alvos-para-procurar in-radius 5
         ifelse any? alvos-possiveis [
           let alvo min-one-of alvos-possiveis [distance myself]
           face alvo
           ifelse distance alvo > 0.5 [ fd 0.2 ] [ fd 0.1 ]
         ] [
           rt random-float 60 - 30
           fd 0.1
         ]
       ] [
         rt random-float 60 - 30
         fd 0.1
       ]
     ]
   ]
 end
to update-plot
  set-current-plot "β-Oxidação"

  set-current-plot-pen "Acil-Carn"
  plot count acil-carns

  set-current-plot-pen "Acil-CoA-cit"
  plot count acil-coas

  set-current-plot-pen "Acil-CoA-mito"
  plot count mitocondrial-acil-coas

  ; REMOVA OU COMENTE ESSAS DUAS LINHAS SE NÃO QUISER NO PLOT:
  ; set-current-plot-pen "Acil-CoA-(n-2)"
  ; plot count acil-coas-n-2

  set-current-plot-pen "Δ2-Enoil-CoA"
  plot count trans-delta2-enoil-coas

  set-current-plot-pen "β-Hidroxiacil"
  plot count beta-hidroxiacil-coas

  set-current-plot-pen "β-Cetoacil"
  plot count beta-cetoacil-coas

  set-current-plot-pen "Acetil-CoA"
  plot count acetil-coas

  set-current-plot-pen "NADH"
  plot count nadhs

  set-current-plot-pen "FADH2"
  plot count fadh2s
end
