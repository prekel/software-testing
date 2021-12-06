open Alcotest
open AlcotestExt
module Vector2 = Lab01_vector.Vector.Vector2
open CheckVector (Vector2)

module Add = struct
  type test_add_param =
    { msg : string
    ; vec1 : float * float
    ; vec2 : float * float
    ; sum : float * float
    ; eps : float
    }

  let test_add () { vec1 = v1x, v1y; vec2 = v2x, v2y; sum = sx, sy; eps } =
    (* Arrange *)
    let v1 = Vector2.make v1x v1y in
    let v2 = Vector2.make v2x v2y in
    (* Act *)
    let s_add = Vector2.add v1 v2 in
    let s_infix = Vector2.Infix.(v1 + v2) in
    (* Assert *)
    check_vector
      ~msg:"Sum through function"
      ~expected:(Vector2.make sx sy)
      ~actual:s_add
      ~eps;
    check_vector
      ~msg:"Sum through infix operator"
      ~expected:(Vector2.make sx sy)
      ~actual:s_infix
      ~eps
  ;;

  let tests =
    fixtures_parameterized
      ~before:Fn.id
      ~after:Fn.id
      ~params:
        [ { msg = "All zeros"; vec1 = 0., 0.; vec2 = 0., 0.; sum = 0., 0.; eps = 0. }
        ; { msg = "(1,2) + (3,4) = (4,6)"
          ; vec1 = 1., 2.
          ; vec2 = 3., 4.
          ; sum = 4., 6.
          ; eps = 1e-8
          }
        ]
      ~param_to_string:(fun { msg } -> msg)
      ~tests:[ "Vector sum", `Quick, test_add ]
  ;;
end

module Sub = struct
  type test_sub_param =
    { msg : string
    ; vec1 : float * float
    ; vec2 : float * float
    ; result : float * float
    ; eps : float
    }

  let test_sub () { vec1 = v1x, v1y; vec2 = v2x, v2y; result = sx, sy; eps } =
    (* Arrange *)
    let v1 = Vector2.make v1x v1y in
    let v2 = Vector2.make v2x v2y in
    (* Act *)
    let s_sub = Vector2.sub v1 v2 in
    let s_infix = Vector2.Infix.(v1 - v2) in
    (* Assert *)
    check_vector
      ~msg:"Subtraction through function"
      ~expected:(Vector2.make sx sy)
      ~actual:s_sub
      ~eps;
    check_vector
      ~msg:"Subtraction through infix operator"
      ~expected:(Vector2.make sx sy)
      ~actual:s_infix
      ~eps
  ;;

  let tests =
    fixtures_parameterized
      ~before:Fn.id
      ~after:Fn.id
      ~params:
        [ { msg = "All zeros"; vec1 = 0., 0.; vec2 = 0., 0.; result = 0., 0.; eps = 0. }
        ; { msg = "(1,2)-(3,4)=(-2,-2)"
          ; vec1 = 1., 2.
          ; vec2 = 3., 4.
          ; result = -2., -2.
          ; eps = 1e-8
          }
        ]
      ~param_to_string:(fun { msg } -> msg)
      ~tests:[ "Subtraction", `Quick, test_sub ]
  ;;
end

module Eq = struct
  type test_param_eq =
    { msg : string
    ; vec1 : float * float
    ; vec2 : float * float
    ; expected : bool
    ; eps : float
    }

  let test_eq () { vec1 = v1x, v1y; vec2 = v2x, v2y; expected; eps } =
    (* Arrange *)
    let v1 = Vector2.make v1x v1y in
    let v2 = Vector2.make v2x v2y in
    (* Act *)
    let s_sub = Vector2.equal v1 v2 ~eps in
    if Float.(eps = 0.)
    then begin
      let s_infix = Vector2.Infix.(v1 = v2) in
      check' bool ~msg:"Equal through infix operator" ~expected ~actual:s_infix
    end;
    (* Assert *)
    check' bool ~msg:"Equal through function" ~expected:s_sub ~actual:s_sub
  ;;

  let tests =
    fixtures_parameterized
      ~before:Fn.id
      ~after:Fn.id
      ~params:
        [ { msg = "All zeros"; vec1 = 0., 0.; vec2 = 0., 0.; expected = true; eps = 0. }
        ; { msg = "(1,2)-(3,4)=(-2,-2)"
          ; vec1 = 1., 2.
          ; vec2 = 3., 4.
          ; expected = false
          ; eps = 1e-8
          }
        ]
      ~param_to_string:(fun { msg } -> msg)
      ~tests:[ "Equality", `Quick, test_eq ]
  ;;
end

let suite = "2D Vector tests", Add.tests |> List.append Sub.tests |> List.append Eq.tests
