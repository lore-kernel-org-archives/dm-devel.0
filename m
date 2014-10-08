From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [PATCH 2/5] block: extend rq_flag_bits
Date: Wed,  8 Oct 2014 17:55:33 +0200
Message-ID: <1412783736-18115-3-git-send-email-m@bjorling.me>
References: <1412783736-18115-1-git-send-email-m@bjorling.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412783736-18115-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
To: thornber@redhat.com, snitzer@redhat.com, hch@infradead.org, hayakawa@valinux.co.jp, axboe@fb.com, andy@rudoff.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, bvanassche@acm.org, linux-nvme@lists.infradead.org
Cc: jmad@itu.dk, =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
List-Id: dm-devel.ids

=46rom: Jesper Madsen <jmad@itu.dk>

The rq_flag_bits is extended by REQ_NVM and REQ_NVM_MAPPED

REQ_NVM is used to detect request have through LightNVM on submission, =
and can
be detected on completion.

REQ_NVM_MAPPED is used to detect if request have mapped appropriately t=
hrough
LightNVM.

The latter is added temponarily to debug the LightNVM key-value target =
and will
be removed later.

Signed-off-by: Matias Bj=C3=B8rling <m@bjorling.me>
---
 include/linux/blk_types.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 66c2167..b1d2f4d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -191,6 +191,8 @@ enum rq_flag_bits {
 	__REQ_END,		/* last of chain of requests */
 	__REQ_HASHED,		/* on IO scheduler merge hash */
 	__REQ_MQ_INFLIGHT,	/* track inflight for MQ */
+	__REQ_NVM,		/* request is queued via lightnvm */
+	__REQ_NVM_MAPPED,	/* lightnvm mapped this request */
 	__REQ_NR_BITS,		/* stops here */
 };
=20
@@ -245,5 +247,7 @@ enum rq_flag_bits {
 #define REQ_END			(1ULL << __REQ_END)
 #define REQ_HASHED		(1ULL << __REQ_HASHED)
 #define REQ_MQ_INFLIGHT		(1ULL << __REQ_MQ_INFLIGHT)
+#define REQ_NVM			(1ULL << __REQ_NVM)
+#define REQ_NVM_MAPPED		(1ULL << __REQ_NVM_MAPPED)
=20
 #endif /* __LINUX_BLK_TYPES_H */
--=20
1.9.1
