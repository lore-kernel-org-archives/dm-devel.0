From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 1/4] libmultipath: fix sysfs dev_loss_tmo
	parsing
Date: Thu, 2 Jul 2020 14:31:17 +0000
Message-ID: <808a0a681be20a1d1cfe616bc5a370db7fda2ce9.camel@suse.com>
References: <1593643176-6206-1-git-send-email-bmarzins@redhat.com>
	<1593643176-6206-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593643176-6206-2-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <F7CF0B1F88E84649B36891F792332436@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-07-01 at 17:39 -0500, Benjamin Marzinski wrote:
> dev_loss_tmo is a u32 value. However the kernel sysfs code prints it
> as
> a signed integer. This means that if dev_loss_tmo is above INT_MAX,
> the
> sysfs value will be a negative number. Parsing this was causing
> sysfs_set_rport_tmo() to fail.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks for catching this. I think it can be fixed simpler, because 
strtoul() parses negative values just fine. See below.

Regards,
Martin

From 16eca9b0f340a13fee0c28ae52dffa578193f015 Mon Sep 17 00:00:00 2001
From: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 1 Jul 2020 17:39:33 -0500
Subject: [PATCH] libmultipath: fix sysfs dev_loss_tmo parsing

dev_loss_tmo is a u32 value. However the kernel sysfs code prints it as
a signed integer. This means that if dev_loss_tmo is above INT_MAX, the
sysfs value will be a negative number. Parsing this was causing
sysfs_set_rport_tmo() to fail.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 1d542ea..3c9803a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -581,7 +581,7 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 	struct udev_device *rport_dev = NULL;
 	char value[16], *eptr;
 	char rport_id[32];
-	unsigned long long tmo = 0;
+	unsigned int tmo;
 	int ret;
 
 	sprintf(rport_id, "rport-%d:%d-%d",
@@ -605,8 +605,8 @@ sysfs_set_rport_tmo(struct multipath *mpp, struct path *pp)
 			"error %d", rport_id, -ret);
 		goto out;
 	}
-	tmo = strtoull(value, &eptr, 0);
-	if (value == eptr || tmo == ULLONG_MAX) {
+	tmo = strtoul(value, &eptr, 0);
+	if (value == eptr) {
 		condlog(0, "%s: Cannot parse dev_loss_tmo "
 			"attribute '%s'", rport_id, value);
 		goto out;
-- 
2.26.2
