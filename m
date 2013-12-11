From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 13/16] kpartx: fix strict aliasing warning
Date: Wed, 11 Dec 2013 00:43:07 -0600
Message-ID: <1386744190-1295-14-git-send-email-bmarzins@redhat.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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

Compiling with strict aliasing throws warnings about aliasing
volume_label_t to an array of unsigned ints. Adding __may_alias__
lets it know that we meant to do this.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/dasd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index dcdf678..1fcf778 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -46,6 +46,8 @@ unsigned long long sectors512(unsigned long long sectors, int blocksize)
 	return sectors * (blocksize >> 9);
 }
 
+typedef unsigned int __attribute__((__may_alias__)) label_ints_t;
+
 /*
  */
 int 
@@ -169,7 +171,7 @@ read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
 		/*
 		 * VM style CMS1 labeled disk
 		 */
-		unsigned int *label = (unsigned int *) &vlabel;
+		label_ints_t *label = (label_ints_t *) &vlabel;
 
 		blocksize = label[4];
 		if (label[14] != 0) {
-- 
1.8.4.2
