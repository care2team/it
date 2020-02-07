function FindProxyForURL(url, host) {
	if (shExpMatch(host, "*.care2.com"))
	{
		if ( shExpMatch(host, "*.(corp|dpd1|rwc|sjc1|iad1|snv1).care2.com") ) {
			return  "SOCKS5 127.0.0.1:8080";
		} else if ( shExpMatch(host, "jenkins.care2.com") ) {
			return  "SOCKS5 127.0.0.1:8080";
		} else if ( dnsResolve(host) == null ) {
			return  "SOCKS5 127.0.0.1:8080";
		} else {
		  return "DIRECT";
		}
	} 
  return "DIRECT";
}
