From: mwilck@suse.com
Subject: [PATCH 68/74] libmultipath: disassemble_map(): require
	non-NULL pathvec
Date: Thu,  9 Jul 2020 12:51:39 +0200
Message-ID: <20200709105145.9211-16-mwilck@suse.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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

We would fail in store_path() at the latest if pathvec was NULL.
And all callers set pathvec anyway.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 7fcd76e..e6f2cbe 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -6,6 +6,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <assert.h>
 
 #include "checkers.h"
 #include "vector.h"
@@ -137,6 +138,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 	struct path * pp;
 	struct pathgroup * pgp;
 
+	assert(pathvec != NULL);
 	p = params;
 
 	condlog(4, "%s: disassemble map [%s]", mpp->alias, params);
@@ -295,8 +297,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 				devname[0] = '\0';
 			}
 
-			if (pathvec)
-				pp = find_path_by_devt(pathvec, word);
+			pp = find_path_by_devt(pathvec, word);
 
 			if (!pp) {
 				pp = alloc_path();
-- 
2.26.2
