# 🚀 Terraform Deploy Moodle LMS on AWS

Triển khai Moodle LMS trên AWS EC2 tự động với Terraform.

## 📋 Yêu cầu

- Ubuntu/Debian Linux
- AWS Account
- IAM User với quyền EC2 FullAccess

## 🔑 Chuẩn bị AWS IAM

### 1. Tạo IAM User

Đăng nhập [AWS Console](https://console.aws.amazon.com/) → **IAM** → **Users** → **Add users**

### 2. Gán quyền

- Chọn **Attach existing policies directly**
- Tìm và chọn: **`AmazonEC2FullAccess`**
- Click **Next** → **Create user**

### 3. Lưu credentials

⚠️ **QUAN TRỌNG**: Copy và lưu lại ngay:

```
Access key ID: ...
Secret access key: ...
```


## 🚀 Triển khai

### 1. Chạy setup script

```bash
chmod +x setup.sh
./setup.sh
```

Script sẽ tự động:
- ✅ Cài đặt AWS CLI
- ✅ Cài đặt Terraform
- ✅ Yêu cầu cấu hình AWS credentials (nhập Access Key và Secret Key từ bước trên)
- ✅ Chạy `terraform init`
- ✅ Chạy `terraform apply`

### 3. Lấy thông tin instance

Sau khi deploy xong, bạn sẽ thấy:

```
instance_public_ip = "xx.xxx.xxx.xxx"
instance_public_dns = "ec2-xx-xxx-xxx-xxx.compute.amazonaws.com"
```

### 4. Kết nối SSH

```bash
ssh ubuntu@<instance_public_ip>
```

## 🗑️ Xóa tài nguyên

```bash
terraform destroy -auto-approve
```

## 🐛 Troubleshooting

**AWS credentials not configured?**
```bash
aws configure
```
Nhập Access Key ID, Secret Access Key, region (ví dụ: `ap-southeast-1`), format (`json`)
