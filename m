From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCHES] convert dm-thin to use dm-bufio
Date: Mon, 22 Aug 2011 15:59:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108221556550.25412@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
	<20110819091224.GB3193@ubuntu> <20110819161745.GA27778@ubuntu>
	<Pine.LNX.4.64.1108221421130.26814@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1108221421130.26814@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

> > I've merged and pushed this to my git repo.
> 
> I checkouted the tree now (I tried all branches reported with git-branch 
> -a), but I couldn't see bufio in any of the branches.

It was my mistake --- I forgot to do git-fetch before git-checkout.

Here is a patch that uses down_read_trylock instead of down_read in 
dm_bm_read_try_lock.

Mikulas

---
 drivers/md/persistent-data/dm-block-manager.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-3.0-fast/drivers/md/persistent-data/dm-block-manager.c
===================================================================
--- linux-3.0-fast.orig/drivers/md/persistent-data/dm-block-manager.c	2011-08-22 21:53:31.000000000 +0200
+++ linux-3.0-fast/drivers/md/persistent-data/dm-block-manager.c	2011-08-22 21:54:38.000000000 +0200
@@ -176,7 +176,10 @@ int dm_bm_read_try_lock(struct dm_block_
 		return -EWOULDBLOCK;
 
 	aux = dm_bufio_get_aux_data(*result);
-	down_read(&aux->lock);
+	if (unlikely(!down_read_trylock(&aux->lock))) {
+		dm_bufio_release(*result);
+		return -EWOULDBLOCK;
+	}
 	aux->write_locked = 0;
 
 	r = dm_bm_validate_buffer(bm, *result, aux, v);
