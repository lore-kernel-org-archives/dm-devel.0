From: NeilBrown <neilb@suse.de>
Subject: [PATCH 03/24] md/raid5: ensure we create a unique name for kmem_cache
	when mddev has no gendisk
Date: Tue, 01 Jun 2010 19:56:18 +1000
Message-ID: <20100601095618.565.91239.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

We will shortly allow md devices with no gendisk (they are attached to
a dm-target instead).  That will cause mdname() to return 'mdX'.
There is one place where mdname really needs to be unique: when
creating the name for a slab cache.
So in that case, if there is no gendisk, you the address of the mddev
formatted in HEX to provide a unique name.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid5.c |   12 ++++++++----
 drivers/md/raid5.h |    2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8647705..74e36a2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1269,10 +1269,14 @@ static int grow_stripes(raid5_conf_t *conf, int num)
 	struct kmem_cache *sc;
 	int devs = max(conf->raid_disks, conf->previous_raid_disks);
 
-	sprintf(conf->cache_name[0],
-		"raid%d-%s", conf->level, mdname(conf->mddev));
-	sprintf(conf->cache_name[1],
-		"raid%d-%s-alt", conf->level, mdname(conf->mddev));
+	if (conf->mddev->gendisk)
+		sprintf(conf->cache_name[0],
+			"raid%d-%s", conf->level, mdname(conf->mddev));
+	else
+		sprintf(conf->cache_name[0],
+			"raid%d-%p", conf->level, conf->mddev);
+	sprintf(conf->cache_name[1], "%s-alt", conf->cache_name[0]);
+
 	conf->active_name = 0;
 	sc = kmem_cache_create(conf->cache_name[conf->active_name],
 			       sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 0f86f5e..bb7ab92 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -388,7 +388,7 @@ struct raid5_private_data {
 	 * two caches.
 	 */
 	int			active_name;
-	char			cache_name[2][20];
+	char			cache_name[2][32];
 	struct kmem_cache		*slab_cache; /* for allocating stripes */
 
 	int			seq_flush, seq_write;


