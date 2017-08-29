From: NeilBrown <neilb@suse.com>
Subject: [PATCH 1/2] dm-crypt: remove BIOSET_NEED_RESCUER flag.
Date: Wed, 30 Aug 2017 08:10:18 +1000
Message-ID: <150404461886.12966.16601503710996159531.stgit@noble>
References: <150404441182.12966.7067251378068944343.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <150404441182.12966.7067251378068944343.stgit@noble>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The BIOSET_NEED_RESCUER flag is only needed when a
make_request_fn might do two allocations from the one bioset,
and the second one could block until the first bio completes.

dm-crypt does allocate from this bioset inside the dm make_request_fn,
but does so using GFP_NOWAIT so that the allocation will not block.

So BIOSET_NEED_RESCUER is not needed.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/dm-crypt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cdf6b1e12460..e7dc1a6b5a9d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2696,8 +2696,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	cc->bs = bioset_create(MIN_IOS, 0, (BIOSET_NEED_BVECS |
-					    BIOSET_NEED_RESCUER));
+	cc->bs = bioset_create(MIN_IOS, 0, BIOSET_NEED_BVECS);
 	if (!cc->bs) {
 		ti->error = "Cannot allocate crypt bioset";
 		goto bad;
