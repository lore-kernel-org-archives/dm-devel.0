From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v3 19/26] raid1: use bio_copy_data()
Date: Mon, 24 Sep 2012 15:34:59 -0700
Message-ID: <1348526106-17074-20-git-send-email-koverstreet@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1348526106-17074-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: tj@kernel.org, axboe@kernel.dk, Kent Overstreet <koverstreet@google.com>, vgoyal@redhat.com
List-Id: dm-devel.ids

This doesn't really delete any code _yet_, but once immutable bvecs are
done we can just delete the rest of the code in that loop.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index af39f74..1c40d90 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1895,10 +1895,9 @@ static int process_checks(struct r1bio *r1_bio)
 			else
 				bi->bv_len = size;
 			size -= PAGE_SIZE;
-			memcpy(page_address(bi->bv_page),
-			       page_address(pbio->bi_io_vec[j].bv_page),
-			       PAGE_SIZE);
 		}
+
+		bio_copy_data(sbio, pbio);
 	}
 	return 0;
 }
-- 
1.7.12
