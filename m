From: Dan Carpenter <error27@gmail.com>
Subject: [patch] md/dm-log: use PTR_ERR value instead of -ENOMEM
Date: Sun, 16 May 2010 08:31:19 +0200
Message-ID: <20100516063119.GC18464@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

It's nicer to return the PTR_ERR() value instead of just returning
-ENOMEM.  In the current code the PTR_ERR() value is always equal to
-ENOMEM so this doesn't actually affect anything, but still...

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 5a08be0..fbd80fb 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -455,7 +455,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 			r = PTR_ERR(lc->io_req.client);
 			DMWARN("couldn't allocate disk io client");
 			kfree(lc);
-			return -ENOMEM;
+			return r;
 		}
 
 		lc->disk_header = vmalloc(buf_size);
