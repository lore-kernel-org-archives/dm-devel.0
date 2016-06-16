From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/39] kpartx/devmapper.c: Remove unused 'next'
	argument
Date: Thu, 16 Jun 2016 11:47:35 +0200
Message-ID: <1466070465-1021-30-git-send-email-hare@suse.de>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466070465-1021-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Found by coverity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 kpartx/devmapper.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index c5ba39d..382f511 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -311,7 +311,6 @@ dm_get_map(int major, int minor, char * outparams)
 {
 	int r = 1;
 	struct dm_task *dmt;
-	void *next = NULL;
 	uint64_t start, length;
 	char *target_type = NULL;
 	char *params = NULL;
@@ -327,8 +326,8 @@ dm_get_map(int major, int minor, char * outparams)
 		goto out;
 
 	/* Fetch 1st target */
-	next = dm_get_next_target(dmt, next, &start, &length,
-				  &target_type, &params);
+	dm_get_next_target(dmt, NULL, &start, &length,
+			   &target_type, &params);
 
 	if (snprintf(outparams, PARAMS_SIZE, "%s", params) <= PARAMS_SIZE)
 		r = 0;
-- 
2.6.6
