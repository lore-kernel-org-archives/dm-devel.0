From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 4/7] dm-mpath: Avoid that building with W=1
	causes gcc 7 to complain about fall-through
Date: Wed, 9 Aug 2017 11:32:13 -0700
Message-ID: <20170809183216.526-5-bart.vanassche@wdc.com>
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

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Laurence Oberman <loberman@redhat.com>
---
 drivers/md/dm-mpath.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0baa461eccaa..6e20deac4add 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1379,6 +1379,7 @@ static void pg_init_done(void *data, int errors)
 	case SCSI_DH_RETRY:
 		/* Wait before retrying. */
 		delay_retry = 1;
+		/* fall through */
 	case SCSI_DH_IMM_RETRY:
 	case SCSI_DH_RES_TEMP_UNAVAIL:
 		if (pg_init_limit_reached(m, pgpath))
-- 
2.13.3
