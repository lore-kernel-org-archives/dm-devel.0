From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] dm verity: fix incorrect error message
Date: Thu,  8 Sep 2016 12:21:28 -0700
Message-ID: <1473362488-3733-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 0aba34a..7335d8a 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -868,7 +868,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	r = dm_get_device(ti, argv[2], FMODE_READ, &v->hash_dev);
 	if (r) {
-		ti->error = "Data device lookup failed";
+		ti->error = "Hash device lookup failed";
 		goto bad;
 	}
 
-- 
2.8.0.rc3.226.g39d4020
