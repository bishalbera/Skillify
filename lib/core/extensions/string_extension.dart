extension StringExt on String {
  String get obscureEmail {
    // split the email into username and domain
    final index = indexOf('@');
    var username = substring(0, index);
    final domain = substring(index + 1);

    // Obscure the username and display only the first and last characters
    username = '${username[0]}****${username[username.length - 1]}';
    return '$username@$domain';
  }

  bool get isYoutubeVideo =>
      contains('youtube.com/watch?v=') || contains('youtu.be/');
}
