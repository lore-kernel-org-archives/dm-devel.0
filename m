From: Greg KH <greg@kroah.com>
Subject: Re: patch to enable creating device attributes before
	exporting h otpl ug/uevent for device kobject
Date: Thu, 10 Nov 2005 22:16:05 -0800
Message-ID: <20051111061605.GB12008@kroah.com>
References: <C2EEB4E538D3DC48BF57F391F422779321ADEB@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ADEB@srmanning.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "goggin, edward" <egoggin@emc.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 10, 2005 at 08:34:42PM -0500, goggin, edward wrote:
> 
> The multipathd uevent handler is sometimes failing to find attribute files
> for scsi sysfs kobjects like those found under /sys/block/sda/device/
> because these sysfs attributes are created after the kobject is added
> to sysfs.  Hotplug and udev are not involved.

Then make it involved.  On modern distros, /sbin/hotplug is disabled to
NULL.  udevd watches the netlink socket and handles all of the event
ordering.  Add your hook in a udev rule and you will not have to worry
about the wait issues at all, thereby sparing the kernel these nasty
changes.

Or just copy the logic out of the udev codebase for your userspace code,
as long as it's under the GPL, you are fine to do so.

thanks,

greg k-h
