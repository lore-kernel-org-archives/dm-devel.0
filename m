From: mwilck@suse.com
Subject: [PATCH v2 46/54] libmultipath: path_discover(): explain
	pathinfo flags
Date: Wed, 12 Aug 2020 13:34:29 +0200
Message-ID: <20200812113429.26314-3-mwilck@suse.com>
References: <20200812113429.26314-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113429.26314-1-mwilck@suse.com>
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

Add a comment explaining why we use different flags for "new" and
existing paths.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 5f4ebf0..64d3473 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -137,6 +137,11 @@ path_discover (vector pathvec, struct config * conf,
 				      udevice, flag | DI_BLACKLIST,
 				      NULL);
 	else
+		/*
+		 * Don't use DI_BLACKLIST on paths already in pathvec. We rely
+		 * on the caller to pre-populate the pathvec with valid paths
+		 * only.
+		 */
 		return pathinfo(pp, conf, flag);
 }
 
-- 
2.28.0
