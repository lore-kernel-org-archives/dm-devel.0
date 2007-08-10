From: Jan Blunck <jblunck@suse.de>
Subject: [patch 07/11] dm-crypt: remove SECTOR_SHIFT define
Date: Fri, 10 Aug 2007 22:02:11 +0200
Message-ID: <29480.3514997058$1186776760@news.gmane.org>
References: <20070810200204.455820246@suse.de>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm/dm-crypt-remove-SECTOR_SHIFT.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Sector size on Linux is always 512 bytes. Don't even try to give the
impression this is changeable.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 drivers/md/dm-crypt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -350,12 +350,12 @@ static int crypt_convert(struct crypt_co
 		struct scatterlist sg_in = {
 			.page = bv_in->bv_page,
 			.offset = bv_in->bv_offset + ctx->offset_in,
-			.length = 1 << SECTOR_SHIFT
+			.length = 512
 		};
 		struct scatterlist sg_out = {
 			.page = bv_out->bv_page,
 			.offset = bv_out->bv_offset + ctx->offset_out,
-			.length = 1 << SECTOR_SHIFT
+			.length = 512
 		};
 
 		ctx->offset_in += sg_in.length;

-- 
