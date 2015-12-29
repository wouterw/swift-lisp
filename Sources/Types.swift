indirect enum Form {
  case Nil
  case False
  case True

  case Integer(Int)
  case Float(Swift.Float)
  case String(Swift.String)
  case Symbol(Swift.String)

  case List(Form, [Form])
}

