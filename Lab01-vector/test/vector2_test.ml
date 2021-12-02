open Alcotest
open AlcotestExt
module Vector2 = Lab01_vector.Vector.Vector2

type test_add_param = {
  vec1 : float * float;
  vec2 : float * float;
  sum : float * float;
  eps : float;
}

open CheckVector (Vector2)

let test_add () { vec1 = v1x, v1y; vec2 = v2x, v2y; sum = sx, sy; eps } =
  (* Arrange *)
  let v1 = Vector2.make v1x v1y in
  let v2 = Vector2.make v2x v2y in
  (* Act *)
  let s_add = Vector2.add v1 v2 in
  let s_infix = Vector2.Infix.(v1 +^ v2) in
  (* Assert *)
  check_vector ~msg:"" ~expected:(Vector2.make sx sy) ~actual:s_add ~eps;
  check_vector ~msg:"" ~expected:(Vector2.make sx sy) ~actual:s_infix ~eps;
  fail "arst"

let suite =
  fixtures_parameterized ~before:Fn.id ~after:Fn.id
    ~params:
      [
        (* TODO *)
        { vec1 = (0., 0.); vec2 = (0., 0.); sum = (0., 0.); eps = 0. };
      ]
    ~param_to_string:(fun _ -> "")
    ~tests:[ ("Vector sum testing", `Quick, test_add) ]
