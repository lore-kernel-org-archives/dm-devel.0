From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 17/22] libmultipath: pathinfo: don't blank
	wwid if checker fails
Date: Tue, 30 Oct 2018 22:06:48 +0100
Message-ID: <20181030210653.29677-18-mwilck@suse.com>
References: <20181030210653.29677-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030210653.29677-1-mwilck@suse.com>
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
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
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
index 3550c3a7..467ece7a 100644
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
