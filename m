From: mwilck@suse.com
Subject: [PATCH 3/4] libmultipath: warn about NULL value of
	mpp->hwe
Date: Mon, 13 Jul 2020 13:07:42 +0200
Message-ID: <20200713110743.26329-4-mwilck@suse.com>
References: <20200713110743.26329-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200713110743.26329-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, lixiaokeng@huawei.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

mpp->hwe is only accessed in propsel.c. It may become unset if
all paths of the mpp have been deleted. Access to mpp->hwe in this
case should be avoided.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/propsel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 897e48c..92b0595 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -65,7 +65,9 @@ do {									\
 	__do_set_from_vec(struct hwentry, var, (src)->hwe, dest)
 
 #define do_set_from_hwe(var, src, dest, msg)				\
-	if (__do_set_from_hwe(var, src, dest)) {			\
+	if (!src->hwe) {						\
+		condlog(0, "BUG: do_set_from_hwe called with hwe == NULL"); \
+	} else if (__do_set_from_hwe(var, src, dest)) {			\
 		origin = msg;						\
 		goto out;						\
 	}
-- 
2.26.2
