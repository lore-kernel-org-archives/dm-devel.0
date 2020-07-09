From: mwilck@suse.com
Subject: [PATCH 25/35] libmultipath: pathinfo(): don't filter
	emtpy devnode names
Date: Thu,  9 Jul 2020 12:16:10 +0200
Message-ID: <20200709101620.6786-26-mwilck@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709101620.6786-1-mwilck@suse.com>
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

In the update_multipath_strings() code path (disassemble_map()),
we set an empty devname if we find devices in maps that are not
in pathvec and not in sysfs. We shouldn't filter these devices
by devnode, because failure in pathinfo() causes e.g. adopt_paths()
to bail out, and this may cause a map removal even if the map
contains other, perfectly valid paths.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 2e559d8..10b5a28 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2069,7 +2069,7 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			return PATHINFO_SKIPPED;
 	}
 
-	if (filter_devnode(conf->blist_devnode,
+	if (strlen(pp->dev) != 0 && filter_devnode(conf->blist_devnode,
 			   conf->elist_devnode,
 			   pp->dev) > 0)
 		return PATHINFO_SKIPPED;
-- 
2.26.2
