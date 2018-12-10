From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 07/24] libmultipath: decrease log level of
	"disassembled" messages
Date: Mon, 10 Dec 2018 10:49:42 +0100
Message-ID: <20181210094959.11338-8-mwilck@suse.com>
References: <20181210094959.11338-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181210094959.11338-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

These messages are printed from update_multipath_strings, and
thus from check_path(), which is too much for -v3.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dmparser.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 620f507d..ac13ec06 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -117,7 +117,7 @@ assemble_map (struct multipath * mp, char * params, int len)
 	}
 
 	FREE(f);
-	condlog(3, "%s: assembled map [%s]", mp->alias, params);
+	condlog(4, "%s: assembled map [%s]", mp->alias, params);
 	return 0;
 
 err:
@@ -145,7 +145,7 @@ int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
 
 	p = params;
 
-	condlog(3, "%s: disassemble map [%s]", mpp->alias, params);
+	condlog(4, "%s: disassemble map [%s]", mpp->alias, params);
 
 	/*
 	 * features
@@ -410,7 +410,7 @@ int disassemble_status(char *params, struct multipath *mpp)
 
 	p = params;
 
-	condlog(3, "%s: disassemble status [%s]", mpp->alias, params);
+	condlog(4, "%s: disassemble status [%s]", mpp->alias, params);
 
 	/*
 	 * features
-- 
2.19.2
