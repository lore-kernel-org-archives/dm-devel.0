From: Chao Yang <chyang@redhat.com>
Subject: What is a /dev/dm-* file ?
Date: Wed, 20 Jul 2011 04:34:38 -0400 (EDT)
Message-ID: <46858323.1450041.1311150878186.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>
References: <1353628002.1450009.1311150616312.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1416825870292806817=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1353628002.1450009.1311150616312.JavaMail.root@zmail01.collab.prod.int.phx2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1416825870292806817==
Content-Type: multipart/alternative;
	boundary="----=_Part_1450040_1693891686.1311150878185"

------=_Part_1450040_1693891686.1311150878185
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi there, 

I have questions about /dev/dm-* in my mind for days, it seems here is the right place for the answers. 
What is a /dev/dm-* file? it says "/dev/dm-0: block special" from file command. 
Is there a limitation to the number of /dev/dm-* files ? I tried with RHEL6.1 GA, created 800 from dm-0 to dm-799 as maximum. 
Thanks. 


Best, 
Chao 


------=_Part_1450040_1693891686.1311150878185
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html><head><style type='text/css'>p { margin: 0; }</style></head><body><div style='font-family: Times New Roman; font-size: 12pt; color: #000000'>Hi there,<br><br>I have questions about /dev/dm-* in my mind for days, it seems here is the right place for the answers. <br>What is a /dev/dm-* file?&nbsp; it says "/dev/dm-0: block special" from file command. <br>Is there a limitation to the number of /dev/dm-* files ? I tried with RHEL6.1 GA, created 800 from dm-0 to dm-799 as maximum. <br>Thanks. <br><br><span><br><span name="x"></span>Best,<br>Chao<span name="x"></span><br></span><br></div></body></html>
------=_Part_1450040_1693891686.1311150878185--


--===============1416825870292806817==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1416825870292806817==--
