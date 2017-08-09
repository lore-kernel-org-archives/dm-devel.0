From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 5/7] dm-mpath: Complain about unsupported
	__multipath_map_bio() return values
Date: Wed, 9 Aug 2017 11:32:14 -0700
Message-ID: <20170809183216.526-6-bart.vanassche@wdc.com>
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

The only behavior change introduced by this patch is that WARN_ON_ONCE()
is called if __multipath_map_bio() would return an unsupported return
value.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Laurence Oberman <loberman@redhat.com>
---
 drivers/md/dm-mpath.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6e20deac4add..f2ffa20c69b9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -632,6 +632,11 @@ static void process_queued_bios(struct work_struct *work)
 		case DM_MAPIO_REMAPPED:
 			generic_make_request(bio);
 			break;
+		case 0:
+			break;
+		default:
+			WARN_ONCE(true, "__multipath_map_bio() returned %d\n",
+				  r);
 		}
 	}
 	blk_finish_plug(&plug);
-- 
2.13.3
