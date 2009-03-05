From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: dmsetup status not clear
Date: Thu, 5 Mar 2009 11:20:53 -0500
Message-ID: <20090305162053.GB29061@mars.virtualiron.com>
References: <a60f25fc0903041435ob7e7575kc2ebe0770d5cd36e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <a60f25fc0903041435ob7e7575kc2ebe0770d5cd36e@mail.gmail.com>
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

> Why is the new disk showing up as `sdc' instead of `sdb'  and why is

I can't comment on the naming - but in regards to the write cache - that is
the information the kernel gets from the device using SCSI commands (to be
exact it MODE_SENSE). The device has it disabled. You can fiddle with MODE_SELECT
command if you want to enable it - but keep in mind that when you have a RAID
it is advised to turn cache off. Unless your computer has a UPS connected so that 
you can flush the data immediately and turn off caching.

> the write cache disabled?
> 
> 
> Of course similar two lines below showing up only in dmesg and not in
> messages file
> 
> 
> [ 2465.456628] ata4: exception Emask 0x10 SAct 0x0 SErr 0x150000
> action 0xe frozen
> [ 2465.543901] ata4: SError: { PHYRdyChg CommWake Dispar }
> [ 2465.606247] ata4: hard resetting link
> 
That is OK.
> 
> Also, how can I find out if/when the raid1 sync completed? I do not
> follow what the dmsetup status is saying

cat /proc/dmstatus should give you some details.

> 
> 
> ~$ sudo dmsetup status
> nvidia_eeffhbef5: 0 6458067 linear
> nvidia_eeffhbef1: 0 149838192 linear
> nvidia_eeffhbef: 0 156301486 mirror 2 8:0 8:16 1183/1193 1 AD 1 core

That is just the static mapping it has setup. Where it says that disks 8:0 and 8:16
are part of the of your RAID. Do a 'ls /dev/ | grep 8' and you will see what 
the 8:0, and 8:16 correspond to.

> 
> 
> -- 
> Asif Iqbal
> PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
