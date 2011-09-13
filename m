From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH] cleanup: fix the comment for field
 num_discard_requests of struct dm_target
Date: Tue, 13 Sep 2011 18:29:37 +0800
Message-ID: <4E6F3091.1060701__18291.4188168526$1315924847$gmane$org@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, NeilBrown <neilb@suse.de>, Jonathan Brassow <jbrassow@redhat.com>, Jens Axboe <jaxboe@fusionio.com>
List-Id: dm-devel.ids

The patch is against 3.1-rc6

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 include/linux/device-mapper.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 3fa1f3d..a54aba2 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -182,7 +182,8 @@ struct dm_target {
 
 	/*
 	 * The number of discard requests that will be submitted to the
-	 * target.  map_info->request_nr is used just like num_flush_requests.
+	 * target. map_info->target_request_nr is used just like
+	 * num_flush_requests.
 	 */
 	unsigned num_discard_requests;
 
-- 
1.7.1
