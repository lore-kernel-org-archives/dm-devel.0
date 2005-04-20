From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: log_enqueue frequently overruns log_area
Date: Wed, 20 Apr 2005 15:59:05 -0500
Message-ID: <20050420205905.GI8789@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="bKyqfOwhbdpXa4YI"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

After seeing multipathd not logging what I was expecting it to, I checked to
see if it was ever dropping messages, and it was. In fact, I get dropped
messages on start up most of the time. The attached patch, against
multipath-tools-0.4.4-pre16, doubles the default logarea size. At that size,
I haven't seen any dropped messages. I'm not sure that this is the right
size, but it definitely works better for me.

-Ben

--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="bigger_buffer.patch"

diff -urN multipath-tools-0.4.4-pre16/multipathd/log.h multipath-tools-bigger_buffer/multipathd/log.h
--- multipath-tools-0.4.4-pre16/multipathd/log.h	2005-03-31 03:24:46.000000000 -0600
+++ multipath-tools-bigger_buffer/multipathd/log.h	2005-04-20 14:33:01.000000000 -0500
@@ -1,7 +1,7 @@
 #ifndef LOG_H
 #define LOG_H
 
-#define DEFAULT_AREA_SIZE 2048
+#define DEFAULT_AREA_SIZE 4096
 #define MAX_MSG_SIZE 128
 
 #ifndef LOGLEVEL

--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--bKyqfOwhbdpXa4YI--
