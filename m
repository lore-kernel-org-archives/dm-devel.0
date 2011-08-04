From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm flakey: fix corrupt_bio_byte error path
Date: Thu,  4 Aug 2011 18:06:41 -0400
Message-ID: <1312495601-8261-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

If no arguments were provided to the corrupt_bio_byte feature an error
should be returned immediately.

Reported-by: Zdenek Kabelac <zkabelac@redhat.com> (coverity run)
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-flakey.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 89f73ca..f84c080 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -81,8 +81,10 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		 * corrupt_bio_byte <Nth_byte> <direction> <value> <bio_flags>
 		 */
 		if (!strcasecmp(arg_name, "corrupt_bio_byte")) {
-			if (!argc)
+			if (!argc) {
 				ti->error = "Feature corrupt_bio_byte requires parameters";
+				return -EINVAL;
+			}
 
 			r = dm_read_arg(_args + 1, as, &fc->corrupt_bio_byte, &ti->error);
 			if (r)
-- 
1.7.4.4
