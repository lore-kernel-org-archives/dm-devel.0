From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/3] libmutipath: don't close fd on dm_lib_release
Date: Tue, 24 Mar 2020 16:03:53 -0500
Message-ID: <1585083834-14237-2-git-send-email-bmarzins@redhat.com>
References: <1585083834-14237-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585083834-14237-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

If dm_hold_control_open() isn't set, when dm_lib_release() is called, it
will close the control fd. The control fd will get re-opened on the next
dm_task_run() call, but if there is a dm_task_run() call already
in progress in another thread, it can fail. Since many of the
device-mapper callouts happen with the vecs lock held, this wasn't too
noticeable, but there is code that calls dm_task_run() without the
vecs lock held, notably the dmevent waiter code.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index bed8ddc6..d96472fe 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -254,6 +254,7 @@ void libmp_dm_init(void)
 	memcpy(conf->version, version, sizeof(version));
 	put_multipath_config(conf);
 	dm_init(verbosity);
+	dm_hold_control_dev(1);
 	dm_udev_set_sync_support(libmp_dm_udev_sync);
 }
 
-- 
2.17.2
