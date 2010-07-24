From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 07/12] dm zero: silently drop discards too
Date: Sat, 24 Jul 2010 12:09:23 -0400
Message-ID: <1279987768-13275-8-git-send-email-snitzer@redhat.com>
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

Have the zero target silently drop a discard rather than fail the
request with -EOPNOTSUPP.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-zero.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index bbc9703..8bd76e0 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -22,6 +22,9 @@ static int zero_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
+	/* silently drop discards (this avoids -EOPNOTSUPP) */
+	ti->num_discard_requests = 1;
+
 	return 0;
 }
 
-- 
1.6.6.1
