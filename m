From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 05/10] mpath: don't wait for udev if all paths
	are down
Date: Fri, 28 Oct 2016 21:55:21 -0500
Message-ID: <1477709726-5442-6-git-send-email-bmarzins@redhat.com>
References: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1477709726-5442-1-git-send-email-bmarzins@redhat.com>
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
List-Id: dm-devel.ids

Normally multipath waits for udev to create a device before adding
more paths, which could trigger a reload. But, if the first path
discovered is not usable, you should add the next path right away.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index dbcaa03..15c957a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -715,7 +715,10 @@ ev_add_path (struct path * pp, struct vectors * vecs)
 		goto fail; /* leave path added to pathvec */
 	}
 	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
-	if (mpp && mpp->wait_for_udev) {
+	if (mpp && mpp->wait_for_udev &&
+	    (pathcount(mpp, PATH_UP) > 0 ||
+	     (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs != TPGS_IMPLICIT))) {
+		/* if wait_for_udev is set and valid paths exist */
 		mpp->wait_for_udev = 2;
 		orphan_path(pp, "waiting for create to complete");
 		return 0;
-- 
1.8.3.1
