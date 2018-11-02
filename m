From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 17/21] libmultipath: pathinfo: don't blank
	wwid if checker fails
Date: Fri,  2 Nov 2018 13:21:21 +0100
Message-ID: <20181102122125.30906-18-mwilck@suse.com>
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

Blanking a WWID is a dangerous operation. E.g. configure() would
consider the path in question as invalid and orphan it if the
WWID is blank. Don't do this checker failures which may be transient
or indicate a badly configured or otherwise malfunctioning checker.
Moreover, we try to determine WWID even if path_offline returns
PATH_DOWN in the first place, so why should we not if the checker
has a problem?

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 5e59e273..a6159e4a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1944,9 +1944,6 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 		if (path_state == PATH_UP) {
 			pp->chkrstate = pp->state = get_state(pp, conf, 0,
 							      path_state);
-			if (pp->state == PATH_UNCHECKED ||
-			    pp->state == PATH_WILD)
-				goto blank;
 			if (pp->state == PATH_TIMEOUT)
 				pp->state = PATH_DOWN;
 			if (pp->state == PATH_UP && !pp->size) {
-- 
2.19.1
