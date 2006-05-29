From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Add events for dm suspend / resume
Date: Mon, 29 May 2006 10:04:09 +0200
Message-ID: <447AAAF9.2070704@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030104090400010507030401"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030104090400010507030401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

currently device-mapper doesn't play well with udev & hotplug events.
The event is sent out on the initial device create; only at this stage
the device is not usable. Only after one did a 'table load' and a
'resume' the device is actually accessible from userland.
And thus it is purely coincidental if any 'dmsetup' call from udev
(which is triggered by the device create events) will return any useful
data.

This patch adds two additional events 'online' and 'offline' which get
send after 'resume' and 'suspend', respectively.
With this patch udev can hook on the 'online' event and will always get
valid data via the dmsetup call.

Comments etc. are welcome.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------030104090400010507030401
Content-Type: text/plain;
 name="dm-suspend-resume-events"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-suspend-resume-events"

--- linux-2.6.16/drivers/md/dm.c.orig	2006-05-23 12:18:09.000000000 +0200
+++ linux-2.6.16/drivers/md/dm.c	2006-05-26 14:09:16.000000000 +0200
@@ -1201,6 +1201,7 @@ int dm_suspend(struct mapped_device *md,
 	dm_table_postsuspend_targets(map);
 
 	set_bit(DMF_SUSPENDED, &md->flags);
+	kobject_uevent(&md->disk->kobj, KOBJ_OFFLINE);
 
 	r = 0;
 
@@ -1247,6 +1248,7 @@ int dm_resume(struct mapped_device *md)
 
 	dm_table_unplug_all(map);
 
+	kobject_uevent(&md->disk->kobj, KOBJ_ONLINE);
 	r = 0;
 
 out:

--------------030104090400010507030401
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030104090400010507030401--
