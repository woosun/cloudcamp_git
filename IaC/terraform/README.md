Terraform</br>
	테라폼(Terraform)은 하시코프Hashicorp에서 오픈소스로 개발중인 </br>
	클라우드 인프라스트럭처 자동화를 지향하는 코드로서의 인프라스트럭처Infrastructure as Code, IaC 도구</br>
	IaC는 코드로 인프라스트럭처를 관리한다는 개념으로 테라폼에서는 하시코프 설정 언어HCL, Hashicorp Configuration Language을 사용해 </br>
	클라우드 리소스를 선언합니다. </br>
	아마존 웹 서비스Amazon Web Service가 자체적으로 만든 AWS 클라우드 포메이션AWS CloudFormation의 경우 AWS만 지원하는 것과 달리 </br>
	테라폼의 경우 아마존 웹 서비스Amazon Web Service, 구글 클라우드 플랫폼Google Cloud Platform, 마이크로소프트 애저Microsoft Azure와 같은 </br>
	주요 클라우드 서비스를 비롯한 다양한 클라우드 서비스들을 프로바이더 방식으로 제공하고 있습니다. </br>
	이를 통해 테라폼만으로 멀티 클라우드의 리소스들을 선언하고 코드로 관리하는 것도 가능합니다.</br>
</br>
  1) 테라폼 특징</br>
	API를 호출해 명령을 실행하는 절차적인 방법과 달리 HCL은 선언적으로 리소스를 정의하기 때문에 </br>
	리소스를 정의하고 여러번 테라폼을 실행한다고 여러 개의 리소스가 만들어지지는 않습니다. </br>
</br>
	코드를 한번 실행 것과 여러번 실행한 결과가 같은 성질(멱등성)</br>
</br>
  2) 테라폼 맛보기</br>
    (1) 테라폼 설치</br>
      [1] terraform 명령어 설치</br>
	https://www.terraform.io/downloads</br>
</br>
      [2] awk cli 설치</br>
	https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html</br>
</br>
    (2) 개발 환경 설정</br>
      [1] aws 인증 정보 설정</br>
	CMD에서 </br>
		aws configure list	설정 정보 확인</br>
</br>
	AWS 보안자격증명에서 Access Key  발급</br>
</br>
	CMD에서</br>
		aws configure 명령어 실행</br>
		발급 받은 Access Key 내용 입력</br>
		Region은 ap-northeast-2</br>
		Default output format은 그냥 엔터</br>
	</br>
      [2] VSCode 다운 및 설치</br>
	https://code.visualstudio.com/</br>
	hashicorp Terraform 플러그인 추가</br>
      [3] </br>
      [4] </br>
      [5] </br>
</br>
    (3) 테라폼 코드 작성</br>
<a href="./ex01/main.tf">/ex01/main.tf</a>
</br>
</br>
    [4] 테라폼 명령어 실행</br>
	terraform init	초기화</br>
	terraform validate	검증</br>
	terraform plan	계획</br>
	terraform apply	적용</br>
	terraform destroy	제거</br>
	terraform show	상태 확인</br>
	</br>
</br>
  3) 테라폼 구성요소</br>
	provider: 테라폼으로 생성할 인프라의 종류를 의미</br>
	resource: 테라폼으로 실제로 생성할 인프라 자원을 의미</br>
	state: 테라폼을 통해 생성한 자원의 상태를 의미</br>
	output: 테라폼으로 만든 자원을 변수 형태로 state에 저장하는 것을 의미</br>
	module: 공통적으로 활용할 수 있는 코드를 문자 그대로 모듈 형태로 정의하는 것을 의미</br>
	remote: 다른 경로의 state를 참조하는 것을 의미, output 변수를 불러올때 주로 사용	</br>
</br>
  4) 테라폼 작동 원리</br>
	Local 코드 : 현재 개발자가 작성/수정하고 있는 코드</br>
	AWS 실제 인프라 : 실제로 AWS에 배포되어 있는 인프라</br>
	Backend에 저장된 상태 : 가장 최근에 배포한 테라폼 코드 형상</br>
</br>
	테라폼은 실제 인프라와 Backend에 저장된 상태를 일치하도록 만드는 프로그램</br>
</br>
    [1] Terraform init</br>
	terraform init 명령어는 프로젝트를 terraform을 구동할 수 있는 환경으로 만들어준다. </br>
	보통 provider가 작성된 main.tf가 존재하는 경로에서 사용된다. terraform 최초 구동 시 반드시 필요한 명령어이다.</br>
	</br>
    [2] terraform plan</br>
	현재 작성된 terraform 코드로 생성되고 변경될 내역을 보여준다. </br>
	실제 환경에 적용하기 전 검증할 수 있게 하는 매우 중요한 명령어이다. </br>
	또한 terraform 코드의 문법적 오류가 없는지도 검증할 수 있다.</br>
</br>
    [3] terraform apply</br>
	terraform apply는 실제로 인프라스트럭처를 구성한다.</br>
</br>
    [4] terraform destroy</br>
	구성했던 인프라스트럭처의 resource를 모두 회수한다. </br>
	














