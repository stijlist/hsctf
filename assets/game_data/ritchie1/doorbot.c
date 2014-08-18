#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* password;

int check_password() {
  int success = 0;
  char password_guess[32];
  puts("Enter the password to open the door");
  fflush(stdout);
  scanf("%[^\n]", password_guess);
  if (strcmp(password_guess, password) == 0) {
    success = 1;
  }
  return success;
}

void open_door() {
  printf("Opening Hacker School Door. You got in with the password: %s\n", password);
}

int main(int argc, char **argv) {
  password = malloc(32);
  FILE *fp = fopen("./password", "r");
  fscanf(fp, "%s", password);
  fclose(fp);

  puts("Hi there!\nWelcome to Hacker School.");
  fflush(stdout);
  if (check_password()) {
    open_door();
  } else {
    puts("I can't let you do that Dave");
    fflush(stdout);
  }
  return 0;
}
