From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 1/5] libmultipath: add comment about resuming
Date: Thu,  1 Jun 2017 22:09:08 -0500
Message-ID: <1496372952-27110-2-git-send-email-bmarzins@redhat.com>
References: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1496372952-27110-1-git-send-email-bmarzins@redhat.com>
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

The reason for the second resume in my commit "libmultipath: fix
suspended devs from failed reloads" is not obvious from the multipath
code, so add a comment.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 69b634b..ee83e0f 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -399,6 +399,9 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
 	if (r)
 		return r;
 
+	/* If the resume failed, dm will leave the device suspended, and
+ 	 * drop the new table, so doing a second resume will try using
+ 	 * the original table */
 	if (dm_is_suspended(mpp->alias))
 		dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush, 1,
 			     udev_flags, 0);
-- 
2.7.4
