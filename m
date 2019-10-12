From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 32/72] kpartx: mark unused arguments in ptreader
	methods
Date: Sat, 12 Oct 2019 21:28:17 +0000
Message-ID: <20191012212703.12989-33-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/dasd.c | 3 ++-
 kpartx/gpt.c  | 3 ++-
 kpartx/mac.c  | 3 ++-
 kpartx/ps3.c  | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index 4e7e4743..4f3f744e 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -65,7 +65,8 @@ typedef unsigned int __attribute__((__may_alias__)) label_ints_t;
 /*
  */
 int
-read_dasd_pt(int fd, struct slice all, struct slice *sp, int ns)
+read_dasd_pt(int fd, __attribute__((unused)) struct slice all,
+	     struct slice *sp, __attribute__((unused)) int ns)
 {
 	int retval = -1;
 	int blocksize;
diff --git a/kpartx/gpt.c b/kpartx/gpt.c
index f3216ba2..4f88d486 100644
--- a/kpartx/gpt.c
+++ b/kpartx/gpt.c
@@ -601,7 +601,8 @@ fail:
  *
  */
 int
-read_gpt_pt (int fd, struct slice all, struct slice *sp, int ns)
+read_gpt_pt (int fd, __attribute__((unused)) struct slice all,
+	     struct slice *sp, int ns)
 {
 	gpt_header *gpt = NULL;
 	gpt_entry *ptes = NULL;
diff --git a/kpartx/mac.c b/kpartx/mac.c
index 6e82c95e..6aeac4e9 100644
--- a/kpartx/mac.c
+++ b/kpartx/mac.c
@@ -5,7 +5,8 @@
 #include "mac.h"
 
 int
-read_mac_pt(int fd, struct slice all, struct slice *sp, int ns) {
+read_mac_pt(int fd, __attribute__((unused)) struct slice all,
+	    struct slice *sp, int ns) {
 	struct mac_driver_desc *md;
 	struct mac_partition *part;
 	unsigned secsize;
diff --git a/kpartx/ps3.c b/kpartx/ps3.c
index 84550978..2cf4ffa2 100644
--- a/kpartx/ps3.c
+++ b/kpartx/ps3.c
@@ -48,7 +48,8 @@ read_disklabel(int fd, struct disklabel *label) {
 }
 
 int
-read_ps3_pt(int fd, struct slice all, struct slice *sp, int ns) {
+read_ps3_pt(int fd, __attribute__((unused)) struct slice all,
+	    struct slice *sp, __attribute__((unused)) int ns) {
 	struct disklabel label;
 	int n = 0;
 	int i;
-- 
2.23.0
