From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 03/32] multipath: fix setting conf->version
Date: Wed,  1 Aug 2018 15:56:49 -0500
Message-ID: <1533157038-3924-4-git-send-email-bmarzins@redhat.com>
References: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1533157038-3924-1-git-send-email-bmarzins@redhat.com>
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

Commit d3b71498 stopped multipath from setting conf->version. Instead,
it was always being set to 0.0.0. Multipathd was still setting this
correctly.

Fixes: d3b71498 "multipath: fix rcu thread cancellation hang"
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f2befad..8136d15 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -245,13 +245,13 @@ void libmp_dm_init(void)
 	int verbosity;
 	unsigned int version[3];
 
+	if (dm_prereq(version))
+		exit(1);
 	conf = get_multipath_config();
 	verbosity = conf->verbosity;
-	memcpy(version, conf->version, sizeof(version));
+	memcpy(conf->version, version, sizeof(version));
 	put_multipath_config(conf);
 	dm_init(verbosity);
-	if (dm_prereq(version))
-		exit(1);
 	dm_udev_set_sync_support(libmp_dm_udev_sync);
 }
 
-- 
2.7.4
