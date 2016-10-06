;Length definitions
(define x1 0)
(define y1 0)
;width between plate
(define L 10e-6)
(define x2 (+ L x1))
;length of the plates
(define W 100e-6)
(define y2 (+ W y1))

;Mesh co-ordinates - need to modify only Lmesh here
(define Lmesh 1e-6)
(define xmeshmin1 x1)
(define ymeshmin1 y1)
(define xmeshmax1 (+ x1 Lmesh))
(define ymeshmax1 y2)

(define xmeshmin2 (- x2 Lmesh))
(define ymeshmin2 y1)
(define xmeshmax2 x2)
(define ymeshmax2 y2)

;material 
(sdegeo:create-rectangle (position x1 y1 0)  (position x2 y2 0) "Silicon Dioxide" "region_1" )

;Doping
;(sdedr:define-constant-profile "ConstantProfileDefinition_1" "BoronActiveConcentration" 1e16)
;(sdedr:define-constant-profile-material "ConstantProfilePlacement_1" "ConstantProfileDefinition_1" "Silicon")

;contact

(sdegeo:define-contact-set "n1contact"     4.0 (color:rgb 1.0 0.0 0.0 ) "%%" )
(sdegeo:define-contact-set "n2contact"     4.0 (color:rgb 1.0 0.0 0.0 ) "||" )

(sdegeo:define-2d-contact (list (car (find-edge-id (position x1 (/ (+ y1 y2) 2) 0)))) "n1contact")
(sdegeo:define-2d-contact (list (car (find-edge-id (position x2 (/ (+ y1 y2) 2) 0)))) "n2contact")

;Refinement Window for Global Meshing

(sdedr:define-refeval-window "RefEvalWin_1" "Rectangle"  (position (- x1 1e-6) (- y1 1e-6) 0) (position (+ x2 1e-6) (+ y2 1e-6) 0))

;Global Mesh

(sdedr:define-refinement-size "RefinementDefinition_1" 0.25 0.5 0.25 0.5 )
(sdedr:define-refinement-placement "RefinementPlacement_1" "RefinementDefinition_1" "RefEvalWin_1" )

;Region-based Mesh
(sdedr:define-refeval-window "RefEvalWin_2" "Rectangle"  (position xmeshmin1 ymeshmin1 0) (position xmeshmax1 ymeshmax1 0))
(sdedr:define-refinement-placement "RefinementPlacement_2" "RefinementDefinition_2" "RefEvalWin_2" )
(sdedr:define-refinement-size "RefinementDefinition_2" 0.05 0.5 0.05 0.5 )

(sdedr:define-refeval-window "RefEvalWin_3" "Rectangle"  (position xmeshmin2 ymeshmin2 0) (position xmeshmax2 ymeshmax2 0))
(sdedr:define-refinement-placement "RefinementPlacement_3" "RefinementDefinition_3" "RefEvalWin_3" )
(sdedr:define-refinement-size "RefinementDefinition_3" 0.05 0.5 0.05 0.5 )

(sde:save-model "sdesamplescript")
(sde:build-mesh "snmesh"  "-a -c boxmethod" "sdesamplescript")
