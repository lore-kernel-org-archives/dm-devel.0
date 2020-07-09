From: mwilck@suse.com
Subject: [PATCH 43/54] libmultipath: adopt_paths(): use
	find_path_by_devt()
Date: Thu,  9 Jul 2020 12:36:12 +0200
Message-ID: <20200709103623.8302-2-mwilck@suse.com>
References: <20200709103623.8302-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103623.8302-1-mwilck@suse.com>
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

pp->dev_t is the primary identifying property for both dm and udev.
Use it here, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index c7dffb7..55fca9b 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -75,7 +75,7 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
 			if (!mpp->paths && !(mpp->paths = vector_alloc()))
 				return 1;
 
-			if (!find_path_by_dev(mpp->paths, pp->dev) &&
+			if (!find_path_by_devt(mpp->paths, pp->dev_t) &&
 			    store_path(mpp->paths, pp))
 					return 1;
 			conf = get_multipath_config();
-- 
2.26.2
