From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 08/12] dm error: return error for discards too
Date: Sat, 24 Jul 2010 12:09:24 -0400
Message-ID: <1279987768-13275-9-git-send-email-snitzer@redhat.com>
References: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
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

Have the error target respond to a discard request with a hard -EIO
rather than fail the request with -EOPNOTSUPP.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-target.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 11dea11..98c31b0 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -113,6 +113,9 @@ void dm_unregister_target(struct target_type *tt)
  */
 static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
 {
+	/* return error for discards (rather than -EOPNOTSUPP) */
+	tt->num_discard_requests = 1;
+
 	return 0;
 }
 
-- 
1.6.6.1
