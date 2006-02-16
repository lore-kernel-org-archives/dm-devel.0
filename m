From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: dm-multipath: failback problem.
Date: Thu, 16 Feb 2006 10:48:08 -0600
Message-ID: <20060216164808.GA15044@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
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


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

If the failback period is set to more that four times the polling interval,
paths will never fail back. This is because the failback_tick keeps getting
reet. The attached patch fixes this.

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="failback.patch"

diff -urpN mp-devel-clean/multipathd/main.c mp-devel-patched/multipathd/main.c
--- mp-devel-clean/multipathd/main.c	2006-02-15 15:26:13.000000000 -0600
+++ mp-devel-patched/multipathd/main.c	2006-02-15 17:48:56.000000000 -0600
@@ -1265,7 +1265,8 @@ checkerloop (void *ap)
 			pathinfo(pp, conf->hwtable, DI_PRIO);
 
 			if (need_switch_pathgroup(pp->mpp, 0)) {
-				if (pp->mpp->pgfailback > 0)
+				if (pp->mpp->pgfailback > 0 &&
+				    pp->mpp->failback_tick <= 0)
 					pp->mpp->failback_tick =
 						pp->mpp->pgfailback + 1;
 				else if (pp->mpp->pgfailback ==

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--NzB8fVQJ5HfG6fxh--
