From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: dm-mon fails to load raid1 target
Date: Mon, 31 Jan 2005 07:47:10 -0600
Message-ID: <200501310747.10552.kevcorry@us.ibm.com>
References: <62b0912f05013009209d8d8f0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62b0912f05013009209d8d8f0@mail.gmail.com>
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
To: dm-devel@redhat.com, Molle Bestefich <molle.bestefich@gmail.com>
Cc: gerte@nieuwenborg.nl
List-Id: dm-devel.ids

On Sunday 30 January 2005 11:20 am, Molle Bestefich wrote:
> Hi
>
> I can't get dm_mon to load the raid1 target.

Do you mean "dm_mod", which is the core of the DM driver?

> The syslog says (timestamps removed):
> livecd device-mapper: : unknown target type
> livecd
> livecd device-mapper: error adding target to table

This means a user-space program tried to load a device-table for a target-type 
that doesn't exist or couldn't be loaded.

> Seems that there's a completely blank syslog message (reproducible),
> and a surplus colon in the first message.  Might be related to the
> dmraid tool.  Anyway.
>
> I'm booting with a Gentoo CD [gen2dmraid 0.99 - kernel: 2.6.9, driver
> 4.1.0, library 1.00.17-ioctl].
>
> The /lib/modules/.../raid1.ko file is present.

That is the module for MD/Software-RAID RAID-1, not the Device-Mapper 
mirroring module. They are completely different drivers that just happen to 
be in the same directory in the kernel source and module trees.

> I tried modprobe raid1 (fine), this didn't add the mirror target to
> "dmsetup targets".
> Tried unloading dm-mon, reloading raid1, loading dm-mon, still no mirror
> target.
>
> Any hints on what is going wrong / what I am doing wrong?

The Device-Mapper mirroring target is called "dm-mirror". Check your kernel 
configuration and make sure you have CONFIG_DM_MIRROR set to "y" or "m". If 
necessary, you may need to rebuild your kernel to enable it. Once it's 
enabled, run "dmsetup targets" and look for a "mirror" entry. If you've 
compiled DM mirroring as a module, try "modprobe dm-mirror", and then run 
"dmsetup targets" again.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://evms.sourceforge.net/

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
