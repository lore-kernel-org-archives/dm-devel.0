From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: don't clear daemon setting on
	reconfigure
Date: Wed, 19 May 2010 23:00:45 -0500
Message-ID: <20100520040045.GT3295@ether.msp.redhat.com>
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
List-Id: dm-devel.ids

When you reconfigure multipathd, it needs to set the daemon flag in the
new config structure, so that the daemon only-code will still work.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c |    1 +
 1 file changed, 1 insertion(+)

Index: multipath-tools-100510/multipathd/main.c
===================================================================
--- multipath-tools-100510.orig/multipathd/main.c
+++ multipath-tools-100510/multipathd/main.c
@@ -1198,6 +1198,7 @@ reconfigure (struct vectors * vecs)
 		conf->checkint = DEFAULT_CHECKINT;
 		conf->max_checkint = MAX_CHECKINT(conf->checkint);
 	}
+	conf->daemon = 1;
 	configure(vecs, 1);
 	free_config(old);
 	return 0;
