From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 6/7] dm-mpath: Retry BLK_STS_RESOURCE errors
Date: Wed, 9 Aug 2017 11:32:15 -0700
Message-ID: <20170809183216.526-7-bart.vanassche@wdc.com>
References: <20170809183216.526-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170809183216.526-1-bart.vanassche@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Retry requests instead of failing these if an out-of-memory error
occurs or the block driver below dm-mpath is busy. This restores
the v4.12 behavior of noretry_error(), namely that -ENOMEM results
in a retry.

Fixes: commit 2a842acab109 ("block: introduce new block status code type")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Laurence Oberman <loberman@redhat.com>
---
 drivers/md/dm-mpath.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f2ffa20c69b9..3c1f8a89b10f 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1463,7 +1463,6 @@ static int noretry_error(blk_status_t error)
 	case BLK_STS_TARGET:
 	case BLK_STS_NEXUS:
 	case BLK_STS_MEDIUM:
-	case BLK_STS_RESOURCE:
 		return 1;
 	}
 
-- 
2.13.3
