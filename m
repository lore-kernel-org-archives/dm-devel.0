From: mwilck@suse.com
Subject: [PATCH 04/11] libdmmp tests: fix compilation
Date: Thu, 24 Sep 2020 15:36:37 +0200
Message-ID: <20200924133644.14034-5-mwilck@suse.com>
References: <20200924133644.14034-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133644.14034-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

These tests don't compile with -Werror=unused-parameter. Fix it.
---
 libdmmp/test/libdmmp_speed_test.c | 2 +-
 libdmmp/test/libdmmp_test.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libdmmp/test/libdmmp_speed_test.c b/libdmmp/test/libdmmp_speed_test.c
index 372cd39..d91ba50 100644
--- a/libdmmp/test/libdmmp_speed_test.c
+++ b/libdmmp/test/libdmmp_speed_test.c
@@ -27,7 +27,7 @@
 
 #include <libdmmp/libdmmp.h>
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	struct dmmp_context *ctx = NULL;
 	struct dmmp_mpath **dmmp_mps = NULL;
diff --git a/libdmmp/test/libdmmp_test.c b/libdmmp/test/libdmmp_test.c
index d944e1e..a940b57 100644
--- a/libdmmp/test/libdmmp_test.c
+++ b/libdmmp/test/libdmmp_test.c
@@ -102,7 +102,7 @@ out:
 	return rc;
 }
 
-int main(int argc, char *argv[])
+int main(void)
 {
 	struct dmmp_context *ctx = NULL;
 	struct dmmp_mpath **dmmp_mps = NULL;
-- 
2.28.0
