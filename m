From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 17/18] Fix sun partition numbering
Date: Thu,  8 Oct 2015 14:44:50 -0500
Message-ID: <1444333491-16265-18-git-send-email-bmarzins@redhat.com>
References: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1444333491-16265-1-git-send-email-bmarzins@redhat.com>
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

On Sun labeled devices, the kpartx partition numbers weren't agreeing
with the underlying device partition numbers.  This is because kpartx
doesn't count slices with no sectors, when determining the numbering.
This patch counts these empty slices, so the numbering comes out the
same.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/sun.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kpartx/sun.c b/kpartx/sun.c
index 3d88b21..b8c023b 100644
--- a/kpartx/sun.c
+++ b/kpartx/sun.c
@@ -82,8 +82,6 @@ read_sun_pt(int fd, struct slice all, struct slice *sp, int ns) {
 	for(i=0, n=0; i<SUN_DISK_MAXPARTITIONS; i++) {
 		s = &l->partitions[i];
 
-		if (s->num_sectors == 0)
-			continue;
 		if (n < ns) {
 			sp[n].start = offset +
 				be32_to_cpu(s->start_cylinder) * be16_to_cpu(l->nsect) * be16_to_cpu(l->ntrks);
-- 
1.8.3.1
