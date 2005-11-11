From: "goggin, edward" <egoggin@emc.com>
Subject: RE: patch to enable creating device attributes before
	exporting h otpl ug/uevent for device kobject
Date: Thu, 10 Nov 2005 20:34:42 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADEB@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: 'Greg KH' <greg@kroah.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com] 
> Sent: Thursday, November 10, 2005 5:38 PM
> To: goggin, edward
> Cc: 'dm-devel@redhat.com'
> Subject: Re: patch to enable creating device attributes 
> before exporting hotpl ug/uevent for device kobject
> 
> On Thu, Nov 10, 2005 at 03:08:53PM -0500, goggin, edward wrote:
> > In order to guarantee visibility through Sysfs of device 
> attributes for
> > uevent/hotplug handlers, I've changed drivers/base/core.c:device_add
> > from calling kobject_register() before adding attributes to 
> the device
> > kobject to instead
> > 
> > 	(1) call kobject_add(),
> > 
> > 	(2) add the device attributes to the device kobject, and
> > 
> > 	(3) call kobject_hotplug() to export the kobject ONLY AFTER the
> > attributes
> > 	are added to the device object.
> > 
> > Also, changed scsi_sysfs_add_sdev() to follow this new 
> sequence for creating
> > scsi device objects.
> 
> Ick.  First a few general comments on procedure:
>   - please CC: linux-hotplug devel, or linux-kernel with core 
> stuff like
>     this.

OK.  Thanks.

>   - your patch was line-wrapped, and could not be applied :(

I'm having a terrible time with the line-wrapping.  I'll work on it.

>   - No Signed-off-by: line as per the rules specified in
>     Documentation/SubmittingPatches.

Guilty as charged.  I'll read Documentation/SubmittingPatches.  Thanks.

> 
> Ok, now, what exactly are you trying to solve here?  With 2.6.14 and
> udev handling the hotplug control, you should not see any need for a
> change like this.

The multipathd uevent handler is sometimes failing to find attribute files
for scsi sysfs kobjects like those found under /sys/block/sda/device/
because
these sysfs attributes are created after the kobject is added to sysfs.
Hotplug
and udev are not involved.

> 
> thanks,
> 
> greg k-h
> 
