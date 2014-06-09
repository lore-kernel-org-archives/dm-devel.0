From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] kpartx: fix extended partition size for >512b
	sectors
Date: Mon,  9 Jun 2014 11:24:58 -0400
Message-ID: <1402327498-19669-1-git-send-email-psusi@ubuntu.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Extended partitions only get 2 sectors for 512 byte sector size,
to allow LILO the 1024 bytes of room it needs.  Larger sector size
disks already have room and so only use 1 sector.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 kpartx/dos.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kpartx/dos.c b/kpartx/dos.c
index 0e57f0e..90ad3bd 100644
--- a/kpartx/dos.c
+++ b/kpartx/dos.c
@@ -101,8 +101,12 @@ read_dos_pt(int fd, struct slice all, struct slice *sp, int ns) {
 			break;
 		}
 		if (is_extended(p.sys_type)) {
-			sp[i].size = sector_size_mul * 2; /* extended partitions only get two
-					   sectors mapped for LILO to install */
+			/* extended partitions only get one or
+			   two sectors mapped for LILO to install,
+			   whichever is needed to have 1kb of space */
+			if (sector_size_mul == 1)
+				sp[i].size = 2;
+			else sp[i].size = sector_size_mul;
 			n += read_extended_partition(fd, &p, i, sp+n, ns-n);
 		}
 	}
-- 
1.9.1
