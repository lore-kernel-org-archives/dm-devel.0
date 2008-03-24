From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Installing RHEL with single controller
Date: Mon, 24 Mar 2008 10:51:05 -0700
Message-ID: <110b17190803241051w5986b87aj86f2b01217837de7@mail.gmail.com>
References: <110b17190802281008u6e5eeef4vccfb509be7ad4198@mail.gmail.com>
	<20080228192135.GA13340@us.ibm.com>
	<110b17190802281136k7f303322y28f9952c82366a0c@mail.gmail.com>
	<20080228201122.GA13566@us.ibm.com>
	<1204234581.4963.89.camel@linuxchandra>
	<110b17190802281507l755d7bd0hb8fd9e83e5dc1374@mail.gmail.com>
	<1204244155.4963.95.camel@linuxchandra>
	<110b17190802291134v3bf3d9cfp4c37a20f6f48aea7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <110b17190802291134v3bf3d9cfp4c37a20f6f48aea7@mail.gmail.com>
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
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Any comments?
Please help.

Regards,
Pradipmaya.


On Fri, Feb 29, 2008 at 12:34 PM, Pradipmaya Maharana
<pradipmaya@gmail.com> wrote:
> Hey Chandra,
>
> It's RHEL 5.1.
> [root@localhost test]# uname -a
> Linux localhost.localdomain 2.6.18-53.el5xen #1 SMP Wed Oct 10
> 16:48:44 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux
>
> Yes, it can see the 2 devices.
> [root@localhost test]# cat /proc/partitions
> major minor  #blocks  name
>   8     0   34603520 sda
>   8     1     104391 sda1
>   8     2   34491555 sda2
>   8    16   34603520 sdb
>  253     0   32440320 dm-0
>  253     1    2031616 dm-1
>
> mkinitrd does not return any message.
> [root@localhost ~]# mkinitrd /boot/initrd.final.2.img 2.6.18-53.el5xen
> --with=dm-multipath
> [root@localhost ~]#
>
> Here is what I did:
> [root@localhost test]# cpio -i < initrd.final.2.img
> 15587 blocks
> [root@localhost test]# ls
> bin  dev  etc  init  initrd.final.2.img  lib  proc  sbin  sys  sysroot
> [root@localhost test]# ls lib/
> dm-mirror.ko           ext3.ko                ohci-hcd.ko
> dm-mod.ko              firmware/              scsi_mod.ko
> dm-multipath.ko        jbd.ko                 scsi_transport_sas.ko
> dm-snapshot.ko         mptbase.ko             sd_mod.ko
> dm-zero.ko             mptsas.ko              uhci-hcd.ko
> ehci-hcd.ko            mptscsih.ko            usb-storage.ko
>
> Attached is the init file for your reference.
>
> Here is the blacklist section from /etc/multipath
>
> blacklist {
>        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>        devnode "^(hd|xvd)[a-z][[0-9]*]"
>        devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
> }
>
> Thanks and Regards,
> Pradipmaya.
>
> On Thu, Feb 28, 2008 at 4:15 PM, Chandra Seetharaman
>
> <sekharan@us.ibm.com> wrote:
> > On Thu, 2008-02-28 at 15:07 -0800, Pradipmaya Maharana wrote:
> >  > Ok; this is what I did:
> >  >
> >  > mkinitrd   /boot/initrd.final.img   2.6.18-53.el5xen   --with=dm-multipath
> >  >
> >  > Changed the /boot/grub/menu.lst file to point to new initrd image file.
> >  > Reboot is fine but multipath -ll is still null. :(
> >  >
> >  > What am I missing here.
> >
> >  That is odd!!
> >
> >  What version of RHEL do you have ?
> >
> >  Do you see 2 scsi devices (sda and sdb) for the same lun when your
> >  system is up ?
> >
> >  Can you send the o/p of mkinitrd.
> >
> >  Can you extract the file "init" from your initrd image and send it.
> >
> >  Can you check if the device is blacklisted in your multipath.conf file ?
> >
> >
> >
> >  >
> >  > Regards,
> >  > Pradipmaya.
> >  >
> >  >
> >  > On Thu, Feb 28, 2008 at 1:36 PM, Chandra Seetharaman
> >  > <sekharan@us.ibm.com> wrote:
> >  > > On Thu, 2008-02-28 at 12:11 -0800, malahal@us.ibm.com wrote:
> >  > > > Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> >  > > > > Multipath is getting loaded, if that is what you are wondering about.
> >  > > > > After reboot I check for multipathd status, and smod for the modules
> >  > > > > loaded, everything looks fine.
> >  > > >
> >  > > > No, I am asking if initrd image contains multipath commands. You need to
> >  > > > use cpio to extract the initrd image and see the source code to check
> >  > > > it!
> >  > > >
> >  > > > multipath has to be loaded and *run* before mounting your real root. If
> >  > > > it gets loaded after  mounting your real root, it is too late to have
> >  > > > multipath on root disk! Looks like you need to regenerate initrd with
> >  > > > multpath support.
> >  > >
> >  > > Yes, Malahal is right. You need to create initrd with multipath tools.
> >  > > You can do this by running mkinitrd with "--with=dm-multipath"
> >  > > (Follow the SLES10 installation instructions in my documentation
> >  > > http://sources.redhat.com/lvm2/wiki/MultipathUsageGuide )
> >  > >
> >  > >
> >  > > > --Malahal.
> >  > > >
> >  > > > --
> >  > > > dm-devel mailing list
> >  > > > dm-devel@redhat.com
> >  > > > https://www.redhat.com/mailman/listinfo/dm-devel
> >  > > --
> >  > >
> >  > > ----------------------------------------------------------------------
> >  > >    Chandra Seetharaman               | Be careful what you choose....
> >  > >              - sekharan@us.ibm.com   |      .......you may get it.
> >  > > ----------------------------------------------------------------------
> >  > >
> >  > >
> >  > >
> >  > > --
> >  > > dm-devel mailing list
> >  > > dm-devel@redhat.com
> >  > > https://www.redhat.com/mailman/listinfo/dm-devel
> >  > >
> >  --
> >
> >
> >
> >  ----------------------------------------------------------------------
> >     Chandra Seetharaman               | Be careful what you choose....
> >               - sekharan@us.ibm.com   |      .......you may get it.
> >  ----------------------------------------------------------------------
> >
> >
> >
>
