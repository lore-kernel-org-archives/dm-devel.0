From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 09/12] dm delay: enable discard support
Date: Sat, 24 Jul 2010 12:09:25 -0400
Message-ID: <1279987768-13275-10-git-send-email-snitzer@redhat.com>
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

Enable discard support for the delay target.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-delay.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 8520528..cdb7757 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -198,6 +198,7 @@ out:
 	atomic_set(&dc->may_delay, 1);
 
 	ti->num_flush_requests = 1;
+	ti->num_discard_requests = 1;
 	ti->private = dc;
 	return 0;
 
-- 
1.6.6.1
