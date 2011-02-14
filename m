From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH][RFC] dm: Do not open log and cow device read-write for read-only
 mappings
Date: Mon, 14 Feb 2011 14:14:57 +0100
Message-ID: <4D592AD1.6020500@redhat.com>
References: <4D573BBB.6090200@redhat.com> <1297594735-5593-1-git-send-email-tm@tao.ma> <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma> <4D580A8B.5050508@redhat.com> <20110214103026.GA18742@htj.dyndns.org> <4D591664.6090203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D591664.6090203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> But it doesn't fix the read-only snapshot issue and I guess there will be
> the same problem with read-only MD code too.
> (so the 2) issue here https://lkml.org/lkml/2011/2/12/209).
I am not sure if this is complete fix... note that:
- what happens during mirror resync and read-only log?
- for COW, it there situation we need to update header in read-oly mode? (invalidated snap?)
Milan
--

[RFC] Do not open log and cow device read-write for read-only mappings

Signed-off-by: Milan Broz <mbroz@redhat.com> 

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 6951536..8e8a868 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -543,7 +543,7 @@ static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	r = dm_get_device(ti, argv[0], FMODE_READ | FMODE_WRITE, &dev);
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &dev);
 	if (r)
 		return r;
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index fdde53c..a2d3309 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1080,7 +1080,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argv++;
 	argc--;
 
-	r = dm_get_device(ti, cow_path, FMODE_READ | FMODE_WRITE, &s->cow);
+	r = dm_get_device(ti, cow_path, dm_table_get_mode(ti->table), &s->cow);
 	if (r) {
 		ti->error = "Cannot get COW device";
 		goto bad_cow;
