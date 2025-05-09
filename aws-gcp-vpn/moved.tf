moved {
  from = aws_vpn_gateway.default
  to   = aws_vpn_gateway.this[0]
}
