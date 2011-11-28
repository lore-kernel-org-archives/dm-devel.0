From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: Re: info on enabling only one path with rdac and DS4700
Date: Mon, 28 Nov 2011 12:01:49 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9109D090A@RTPMVEXC1-PRD.hq.netapp.com>
References: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com><1321389505.23295.4.camel@lapoo.opensvc.com><CAG2kNCyHk+vosO1+TtNwLUcH5AJP-cPn8m5nCDhVkenXFFxfjw@mail.gmail.com><201111161424.50911.hirtejs@idmt.fraunhofer.de><CAG2kNCw9ZdWrk1Ai6xQ=gDeMeV22verUQWw8+18yWNMjscuPMg@mail.gmail.com><47D23AD8469A2B448F33C24BD7A39BD9109D07FE@RTPMVEXC1-PRD.hq.netapp.com>
	<CAG2kNCxrA7twm2k7k8VWQGnWaADEog8iiyjEwfCiJj=OWCvqjQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <CAG2kNCxrA7twm2k7k8VWQGnWaADEog8iiyjEwfCiJj=OWCvqjQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

> -----Original Message-----
> From: Gianluca Cecchi [mailto:gianluca.cecchi@gmail.com]
> Sent: Monday, November 28, 2011 10:05 AM
> To: device-mapper development
> Subject: Re: [dm-devel] info on enabling only one path with rdac and
> DS4700
> 
> On Mon, Nov 28, 2011 at 3:46 PM, Moger, Babu wrote:
> >> 3) Based on messages during failover, is it true that I can avoid
> >> explicitly put scsi_dh in initrd?
> >> If I create initrd this way:
> >> mkinitrd /boot/initrd-$(uname -r)-scsi_dh.img $(uname -r) --
> >> preload=scsi_dh_rdac
> >> I get this difference:
> >> [root@testserver ~]# diff /tmp/new/init /tmp/current/init
> >> 44,51d43
> >> < echo "Loading scsi_mod.ko module"
> >> < insmod /lib/scsi_mod.ko
> >> < echo "Loading sd_mod.ko module"
> >> < insmod /lib/sd_mod.ko
> >> < echo "Loading scsi_dh.ko module"
> >> < insmod /lib/scsi_dh.ko
> >> < echo "Loading scsi_dh_rdac.ko module"
> >> < insmod /lib/scsi_dh_rdac.ko
> >> 62a55,58
> >> > echo "Loading scsi_mod.ko module"
> >> > insmod /lib/scsi_mod.ko
> >> > echo "Loading sd_mod.ko module"
> >> > insmod /lib/sd_mod.ko
> >>
> >> or will it help in any way?
> >
> > Having scsi_dh_rdac in initrd will help to get rid of the initial I/O
> errors you are seeing.
> >
> 
> Actually not.... see screen shots of console start at
> https://docs.google.com/open?id=0BwoPbcrMv8mvMWRlYmVhM2MtY2JkYi00ZDMzLW
> IxMWMtMDM0YzZjMWU0NGE1
> and
> https://docs.google.com/open?id=0BwoPbcrMv8mvM2RjMDg1MWUtYzVmZC00OTA1LT
> ljNjAtZGZmMjM5NDlhYTI4
> and also dmesg giving for example for sdb and sdc:

Looks like there is something else going on here.

> 
> scsi 3:0:0:1: rdac: LUN 1 (unowned)

This is when handler is loaded.  Looks like your passive paths were detected first.
From now on, I/Os coming on to sdb will be silenced and will not got to target. That is not happening.

What is the kernel level. I remember there was an issue. It was fixed later by this commit..
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=5a36756b8b3d7178d9c101d1e2a7a83fd7b17706



> sdb : very big device. try to use READ CAPACITY(16).
> SCSI device sdb: 7320494080 512-byte hdwr sectors (3748093 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 77 00 10 08
> SCSI device sdb: drive cache: write back w/ FUA
> sdb : very big device. try to use READ CAPACITY(16).
> SCSI device sdb: 7320494080 512-byte hdwr sectors (3748093 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 77 00 10 08
> SCSI device sdb: drive cache: write back w/ FUA
>  sdb:<3>Buffer I/O error on device sdb, logical block 0
> Buffer I/O error on device sdb, logical block 0
> Buffer I/O error on device sdb, logical block 0
> Buffer I/O error on device sdb, logical block 0
> Buffer I/O error on device sdb, logical block 0
> Buffer I/O error on device sdb, logical block 0
> Buffer I/O error on device sdb, logical block 0
> Dev sdb: unable to read RDB block 0
> Buffer I/O error on device sdb, logical block 0
> Buffer I/O error on device sdb, logical block 0
>  unable to read partition table
> sd 3:0:0:1: Attached scsi disk sdb
>   Vendor: IBM       Model: 1814      FAStT   Rev: 0916
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> scsi 3:0:1:1: rdac: LUN 1 (owned)
> scsi 3:0:1:1: rdac: LUN 1 (owned)
> sdc : very big device. try to use READ CAPACITY(16).
> SCSI device sdc: 7320494080 512-byte hdwr sectors (3748093 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 77 00 10 08
> SCSI device sdc: drive cache: write back w/ FUA
> sdc : very big device. try to use READ CAPACITY(16).
> SCSI device sdc: 7320494080 512-byte hdwr sectors (3748093 MB)
> sdc: Write Protect is off
> sdc: Mode Sense: 77 00 10 08
> SCSI device sdc: drive cache: write back w/ FUA
>  sdc: unknown partition table
> sd 3:0:1:1: Attached scsi disk sdc
> ...
> GSI 23 sharing vector 0x72 and IRQ 23
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 114
> eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit
> 133MHz found at mem da000000, IRQ 114, node addr 00215e2fd0e2
> ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 19 (level, low) -> IRQ 90
> eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit
> 133MHz found at mem d8000000, IRQ 90, node addr 00215e2fd0e4
> printk: 69 messages suppressed.
> Buffer I/O error on device sdb, logical block 0
> ...
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> device-mapper: multipath: version 1.0.6 loaded
> device-mapper: multipath: Using scsi_dh module scsi_dh_rdac for
> failover/failback and device management.
> device-mapper: multipath round-robin: version 1.0.0 loaded
> printk: 4 messages suppressed.
> Buffer I/O error on device sdb, logical block 915061759
> ...
> 
> So if I have to get yet the I/O errors, having no advantage, I'd
> prefer to stay stick with the default initrd...
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
