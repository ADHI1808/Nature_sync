String limitString(String string, int length) =>
    string.length < length ? string : "${string.substring(0, length - 3)}...";
