# Лабораторная работа №3

В лабораторной работе вам предлагается разобраться во внутреннем устройстве простейшего процессорного ядра архитектуры RISC-V. Результатом изучения микроархитектуры процессорного ядра и системы команд RISC-V станут ваши функциональные и нефункциональные модификации ядра.

Основное задание:

1. Модифицировать процессорное ядро, в соответствии с вашим вариантом;
2. Подготовить тестовое окружение системного уровня и убедиться в корректности вашей реализации путём запуска симуляционных тестов.

**Примечание**:

При непосредственном описании ваших модификаций в коде проекта, запрещено использовать несинтезируемые конструкции и арифметические операции, отличные от сложения и вычитания (то есть, умножение, деление и возведение в степень реализуйте сами посредством описания любого, понравившегося вам, алгоритма). Однако, в тестовом окружении использовать несинтезируемые конструкции и всевозможные арифметические операции можно (и даже нужно).

Варианты с буффером/очередью должны реализовать две команды.

- Первая команда - push xN - должна загружать данные из младшей части регистра xN в буффер/очередь.
- Вторая команда - pop xN - должна выгружать данные в младшую часть регистра xN.
