From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2 2/8] kpartx: fix -Wsign-compare error
Date: Tue, 11 Aug 2020 16:58:37 -0500
Message-ID: <1597183123-15797-3-git-send-email-bmarzins@redhat.com>
References: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1597183123-15797-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index c24ad6d9..653ce0c8 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -738,7 +738,7 @@ struct block {
 /* blknr is always in 512 byte blocks */
 char *
 getblock (int fd, unsigned int blknr) {
-	unsigned int secsz = get_sector_size(fd);
+	int secsz = get_sector_size(fd);
 	unsigned int blks_per_sec = secsz / 512;
 	unsigned int secnr = blknr / blks_per_sec;
 	unsigned int blk_off = (blknr % blks_per_sec) * 512;
-- 
2.17.2
