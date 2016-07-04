From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/26] config: set 'deferred_remove' defaults at
	correct call
Date: Mon,  4 Jul 2016 09:08:23 +0200
Message-ID: <1467616126-10036-4-git-send-email-hare@suse.de>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
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
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

We should be setting the defaults for 'deferred_remove' when
loading the configuration file, not when creating the hardware
entries.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmultipath/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 00f3e53..6f3c4e8 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -419,7 +419,6 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
 	hwe->user_friendly_names = dhwe->user_friendly_names;
 	hwe->retain_hwhandler = dhwe->retain_hwhandler;
 	hwe->detect_prio = dhwe->detect_prio;
-	conf->deferred_remove = DEFAULT_DEFERRED_REMOVE;
 
 	if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_product)))
 		goto out;
@@ -622,6 +621,7 @@ load_config (char * file, struct udev *udev)
 	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
 	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
 	conf->uev_wait_timeout = DEFAULT_UEV_WAIT_TIMEOUT;
+	conf->deferred_remove = DEFAULT_DEFERRED_REMOVE;
 
 	/*
 	 * preload default hwtable
-- 
2.6.6
