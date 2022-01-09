resource "aws_transfer_server" "sftp_server" {
  protocols = ["SFTP"]
}

resource "aws_transfer_user" "transfer_user_zicodeng" {
  server_id      = aws_transfer_server.sftp_server.id
  user_name      = "zicodeng"
  role           = aws_iam_role.transfer_family_s3_role.arn
  home_directory = "/${local.s3_bucket_name}"
}

resource "aws_transfer_ssh_key" "transfer_ssh_key" {
  server_id = aws_transfer_server.sftp_server.id
  user_name = aws_transfer_user.transfer_user_zicodeng.user_name
  body      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1KAFj9y+w+x1cbMqElzRiv5XCMAboCNv9I1o+YEDKXYx8T6vRHEF6SfNl2ZhVJWf18TZOM+SHkZgtur3dLa976+CRs2KaR5NoVM8f7oy6ajxcBw0EYiyElYSOr0eHX3xvcy1a9jFim4uK08YQO/RwRKxfqn+awl9D12XP7D3LpE5al9588E5JwwYzoqHEcdQQXMdfhasxjT2Ug14MDB7WxHWOqsayBv5KiBscjZMwJBegcLAmSw2gJAyMmur/6brfbqyMsj6vuSvQJZDHMMHwMDWjQUElWSMvfdLtC4AKQtwSbkkrzrGLtpifxHLOpCkyV4DE+6ZbWaesztQjVaTAAmPQ5CwyS533uYJOgRLQ0gu2shNsMcmWVIBdFfmQR81j22RZNSXG/OinvaDV9GE2CcRgyrwWGv4bD+EdEEPYol2K0hkcaarTrkxua+D2/px/12iSvdxj4HsxdLsEf3wrkGI3zkftaM6cCr/KHe43I0GMpA5d+DvZw2fj+iuikTE= zicodeng"
}
