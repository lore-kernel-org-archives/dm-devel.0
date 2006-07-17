From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Booting Linux from a RAID volume
Date: Mon, 17 Jul 2006 13:09:22 +0200
Message-ID: <62b0912f0607170409i529a732di8e150209bfd1903c@mail.gmail.com>
References: <A6A77F954AFACF42928F5E931ABDB18F6DC3A2@bgsmsx411.gar.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <A6A77F954AFACF42928F5E931ABDB18F6DC3A2@bgsmsx411.gar.corp.intel.com>
Content-Disposition: inline
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

Srinivas, Vidya wrote:
> I am using dmraid to activate the RAID5 volume (Intel software raid). Can
> someone let me know the best way to install Linux on the volume?

There are several distributions that will load dmraid before
initializing graphical setup.
Using one of those, it should be as simple as a regular installation.

> I observed that, each time the machine reboots, the dmraid activated RAID
> volume name changes. So how can I achieve bootable Linux volume using grub
> or something else?

That sounds like a bug in dmraid.

For most RAID controllers, the dmraid developers does not have any
documentation from the manufacturer, so they're basically guessing
what's what.  This case sounds like they've accidentally included some
dynamic fields into the calculation of the RAID array name.

Heinz (main dmraid developer) would probably appreciate if you could
dump the metadata on your disks (dmraid has a function to do this),
reboot your PC, dump again, and send both dumps to him.

I think he's subscribed to dm-devel, but otherwise I guess he mostly
hangs out over on the ataraid list, where they deal with running
host-cpu-based RAID adapters under Linux.
