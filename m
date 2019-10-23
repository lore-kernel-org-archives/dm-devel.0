From: Maged Mokhtar <mmokhtar@petasan.org>
Subject: [PATCH] dm writecache: handle REQ_FUA
Date: Wed, 23 Oct 2019 22:41:17 +0200
Message-ID: <be77e96c-5d37-a9de-b0ed-ee15d0c59215@petasan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Call writecache_flush() on REQ_FUA.

Signed-off-by: Maged Mokhtar <mmokhtar@petasan.org>
---
  drivers/md/dm-writecache.c |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c	2019-10-23 22:01:18.480115962 +0200
+++ b/drivers/md/dm-writecache.c	2019-10-23 22:02:08.616113729 +0200
@@ -1218,7 +1218,8 @@ bio_copy:
  			}
  		} while (bio->bi_iter.bi_size);

-		if (unlikely(wc->uncommitted_blocks >= wc->autocommit_blocks))
+		if (unlikely(bio->bi_opf & REQ_FUA ||
+				wc->uncommitted_blocks >= wc->autocommit_blocks))
  			writecache_flush(wc);
  		else
  			writecache_schedule_autocommit(wc);
