From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm thin: fix pool target flags that control
 discard
Date: Mon, 26 Mar 2012 16:46:26 +0100
Message-ID: <20120326154625.GB26558@ubuntu>
References: <20120316152156.GA8836@ubuntu>
	<1331911358-8848-1-git-send-email-ejt@redhat.com>
	<1331911358-8848-11-git-send-email-ejt@redhat.com>
	<20120323123747.GB16214@agk-dp.fab.redhat.com>
	<20120323215502.GB11054@redhat.com> <20120326141520.GA24249@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120326141520.GA24249@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

commit 1f04d92a1dd6173e38d7dc652dfe22876c40957e
Author: Joe Thornber <ejt@redhat.com>
Date:   Mon Mar 26 16:43:36 2012 +0100

    dm-thin: don't set ti->discards_supported for the pool target
    
    The pool is little more than a linear target; the default dm decision
    about whether to support discards is adequate.

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e5a6ed4..015cdce 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1646,10 +1646,8 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	pt->low_water_blocks = low_water_blocks;
 	pt->pf = pf;
 	ti->num_flush_requests = 1;
-	if (pf.discard_enabled && pf.discard_passdown) {
-		ti->discards_supported = 1;
+	if (pf.discard_enabled && pf.discard_passdown)
 		ti->num_discard_requests = 1;
-	}
 	ti->private = pt;
 
 	pt->callbacks.congested_fn = pool_is_congested;
