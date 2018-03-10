From: Wang Sheng-Hui <shhuiw@foxmail.com>
Subject: [PATCH] dm-mpath: use DM_MAPIO_SUBMITTED instead of 0 in
	process_queued_bios
Date: Sat, 10 Mar 2018 10:18:55 +0800
Message-ID: <20180310021855.2707-1-shhuiw@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Use the macro DM_MAPIO_SUBMITTED instead of magic number 0
in dm-mpath.c/process_queued_bios.

Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 7d3e572072f5..fae0b3b810d3 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -721,7 +721,7 @@ static void process_queued_bios(struct work_struct *work)
 		case DM_MAPIO_REMAPPED:
 			generic_make_request(bio);
 			break;
-		case 0:
+		case DM_MAPIO_SUBMITTED:
 			break;
 		default:
 			WARN_ONCE(true, "__multipath_map_bio() returned %d\n", r);
-- 
2.11.0
