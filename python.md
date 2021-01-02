### File 구조
``
{
    "terraform": {
        {
            "key1":"value1",
            "key2":"value2",
            "key3":"value3"
        }
    },
    "aws": {
        {
            "key1":"value1",
            "key2":"value2",
            "key3":"value3"
        }
    },
    "docker": {
        {
            "key1":"value1",
            "key2":"value2",
            "key3":"value3"
        }
    }
}
``

### 만들어야할 function
* 옵션 값으로 변수 값을 받자(환경, 애플리케이션 이름)
* envfile 들어왔을때 Json 파일로 3개의 데이터 작성(tfvars, aws, docker)
* 해당 앱명에 prod or stage 환경의 디렉토리가 있는지 확인(있으면 excepction)
* envfile 만드는 json을 consul에 file로 저장하고
* terraform 실행시 만들어지는 tfstate 파일도 consul에 app에 디렉토리에 tfstate 저장 (변수로 버전화을 입력 하거나 terraform release 버전을 가져와서 실행)