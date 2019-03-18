From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 08/10] libmultipath: tidy up do_set_from_hwe()
	with statement expression
Date: Mon, 18 Mar 2019 12:24:43 +0100
Message-ID: <20190318112445.6636-9-mwilck@suse.com>
References: <20190318112445.6636-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190318112445.6636-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

propsel.c has a lot of "funky" macros making assumptions about
variable and label names in callers. This one is particularly
ugly. As a first tidy-up step, split out a statement expression
which can be called cleanly from code that doesn't have said
variables and labels.

Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 27474f05..caf55b68 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -45,22 +45,30 @@ do {									\
 	}								\
 } while(0)
 
-#define do_set_from_vec(type, var, src, dest, msg)			\
-do {									\
+#define __do_set_from_vec(type, var, src, dest)				\
+({									\
 	type *_p;							\
+	bool _found = false;						\
 	int i;								\
 									\
 	vector_foreach_slot(src, _p, i) {				\
 		if (_p->var) {						\
 			dest = _p->var;					\
-			origin = msg;					\
-			goto out;					\
+			_found = true;					\
+			break;						\
 		}							\
 	}								\
-} while (0)
+	_found;								\
+})
+
+#define __do_set_from_hwe(var, src, dest) \
+	__do_set_from_vec(struct hwentry, var, (src)->hwe, dest)
 
-#define do_set_from_hwe(var, src, dest, msg) \
-	do_set_from_vec(struct hwentry, var, src->hwe, dest, msg)
+#define do_set_from_hwe(var, src, dest, msg)				\
+	if (__do_set_from_hwe(var, src, dest)) {			\
+		origin = msg;						\
+		goto out;						\
+	}
 
 static const char default_origin[] = "(setting: multipath internal)";
 static const char hwe_origin[] =
-- 
2.21.0
