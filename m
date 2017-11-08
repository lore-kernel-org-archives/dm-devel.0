From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/6] mpathpersist: Fix invalid condition check
Date: Tue,  7 Nov 2017 18:15:11 -0600
Message-ID: <1510100116-6206-2-git-send-email-bmarzins@redhat.com>
References: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

In commit 1990257c (mpathpersist: add support for prkeys file), the
check to see if mpathpersist needed to tell multipathd to update a
device's prkey was wrong. It had a typo that made it evaluate to true
for any service action, instead of just for registrations. This is the
correct check.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index b5ed556..84ab293 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -339,8 +339,9 @@ int mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 
 	memcpy(&prkey, paramp->sa_key, 8);
 	if (mpp->prkey_source == PRKEY_SOURCE_FILE && prkey &&
-	    ((!get_be64(mpp->reservation_key) && MPATH_PROUT_REG_SA) ||
-	     MPATH_PROUT_REG_IGN_SA)) {
+	    ((!get_be64(mpp->reservation_key) &&
+	      rq_servact == MPATH_PROUT_REG_SA) ||
+	     rq_servact == MPATH_PROUT_REG_IGN_SA)) {
 		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
 		if (update_prkey(alias, get_be64(mpp->reservation_key))) {
 			condlog(0, "%s: failed to set prkey for multipathd.",
-- 
2.7.4
