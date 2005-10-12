From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Path check interval in multipathd is 1 second longer
Date: Wed, 12 Oct 2005 15:50:02 -0400 (EDT)
Message-ID: <20051012.155002.71083127.k-ueda@ct.jp.nec.com>
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

Current path check interval is 1 second longer than polling_interval
setting in multipath.conf.

This bug affects the "no_path_retry" option.
For example, if no_path_retry is set in 1, retry (== path check) will
not be launched in no-path situation.

diff -rup git/multipathd/main.c pathcheck-int-fix/multipathd/main.c
--- git/multipathd/main.c	2005-10-12 10:08:28.000000000 -0400
+++ pathcheck-int-fix/multipathd/main.c	2005-10-12 15:33:13.000000000 -0400
@@ -1175,13 +1175,8 @@ checkerloop (void *ap)
 			if (!pp->mpp)
 				continue;
 
-			if (pp->tick) {
-				/*
-				 * don't check this path yet
-				 */
-				pp->tick--;
-				continue;
-			}
+			if (pp->tick && --pp->tick)
+				continue; /* don't check this path yet */
 
 			/*
 			 * provision a next check soonest,
 
Regards,
Kiyoshi Ueda
