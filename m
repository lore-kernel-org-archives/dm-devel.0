From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 07/21] libmultipath/checkers: hp_sw: use
	message id
Date: Fri,  2 Nov 2018 13:21:11 +0100
Message-ID: <20181102122125.30906-8-mwilck@suse.com>
References: <20181102122125.30906-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122125.30906-1-mwilck@suse.com>
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

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/hp_sw.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
index 0ad34a6b..d7f1018c 100644
--- a/libmultipath/checkers/hp_sw.c
+++ b/libmultipath/checkers/hp_sw.c
@@ -27,10 +27,6 @@
 #define MX_ALLOC_LEN		255
 #define HEAVY_CHECK_COUNT       10
 
-#define MSG_HP_SW_UP	"hp_sw checker reports path is up"
-#define MSG_HP_SW_DOWN	"hp_sw checker reports path is down"
-#define MSG_HP_SW_GHOST	"hp_sw checker reports path is ghost"
-
 struct sw_checker_context {
 	void * dummy;
 };
@@ -128,14 +124,14 @@ int libcheck_check(struct checker * c)
 	char buff[MX_ALLOC_LEN];
 
 	if (0 != do_inq(c->fd, 0, 1, 0x80, buff, MX_ALLOC_LEN, 0, c->timeout)) {
-		MSG(c, MSG_HP_SW_DOWN);
+		c->msgid = CHECKER_MSGID_DOWN;
 		return PATH_DOWN;
-	}
+	};
 
 	if (do_tur(c->fd, c->timeout)) {
-		MSG(c, MSG_HP_SW_GHOST);
+		c->msgid = CHECKER_MSGID_GHOST;
 		return PATH_GHOST;
 	}
-	MSG(c, MSG_HP_SW_UP);
+	c->msgid = CHECKER_MSGID_UP;
 	return PATH_UP;
 }
-- 
2.19.1
