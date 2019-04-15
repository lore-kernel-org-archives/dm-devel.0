From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/3] dm space map common: zero entire ll_disk
Date: Mon, 15 Apr 2019 17:17:15 -0400
Message-ID: <20190415211717.18737-2-snitzer@redhat.com>
References: <20190415211717.18737-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190415211717.18737-1-snitzer@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Otherwise, memory that is allocated (and potentially not previously
zeroed) will get written to disk as part of the space maps.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-space-map-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 0a3b8ae4a29c..b8a62188f6be 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -190,6 +190,8 @@ static int sm_find_free(void *addr, unsigned begin, unsigned end,
 
 static int sm_ll_init(struct ll_disk *ll, struct dm_transaction_manager *tm)
 {
+	memset(ll, 0, sizeof(struct ll_disk));
+
 	ll->tm = tm;
 
 	ll->bitmap_info.tm = tm;
-- 
2.18.0
