From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmultipath: fix error parsing "find_multipaths
	strict"
Date: Tue, 15 May 2018 14:32:44 +0200
Message-ID: <20180515123244.6017-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

If "find_multipaths strict" is set in multipath.conf, the error message
"illegal value for find_multipaths: strict" is printed. This causes no
functional problem, as "strict" happens to be the default, fallback
value. It should be fixed nonetheless. FIND_MULTIPATHS_STRICT, having
the highest numeric value, must be last in the enum.

Fixes: c36f2f42 "libmultipath: change find_multipaths option to multi-value"
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index eb6a1788..e424b150 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -122,9 +122,9 @@ enum find_multipaths_states {
 	FIND_MULTIPATHS_UNDEF = YNU_UNDEF,
 	FIND_MULTIPATHS_OFF = YNU_NO,
 	FIND_MULTIPATHS_ON = _FIND_MULTIPATHS_F,
-	FIND_MULTIPATHS_STRICT = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_N,
 	FIND_MULTIPATHS_GREEDY = _FIND_MULTIPATHS_I,
 	FIND_MULTIPATHS_SMART = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_I,
+	FIND_MULTIPATHS_STRICT = _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_N,
 	__FIND_MULTIPATHS_LAST,
 };
 
-- 
2.16.3
