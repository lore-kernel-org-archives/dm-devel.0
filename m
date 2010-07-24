From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 02/12] dm: introduce num_discard_requests in
	dm_target structure
Date: Sat, 24 Jul 2010 12:09:18 -0400
Message-ID: <1279987768-13275-3-git-send-email-snitzer@redhat.com>
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

A target with num_discard_requests > 0 supports discard requests.
The configured number of discard requests will be submitted to the
target.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-linear.c        |    1 +
 include/linux/device-mapper.h |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 7071f17..8e925fa 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -53,6 +53,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	ti->num_flush_requests = 1;
+	ti->num_discard_requests = 1;
 	ti->private = lc;
 	return 0;
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 87beab7..0fe597d 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -181,6 +181,12 @@ struct dm_target {
 	 */
 	unsigned num_flush_requests;
 
+	/*
+	 * The number of discard requests that will be submitted to the
+	 * target.  map_info->request_nr is used just like num_flush_requests.
+	 */
+	unsigned num_discard_requests;
+
 	/* target specific data */
 	void *private;
 
-- 
1.6.6.1
