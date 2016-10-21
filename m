From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 15/15] kpartx: Move the declaration of a global
 variable from .c to .h
Date: Fri, 21 Oct 2016 11:46:58 -0700
Message-ID: <2e877509-24cd-6682-5cf5-1ba9f1f065a7@sandisk.com>
References: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72bd7a6a-7fb9-5a2c-b22d-031d8feb01b0@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 kpartx/gpt.c    | 1 -
 kpartx/kpartx.h | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index 3511886..6ef20f9 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -504,7 +504,6 @@ compare_gpts(gpt_header *pgpt, gpt_header *agpt, uint64_t lastlba)
 static int
 find_valid_gpt(int fd, gpt_header ** gpt, gpt_entry ** ptes)
 {
-	extern int force_gpt;
 	int good_pgpt = 0, good_agpt = 0, good_pmbr = 0;
 	gpt_header *pgpt = NULL, *agpt = NULL;
 	gpt_entry *pptes = NULL, *aptes = NULL;
diff --git a/kpartx/kpartx.h b/kpartx/kpartx.h
index a55c211..52920e4 100644
--- a/kpartx/kpartx.h
+++ b/kpartx/kpartx.h
@@ -39,6 +39,8 @@ struct slice {
 
 typedef int (ptreader)(int fd, struct slice all, struct slice *sp, int ns);
 
+extern int force_gpt;
+
 extern ptreader read_dos_pt;
 extern ptreader read_bsd_pt;
 extern ptreader read_solaris_pt;
-- 
2.10.1
