From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Allocate only once the EMC-clariion global
	checker's stage area instead of multiple times.
Date: Tue, 24 Mar 2009 11:25:01 -0400
Message-ID: <1237908301-2339-4-git-send-email-konrad@virtualiron.com>
References: <1237908301-2339-1-git-send-email-konrad@virtualiron.com>
	<1237908301-2339-2-git-send-email-konrad@virtualiron.com>
	<1237908301-2339-3-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237908301-2339-3-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

The multi-path global context on every path checker init would be
set. In scenarios where you have four paths per multipath, that context
would be set four times instead of once causing a small memory leak
(4 bytes per block disk).
---
 libmultipath/checkers/emc_clariion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 200daee..08c9c26 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -76,7 +76,7 @@ int libcheck_init (struct checker * c)
 	/*
 	 * Allocate and initialize the multi-path global context.
 	 */
-	if (c->mpcontext) {
+	if (c->mpcontext && *c->mpcontext == NULL) {
 		void * mpctxt = MALLOC(sizeof(int));
 		*c->mpcontext = mpctxt;
 		CLR_INACTIVE_SNAP(c);
-- 
1.5.4.1
