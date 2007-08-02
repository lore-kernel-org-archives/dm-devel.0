From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: LVM on dmraid breakage
Date: Thu, 02 Aug 2007 18:04:20 -0400
Message-ID: <46B254E4.60700@cfl.rr.com>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
Reply-To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <ataraid-list-bounces@redhat.com>
In-Reply-To: <20070802065012.GA28687@percy.comedia.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ataraid-list>
List-Post: <mailto:ataraid-list@redhat.com>
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
Sender: ataraid-list-bounces@redhat.com
Errors-To: ataraid-list-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

Luca Berra wrote:
> Two things come to mind
> 1) dmraid should use ioctl BLKPG_DEL_PARTITION, to clean up any eventual
> partition table on component devices

How will this play out in terms of udev plug events?  Can it be relied 
on that udev will process the disk first, before the partitions?  If the 
partitions are deleted during the processing of the disk, does udev 
still try to process their add events?  Will it then process the delete 
events?  If so then this is problematic.

> 2) lvm tool filter could be modified to check if a device has been
> already claimed by device-mapper.
> 
> something along the lines of:
> ioctl DM_LIST_DEVICES
> while (...)
>  ioctl DM_TABLE_DEPS
> 
> the above would probably require a cache.

I'd rather not see it that tightly coupled to dm.  I was thinking 
perhaps of something involving udev attributes so that udev would know 
not to run pvscan on that device.  Though it looks like pvscan also 
needs reworked so it plays nice with udev, being called to scan a given 
device as detected rather than looking for all well known physical 
device names in /dev.
