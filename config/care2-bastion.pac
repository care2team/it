function FindProxyForURL(url, host) {
	if (shExpMatch(host, "earthworm.care2.com"))
	{
	   return  "SOCKS5 127.0.0.1:8080";
	} 
  return DIRECT;
}
