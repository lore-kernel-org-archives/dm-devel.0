From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 2/6] multipathd: check for NULL udevice in
	cli_add_path
Date: Wed, 10 Oct 2018 13:01:09 -0500
Message-ID: <1539194473-6243-3-git-send-email-bmarzins@redhat.com>
References: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539194473-6243-1-git-send-email-bmarzins@redhat.com>
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

If cli_add_path can't get a udevice for the path, it should fail
immediately, instead of continuing with a NULL udevice, since it will
fail in store_pathinfo() anyway.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/cli_handlers.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index bb16472..7500080 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -720,6 +720,10 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		udevice = udev_device_new_from_subsystem_sysname(udev,
 								 "block",
 								 param);
+		if (!udevice) {
+			condlog(0, "%s: can't find path", param);
+			return 1;
+		}
 		conf = get_multipath_config();
 		pthread_cleanup_push(put_multipath_config, conf);
 		r = store_pathinfo(vecs->pathvec, conf,
-- 
2.7.4
