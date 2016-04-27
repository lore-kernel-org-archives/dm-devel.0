From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/57] multipathd: skip uninitialized devices
	during reconfiguration
Date: Wed, 27 Apr 2016 13:10:31 +0200
Message-ID: <1461755458-29225-31-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

libudev has a separate filter setting to skip uninitialized
devices during enumeration.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/discovery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 2fa0907..2cf2566 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -148,6 +148,7 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 		return -ENOMEM;
 
 	udev_enumerate_add_match_subsystem(udev_iter, "block");
+	udev_enumerate_add_match_is_initialized(udev_iter);
 	udev_enumerate_scan_devices(udev_iter);
 
 	udev_list_entry_foreach(entry,
-- 
2.6.6
