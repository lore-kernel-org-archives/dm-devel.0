From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Failback delay in multipathd is 1 second shorter
Date: Wed, 12 Oct 2005 15:52:24 -0400 (EDT)
Message-ID: <20051012.155224.104027237.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: christophe.varoqui@free.fr
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

Current delay time of defered failback is 1 second shorter than
"failback" setting in multipath.conf, because defered_failback_tick()
is called before sleep(1) in checkerloop().

diff -rup git/multipathd/main.c failback-tick-fix/multipathd/main.c
--- git/multipathd/main.c	2005-10-12 10:08:28.000000000 -0400
+++ failback-tick-fix/multipathd/main.c	2005-10-12 14:16:12.000000000 -0400
@@ -1242,7 +1242,7 @@ checkerloop (void *ap)
 				 */
 				if (pp->mpp->pgfailback > 0)
 					pp->mpp->failback_tick =
-						pp->mpp->pgfailback;
+						pp->mpp->pgfailback + 1;
 				else if (pp->mpp->pgfailback == -FAILBACK_IMMEDIATE &&
 				    need_switch_pathgroup(pp->mpp, 1))
 					switch_pathgroup(pp->mpp);
@@ -1281,7 +1281,7 @@ checkerloop (void *ap)
 			if (need_switch_pathgroup(pp->mpp, 0)) {
 				if (pp->mpp->pgfailback > 0)
 					pp->mpp->failback_tick =
-						pp->mpp->pgfailback;
+						pp->mpp->pgfailback + 1;
 				else if (pp->mpp->pgfailback ==
 						-FAILBACK_IMMEDIATE)
 					switch_pathgroup(pp->mpp);

Regards,
Kiyoshi Ueda
