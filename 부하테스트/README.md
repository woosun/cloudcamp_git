부하테스트<br>
  1) 부하테스트란?<br>
	우리가 만든 웹 서비스가 목표 응답시간 기준으로 얼마만큼의 동시 접속자 수를 견딜수 있는가를 테스트하기 위한 목적<br>
	동시접속자 수를 TPS로 환산하여 자원적인 관점으로 사용자 대비 용량 산정<br>
	즉, 사용자의 추이에 따라 적절한 자원을 배분하는 것, 더 나아가 병목구간을 찾아 제거하는 것<br>
	출시 전 대부분의 어플리케이션이 성능 저하를 일으키는 병목구간을 가지고 있다. <br>
	출시 전에 얼마나 이 부분을 많이 해결하느냐가 매우 중요<br>
	즉 부하를 발생시키는 것도 중요하지만, 병목구간이 무엇인지 찾아내는 것이 필요<br>
	APM (Application Performance Monitoring)과 인프라 모니터링(Infrastructure Monitoring)의 지표들을 읽어내고, <br>
	병목 구간의 문제가 코드의 잘못인지, 자원의 부족인지, 세팅값의 잘못인지 찾아내어 개발자 레벨로 설명을 해주는 능력이 필요<br>
  2) 부하테스트의 종류<br>
    (1) 부하 테스트 (Load Test) <br>
	특정한 부하를 제한된 시간을 두어서 웹 어플리케이션에 이상이 없는지 파악하는 테스트<br>
    (2) 지속성 테스트 (Endurance Test)<br>
	Load Test와 유사하나 오랜 기간 부하를 줘서 하는 테스트<br>
    (3) 스트레스 테스트 (Stress Test)<br>
	부하의 임계점을 찾기 위해 점진적으로 부하를 올리면서 진행하는 테스트<br>
    (4) 최고 부하 테스트 (Peak Test)<br>
	일순간 감당할 수 없을 만큼 부하를 주고, 웹 어플리케이션이 죽지 않고 제대로 동작하고 회복하는지 보는 테스트<br>
	수강신청이나 이벤트 등 대규모 상황을 대비하기 위해 진행<br>
  3) 부하테스트 프로그램의 종류<br>
	JMeter, Load Runner, nGrinder, Gatling<br>
  4) APM의 종류<br>
	부하를 발생시킨 후, 웹 어플리케이션의 주요 병목지점을 찾아내는 것이 중요<br>
	웹 어플리케이션의 병목을 찾아주는 MRI같은 장치가 APM<br>
	APM의 가장 대표적인 솔루션은 제니퍼소프트<br>
	네이버에서 개발한 pinpoint나 jaeger와 같은 도구도 있음<br>

=== 실습환경 === <br>
<a href=./test_3tir.yml>3tir</a><br>
nginx + python(flask,gunicon) + mysql <br>