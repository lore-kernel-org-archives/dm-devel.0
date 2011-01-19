From: Malahal Naineni <malahal@us.ibm.com>
Subject: [PATCH] [RFC] multipath: change the DEFAULT_MINIO for
 the request based multipath
Date: Wed, 19 Jan 2011 13:30:07 -0800
Message-ID: <91d6dae7d88296d8a1fe.1295472607@malahal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

The value of 1000 is good for bio based multipath. Seen 50% increase in
I/O ops by setting it to 1 in request based multipath configuration.
This patch would give poor performance for people still using the bio
based multipath!

Is it possible to detect request based multipath and change only for
those configurations?

diff -r e504a50b0db5 -r 91d6dae7d882 libmultipath/defaults.h
--- a/libmultipath/defaults.h	Wed Jan 19 13:16:40 2011 -0800
+++ b/libmultipath/defaults.h	Wed Jan 19 13:29:52 2011 -0800
@@ -5,7 +5,7 @@
 #define DEFAULT_ALIAS_PREFIX	"mpath"
 #define DEFAULT_FEATURES	"0"
 #define DEFAULT_HWHANDLER	"0"
-#define DEFAULT_MINIO		1000
+#define DEFAULT_MINIO		1
 #define DEFAULT_PGPOLICY       FAILOVER
 #define DEFAULT_FAILBACK       -FAILBACK_MANUAL
 #define DEFAULT_RR_WEIGHT      RR_WEIGHT_NONE
