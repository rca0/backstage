{%- if values.vpc %}
  vpc_subnet_ids                          = ["subnet-000000aaaaaa00000"]
  attach_network_policy                   = true
  vpc_security_group_ids                  = [aws_security_group.security_group.id]{% endif %}
