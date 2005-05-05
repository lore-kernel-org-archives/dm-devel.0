From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: unaligned access by multipathd logging
Date: Thu, 05 May 2005 17:42:57 -0400
Message-ID: <427A9361.2040009@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050707030701040003020905"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is a multi-part message in MIME format.
--------------050707030701040003020905
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi,

Logging code in multipathd cause unaligned access
which, on ia64, yields logs on both console and syslog like:
unaligned access to 0x60000000000141d1, ip=0x4000000000009d81

It's harmless except for the slight performance effect.
However, it's annoying for users and better to fix.

Attached patch aligns the la->tail to pointer size.
Patch is created on multipath-tools 0.4.4.
Please consider to apply.

This is a gdb trace of the case, for your reference:
#0  log_enqueue (prio=5, fmt=0x4000000000045970 "read /etc/multipath.conf",
    ap=0x6000000000013f70) at log.c:130
130             msg->prio = prio;
(gdb) where
#0  log_enqueue (prio=5, fmt=0x4000000000045970 "read /etc/multipath.conf",
    ap=0x6000000000013f70) at log.c:130
#1  0x400000000000a390 in log_safe (prio=5,
    fmt=0x4000000000045970 "read /etc/multipath.conf") at log_pthread.c:16
#2  0x4000000000007f60 in child (param=0x0) at main.c:883
#3  0x2000000000275930 in __clone2 () from /lib/tls/libc.so.6.1
(gdb) p msg
$1 = (struct logmsg *) 0x60000000000141d1
(gdb) p la->tail
$2 = (void *) 0x60000000000141d1
(gdb) p/x fwd
$3 = 0x31

Thanks,
Jun'ichi Nomura

--------------050707030701040003020905
Content-Type: text/x-patch;
 name="logarea.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="logarea.patch"

--- multipath-tools-0.4.4/multipathd/log.c.orig	2005-05-04 16:46:14.146824760 -0400
+++ multipath-tools-0.4.4/multipathd/log.c	2005-05-04 17:08:39.212237970 -0400
@@ -89,6 +89,7 @@ void log_close (void)
 	return;
 }
 
+#define ALIGN(len, s) (((len)+(s)-1)/(s)*(s))
 int log_enqueue (int prio, const char * fmt, va_list ap)
 {
 	int len, fwd;
@@ -101,10 +102,10 @@ int log_enqueue (int prio, const char * 
 	if (!la->empty) {
 		fwd = sizeof(struct logmsg) + 
 		      strlen((char *)&lastmsg->str) * sizeof(char) + 1;
-		la->tail += fwd;
+		la->tail += ALIGN(fwd, sizeof(void *));
 	}
 	vsnprintf(buff, MAX_MSG_SIZE, fmt, ap);
-	len = strlen(buff) * sizeof(char) + 1;
+	len = ALIGN(strlen(buff) * sizeof(char) + 1, sizeof(void *));
 
 	/* not enough space on tail : rewind */
 	if (la->head <= la->tail &&
@@ -128,7 +129,7 @@ int log_enqueue (int prio, const char * 
 	la->empty = 0;
 	msg = (struct logmsg *)la->tail;
 	msg->prio = prio;
-	memcpy((void *)&msg->str, buff, len);
+	memcpy((void *)&msg->str, buff, strlen(buff));
 	lastmsg->next = la->tail;
 	msg->next = la->head;
 

--------------050707030701040003020905
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050707030701040003020905--
