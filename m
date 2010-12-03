From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 1/4] dm log userspace: trap all errors from
	failed log construction
Date: Fri,  3 Dec 2010 18:12:47 -0500
Message-ID: <1291417970-5626-2-git-send-email-snitzer@redhat.com>
References: <1291417970-5626-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1291417970-5626-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Jonathan Brassow <jbrassow@redhat.com>

When constructing a mirror log, it is possible for the initial request
to fail for other reasons besides -ESRCH.  These must be handled too.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-log-userspace-base.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 1ed0094..ae7aa4b 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -181,8 +181,11 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 	r = dm_consult_userspace(lc->uuid, lc->luid, DM_ULOG_CTR,
 				 ctr_str, str_size, NULL, NULL);
 
-	if (r == -ESRCH) {
-		DMERR("Userspace log server not found");
+	if (r < 0) {
+		if (r == -ESRCH)
+			DMERR("Userspace log server not found");
+		else
+			DMERR("Userspace log server failed to create log");
 		goto out;
 	}
 
-- 
1.7.2.3
