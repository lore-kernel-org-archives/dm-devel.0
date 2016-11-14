From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: Re: [PATCH] multipathd: deferred device adding
Date: Mon, 14 Nov 2016 10:23:36 +0100
Message-ID: <4b591c27-f1eb-8859-a319-b19e2e3bd200@profitbricks.com>
References: <1478790321-8539-1-git-send-email-gi-oh.kim@profitbricks.com>
	<5a8c5ffb-2dae-0e5c-3341-1f02ab3cd4dc@suse.de>
	<8806d3b0-c507-3e2b-a7ff-fed6fbdfcb0a@profitbricks.com>
	<BLUPR02MB16838FD500AD57DA92DF4C0A81BB0@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BLUPR02MB16838FD500AD57DA92DF4C0A81BB0@BLUPR02MB1683.namprd02.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "benjamin.drung@profitbricks.com" <benjamin.drung@profitbricks.com>
List-Id: dm-devel.ids



On 11.11.2016 04:21, Bart Van Assche wrote:
> On 11/10/16 07:54, Gioh Kim wrote:
>> And new sdX device is created when the remote storage volume is connected via SCST.
>> I don't want to create a dm device when sdX is created because there are other jobs before export the volume.
>> For example, I need to change the size or format or copy data into sdb.
>> I want to create the dm device when I finished the setup.
>> I could disabled the socket in multipath udev rule file with v0.4.9.
>> But I cannot find a way to ignore the uevent.
> Hello Gioh,
>
> Are you familiar with the SCST "enabled" target driver attribute? Have 
> you considered to force initiators to log out while making changes at 
> the target side be changing that attribute into 0 temporarily?
>
> Bart.

Hello Bart,

I  consulted with target side developers in my company.
They said there are many jobs that should be done on initiator side without disconnecting.

I created following patch for example.
It makes multipathd ignore "add" uevent from sdX devices.

-----------------------8<-------------------------

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 6247898..c77de34 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -472,6 +472,20 @@ struct uevent *uevent_from_udev_device(struct udev_device *dev)
     /* print payload environment */
     for (i = 0; uev->envp[i] != NULL; i++)
         condlog(5, "%s", uev->envp[i]);
+
+    if (!strncmp(uev->action, "add", 3)) {
+        char *devname = strrchr(uev->devpath, '/');
+
+        if (!strncmp(devname + 1, "sd", 2)) {
+            condlog(3, "drop uevent '%s' from '%s'",
+                 uev->action, uev->devpath);
+            /* Freeing uev is copied from service_uevq() */
+            if (uev->udev)
+                udev_device_unref(uev->udev);
+            FREE(uev);
+        }
+    }
+
     return uev;
 }
 
-- 
2.1.4
