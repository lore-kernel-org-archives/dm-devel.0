From: Tejun Heo <tj@kernel.org>
Subject: [PATCH RESEND 1/2 block#for-linus] bio, fs: update READA and SWRITE
 to match the corresponding BIO_RW_* bits
Date: Mon, 02 Aug 2010 16:17:59 +0200
Message-ID: <4C56D397.8010305@kernel.org>
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net>	<4C52A98A.7060507@kernel.org> <20100802104227.79340b49@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100802104227.79340b49@notabene>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, stable@kernel.org
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

Commit a82afdf (block: use the same failfast bits for bio and request)
moved BIO_RW_* bits around such that they match up with REQ_* bits.
Unfortunately, fs.h hard coded READ, WRITE, READA and SWRITE as 0, 1,
2 and 3, and expected them to match with BIO_RW_* bits.  READ/WRITE
didn't change but BIO_RW_AHEAD was moved to bit 4 instead of bit 1,
breaking READA and SWRITE.

This patch updates READA and SWRITE such that they match the BIO_RW_*
bits again.  A follow up patch will update the definitions to directly
use BIO_RW_* bits so that this kind of breakage won't happen again.

Stable: The offending commit a82afdf was released with v2.6.32, so
this patch should be applied to all kernels since then but it must
_NOT_ be applied to kernels earlier than that.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-bisected-by: Vladislav Bolkhovitin <vst@vlnb.net>
Root-caused-by: Neil Brown <neilb@suse.de>
Cc: Jens Axobe <axboe@kernel.dk>
Cc: stable@kernel.org
---
Aieee... thanks for root causing it Neil.  That was a stupid bug.  I
knew that READ/WRITE were hardcoded but forgot about READA.  :-(
Moving BIO_RW_AHEAD back to bit 1 might be a better solution but I'm
afraid that would cause more confusions downstream.  This patch
updates READA and SWRITE to match BIO_RW_AHEAD and should also appear
in -stable releases.  The next patch will create bio_types.h and
define all constants in terms of BIO_RW_*.

Thanks.

(resending w/ Jens' new address)

 include/linux/fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: work/include/linux/fs.h
===================================================================
--- work.orig/include/linux/fs.h
+++ work/include/linux/fs.h
@@ -148,8 +148,8 @@ struct inodes_stat_t {
 #define RWA_MASK	2
 #define READ 0
 #define WRITE 1
-#define READA 2		/* read-ahead  - don't block if no resources */
-#define SWRITE 3	/* for ll_rw_block() - wait for buffer lock */
+#define READA 16	/* read-ahead  - don't block if no resources */
+#define SWRITE 17	/* for ll_rw_block() - wait for buffer lock */
 #define READ_SYNC	(READ | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG))
 #define READ_META	(READ | (1 << BIO_RW_META))
 #define WRITE_SYNC_PLUG	(WRITE | (1 << BIO_RW_SYNCIO) | (1 << BIO_RW_NOIDLE))
