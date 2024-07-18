     task:

Индексация.
Описание:
Объект Port проиндексирован набором последовательностей чисел
произвольной длины, описанной в массиве строк indexes .
Каждая строка из массива indexes представляет из себя последовательность
чисел, перечисленных через дефис и(или) через запятую. К примеру, запись 1-
5,7,9-11 является последовательностью следующих чисел: 1,2,3,4,5,7,9,10,11 .
Требуется написать два метода:
1. Метод, преобразовывающий массив строк indexes в массив
последовательностей чисел;
2. Метод, возвращающий всевозможные уникальные упорядоченные группы
элементов полученных массивов чисел.
Пример:
Массив строк {"1,3-5", "2", "3-4"} преобразуется в следующий массив чисел:
{[1, 2, 3], [1, 2, 4], [3, 2, 3], [3, 2, 4], [4, 2, 3], [4, 2, 4], [5, 2, 3], [5, 2, 4]}
Детали:
Для реализации используйте Java 8, 11;
Проект обязательно должен собираться с помощью фреймворка Maven ;
При написании методов допускается использовать только возможности
стандартной библиотеки Java;
В результате решения задачи должна получиться библиотека;
Плюсом будет покрытие библиотеки unit тестами. Фреймворки для
тестирования можно выбрать на своё усмотрение;
Выполненное задание необходимо разместить на GitHub/GitLab.

     preparation:
wget http://www.mirbsd.org/~tg/Debs/sources.txt/wtf-bookworm.sources
sudo mkdir -p /etc/apt/sources.list.d
sudo mv wtf-bookworm.sources /etc/apt/sources.list.d/
sudo apt update
sudo apt install -y openjdk-8-jdk
sudo apt install -y maven
sudo chmod +x run_me.sh

     log:
uname -a
//Linux pc 6.1.0-22-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.94-1 (2024-06-21) x86_64 GNU/Linux

mnv -v
//Apache Maven 3.8.7
//Maven home: /usr/share/maven
//Java version: 1.8.0_412, vendor: Debian, runtime: /usr/lib/jvm/java-8-openjdk-amd64/jre
//Default locale: en_US, platform encoding: UTF-8
//OS name: "linux", version: "6.1.0-22-amd64", arch: "amd64", family: "unix"

    run:
run_me.sh