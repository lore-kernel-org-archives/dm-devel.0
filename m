From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] block: remove the WRITE_BARRIER flag
Date: Mon, 30 Aug 2010 11:58:16 +0200
Message-ID: <1283162296-13650-6-git-send-email-tj__5835.5801077143$1283196584$gmane$org@kernel.org>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-Message-ID: <20100830192430.GF9195@redhat.com>
Resent-To: dm-devel@redhat.com
In-Reply-To: <1283162296-13650-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: dm-devel.ids

From: Christoph Hellwig <hch@infradead.org>

It's unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/fs.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 32703a9..6b0f6e9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -135,7 +135,6 @@ struct inodes_stat_t {
  *			immediately after submission. The write equivalent
  *			of READ_SYNC.
  * WRITE_ODIRECT_PLUG	Special case write for O_DIRECT only.
- * WRITE_BARRIER	DEPRECATED. Always fails. Use FLUSH/FUA instead.
  * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
  * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
  *			non-volatile media on completion.
@@ -157,8 +156,6 @@ struct inodes_stat_t {
 #define WRITE_SYNC		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG)
 #define WRITE_ODIRECT_PLUG	(WRITE | REQ_SYNC)
 #define WRITE_META		(WRITE | REQ_META)
-#define WRITE_BARRIER		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
-				 REQ_HARDBARRIER)
 #define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
 				 REQ_FLUSH)
 #define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
-- 
1.7.1
