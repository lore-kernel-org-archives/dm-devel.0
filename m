From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 28/72] libmultipath: checkers: mark unused
 arguments in methods
Date: Sat, 12 Oct 2019 21:28:12 +0000
Message-ID: <20191012212703.12989-29-martin.wilck@suse.com>
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
 libmultipath/checkers/cciss_tur.c   | 4 ++--
 libmultipath/checkers/hp_sw.c       | 4 ++--
 libmultipath/checkers/rdac.c        | 2 +-
 libmultipath/checkers/readsector0.c | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/libmultipath/checkers/cciss_tur.c b/libmultipath/checkers/cciss_tur.c
index ea843742..eaf67b35 100644
--- a/libmultipath/checkers/cciss_tur.c
+++ b/libmultipath/checkers/cciss_tur.c
@@ -46,12 +46,12 @@ struct cciss_tur_checker_context {
 	void * dummy;
 };
 
-int libcheck_init (struct checker * c)
+int libcheck_init (__attribute__((unused)) struct checker * c)
 {
 	return 0;
 }
 
-void libcheck_free (struct checker * c)
+void libcheck_free (__attribute__((unused)) struct checker * c)
 {
 	return;
 }
diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
index eabfa93c..915918c0 100644
--- a/libmultipath/checkers/hp_sw.c
+++ b/libmultipath/checkers/hp_sw.c
@@ -32,12 +32,12 @@ struct sw_checker_context {
 	void * dummy;
 };
 
-int libcheck_init (struct checker * c)
+int libcheck_init (__attribute__((unused)) struct checker * c)
 {
 	return 0;
 }
 
-void libcheck_free (struct checker * c)
+void libcheck_free (__attribute__((unused)) struct checker * c)
 {
 	return;
 }
diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
index 8a3b73ec..d924a9f7 100644
--- a/libmultipath/checkers/rdac.c
+++ b/libmultipath/checkers/rdac.c
@@ -133,7 +133,7 @@ out:
 	return 0;
 }
 
-void libcheck_free (struct checker * c)
+void libcheck_free(__attribute__((unused)) struct checker *c)
 {
 	return;
 }
diff --git a/libmultipath/checkers/readsector0.c b/libmultipath/checkers/readsector0.c
index cf79e067..b041f110 100644
--- a/libmultipath/checkers/readsector0.c
+++ b/libmultipath/checkers/readsector0.c
@@ -10,12 +10,12 @@ struct readsector0_checker_context {
 	void * dummy;
 };
 
-int libcheck_init (struct checker * c)
+int libcheck_init (__attribute__((unused)) struct checker * c)
 {
 	return 0;
 }
 
-void libcheck_free (struct checker * c)
+void libcheck_free (__attribute__((unused)) struct checker * c)
 {
 	return;
 }
-- 
2.23.0
