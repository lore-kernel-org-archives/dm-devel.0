From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/4] multipath: blacklist zram devices
Date: Thu,  7 Feb 2019 17:53:00 -0600
Message-ID: <20190207235302.21635-3-bmarzins@redhat.com>
References: <20190207235302.21635-1-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190207235302.21635-1-bmarzins@redhat.com>
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

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/blacklist.c   | 2 +-
 multipath/multipath.conf.5 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 709895e..e0d0279 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -192,7 +192,7 @@ setup_default_blist (struct config * conf)
 	char * str;
 	int i;
 
-	str = STRDUP("^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");
+	str = STRDUP("^(ram|zram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]");
 	if (!str)
 		return 1;
 	if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 88b8edd..0fe8461 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1218,7 +1218,7 @@ Regular expression matching the device nodes to be excluded/included.
 .RS
 .PP
 The default \fIblacklist\fR consists of the regular expressions
-"^(ram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]" and
+"^(ram|zram|raw|loop|fd|md|dm-|sr|scd|st|dcssblk)[0-9]" and
 "^(td|hd|vd)[a-z]". This causes virtual devices, non-disk devices, and some other
 device types to be excluded from multipath handling by default.
 .RE
-- 
2.17.2
