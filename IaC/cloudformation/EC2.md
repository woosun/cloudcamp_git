# !REF > 참조값 불러오기


AWSTemplateFormatVersion: 2010-09-09 #특정버전에서 사용하는 문법이다 라는 뜻
Resources:
    EC2Instance: #이름쓰는부분
        Type: AWS::EC2::Instance #AWS : 리소스 :
        Properties:
            ImageId: ami-068a0feb96796b48d  #생성할 이미지(AMI) 아이디
            KeyName: ec01 #!Ref KeyName 
            InstanceType: t2.micro  # !Ref InstanceType
            SecurityGroups: #보안그룹
            - default
            BlockDeviceMappings: # 저장장치 맵핍
            -
            DeviceName: /dev/sda1
            Ebs:
                VolumeSize: 8 #단위는 GB