void setup() {
    Serial.begin(9600);
    while (!Serial) {
        delay(1);
    }

    pinMode(12, INPUT);
}

void choose_and_send_key() {
    char key = 'l';
    long held_for = 0;

    while (1) {
        if (digitalRead(12) == LOW) {
            delay(10);
            if (digitalRead(12) == LOW)
                break;
        }
        ++held_for;
        if (held_for >= 750) {
            key = 'h';
            break;
        }
        delay(1);
    }

    Serial.print(key);

    delay(10);

    while (1)
        if (digitalRead(12) == LOW) {
            delay(10);
            if (digitalRead(12) == LOW)
                break;
        }
        delay(1);
}

void loop() {
    if (digitalRead(12) == HIGH)
        choose_and_send_key();
}
