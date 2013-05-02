From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 02/16] Make kpartx correctly handle non-512 byte
	GPT
Date: Thu,  2 May 2013 16:46:23 -0500
Message-ID: <1367531197-8987-3-git-send-email-bmarzins@redhat.com>
References: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1367531197-8987-1-git-send-email-bmarzins@redhat.com>
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

The gpt code in kpartx correctly handled non-512 byte gpt
partitions right up until it was time to actually write out the
slice data. At that point it forgot to convert the logical block
address into a the proper slice offset. This patch fixes that.

Signed-off-by: Philipp Schmidt <philipp@ppc.in-berlin.de>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/gpt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 3082cae..0a22927 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -637,6 +637,7 @@ read_gpt_pt (int fd, struct slice all, struct slice *sp, int ns)
 	uint32_t i;
 	int n = 0;
         int last_used_index=-1;
+	int sector_size_mul = get_sector_size(fd)/512;
 
 	if (!find_valid_gpt (fd, &gpt, &ptes) || !gpt || !ptes) {
 		if (gpt)
@@ -652,9 +653,11 @@ read_gpt_pt (int fd, struct slice all, struct slice *sp, int ns)
 			sp[n].size = 0;
 			n++;
 		} else {
-			sp[n].start = __le64_to_cpu(ptes[i].starting_lba);
-			sp[n].size  = __le64_to_cpu(ptes[i].ending_lba) -
-				__le64_to_cpu(ptes[i].starting_lba) + 1;
+			sp[n].start = sector_size_mul *
+				      __le64_to_cpu(ptes[i].starting_lba);
+			sp[n].size  = sector_size_mul *
+				      (__le64_to_cpu(ptes[i].ending_lba) -
+				       __le64_to_cpu(ptes[i].starting_lba) + 1);
                         last_used_index=n;
 			n++;
 		}
-- 
1.8.2
