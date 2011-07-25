From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: strdup multipath alias,
	so that it isn't	deleted.
Date: Mon, 25 Jul 2011 13:27:00 -0500
Message-ID: <20110725182700.GK15149@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

When a multipath device is added to multipathd with ev_add_map(),
the alias is not duplicated, and is freed immediately after ev_add_map()
returns, causing a memory error. This patch corrects that.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 189f25b..364e36e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -373,7 +373,7 @@ add_map_without_path (struct vectors * vecs, char * alias)
 	if (!mpp || !alias)
 		return NULL;
 
-	mpp->alias = alias;
+	mpp->alias = STRDUP(alias);
 
 	if (setup_multipath(vecs, mpp)) {
 		mpp->alias = NULL;
-- 
1.7.4.4
