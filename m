From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 7/7] kpartx: fix dos partition rollover error
Date: Tue, 31 May 2016 18:16:50 -0500
Message-ID: <1464736610-20027-8-git-send-email-bmarzins@redhat.com>
References: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464736610-20027-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

dos partitions are limited to 2^32 sectors. However these do not have to
be 512 byte sectors, which is what device-mapper tables use.  kpartx
stores the dos sectors in a 32 uint.  This means that on a 4k sector size
device with large enough partitions, when kpartx multiplies the
dos sector count by the sector size multiplier, it can rollover before
it gets stored in 64 bit slice sector count. This patch just changes the
multiplier to a 64 bit uint to match the slice sector count, and avoid
the rollover.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/dos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/dos.c b/kpartx/dos.c
index 90ad3bd..f252d0a 100644
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -79,7 +79,7 @@ read_dos_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	unsigned long offset = all.start;
 	int i, n=4;
 	unsigned char *bp;
-	int sector_size_mul = get_sector_size(fd)/512;
+	uint64_t  sector_size_mul = get_sector_size(fd)/512;
 
 	bp = (unsigned char *)getblock(fd, offset);
 	if (bp == NULL)
-- 
1.8.3.1
