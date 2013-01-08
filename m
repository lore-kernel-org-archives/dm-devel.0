From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: fix set_oom_adj
Date: Mon, 7 Jan 2013 23:45:44 -0600
Message-ID: <20130108054543.GA19059@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Fix set_oom_adj() to work correclty if OOM_ADJUST_MIN isn't
defined.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: multipath-tools-120821/multipathd/main.c
===================================================================
--- multipath-tools-120821.orig/multipathd/main.c
+++ multipath-tools-120821/multipathd/main.c
@@ -1561,8 +1561,12 @@ set_oom_adj (void)
 				strerror(errno));
 			return;
 		}
+#ifdef OOM_ADJUST_MIN
 		file = "/proc/self/oom_adj";
 		score = OOM_ADJUST_MIN;
+#else
+		retry = 0;
+#endif
 	} while (retry--);
 	condlog(0, "couldn't adjust oom score");
 }
