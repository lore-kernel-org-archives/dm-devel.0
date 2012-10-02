From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] dm thin: check kmalloc in dm_deferred_set_create()
Date: Tue, 2 Oct 2012 14:46:49 +0300
Message-ID: <20121002114649.GA1413@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

We can simply return NULL here.  The callers already handle that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index da0d5d1..fa7d21e 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -394,6 +394,8 @@ static struct dm_deferred_set *dm_deferred_set_create(void)
 	struct dm_deferred_set *ds;
 
 	ds = kmalloc(sizeof(*ds), GFP_KERNEL);
+	if (!ds)
+		return NULL;
 
 	spin_lock_init(&ds->lock);
 	ds->current_entry = 0;
