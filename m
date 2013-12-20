From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 05/20] dm space map metadata: limit
	errors in sm_metadata_new_block
Date: Fri, 20 Dec 2013 18:37:18 -0500
Message-ID: <1387582653-13647-6-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

The "unable to allocate new metadata block" error can be a particularly
verbose error if there is a systemic issue with the metadata device.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-space-map-metadata.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 58fc1ee..e930844 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -385,13 +385,13 @@ static int sm_metadata_new_block(struct dm_space_map *sm, dm_block_t *b)
 
 	int r = sm_metadata_new_block_(sm, b);
 	if (r) {
-		DMERR("unable to allocate new metadata block");
+		DMERR_LIMIT("unable to allocate new metadata block");
 		return r;
 	}
 
 	r = sm_metadata_get_nr_free(sm, &count);
 	if (r) {
-		DMERR("couldn't get free block count");
+		DMERR_LIMIT("couldn't get free block count");
 		return r;
 	}
 
-- 
1.8.1.4
