From: malahal@us.ibm.com
Subject: Re: Configuring multipath for root device
Date: Mon, 7 Jan 2008 16:29:53 -0800
Message-ID: <20080108002952.GA1479@us.ibm.com>
References: <110b17190712191302o60d521eaj693410c26d07c1ad@mail.gmail.com>
	<1198099093.26366.32.camel@linuxchandra>
	<110b17190801071219k11749b81n45a7d1d5d35b9413@mail.gmail.com>
	<20080107202853.GA9833@us.ibm.com>
	<110b17190801071240i1690a9a0ua3b26acd7c3b349a@mail.gmail.com>
	<20080107204631.GA10495@us.ibm.com>
	<110b17190801071256j429907e5iec4f35b74cfb73c8@mail.gmail.com>
	<20080107215746.GA16911@us.ibm.com>
	<110b17190801071613q13e0d317pb792005ab724efa0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <110b17190801071613q13e0d317pb792005ab724efa0@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Pradipmaya Maharana [pradipmaya@gmail.com] wrote:
> Ok, so this is what the scene is :
> 
> linux-g78h:~ # ls -al /dev/disk/by-id/
> total 0
> drwxr-xr-x 2 root root 220 Jan  7 12:44 .
> drwxr-xr-x 5 root root 100 Jan  7 12:44 ..
> lrwxrwxrwx 1 root root   9 Jan  7 12:44 edd-int13_dev80 -> ../../sda
> lrwxrwxrwx 1 root root  10 Jan  7 12:44 edd-int13_dev80-part1 -> ../../sda1
> lrwxrwxrwx 1 root root  10 Jan  7 12:44 edd-int13_dev80-part2 -> ../../sda2
> lrwxrwxrwx 1 root root  10 Jan  7 12:44 edd-int13_dev80-part3 -> ../../sda3
> lrwxrwxrwx 1 root root   9 Jan  7 12:44 scsi-2221b000155f5d2d4 -> ../../sdb
> lrwxrwxrwx 1 root root  10 Jan  7 12:44 scsi-2221b000155f5d2d4-part1
> -> ../../sda1
> lrwxrwxrwx 1 root root  10 Jan  7 12:44 scsi-2221b000155f5d2d4-part2
> -> ../../sda2
> lrwxrwxrwx 1 root root  10 Jan  7 12:44 scsi-2221b000155f5d2d4-part3
> -> ../../sda3
> lrwxrwxrwx 1 root root   9 Jan  7 12:44 usb-ASUS_CB-5216A_DEF10A4090DF
> -> ../../sr0
> linux-g78h:~ #
> linux-g78h:~ # uname -a
> Linux linux-g78h 2.6.16.46-0.12-smp #1 SMP Thu May 17 14:00:09 UTC
> 2007 i686 i686 i386 GNU/Linux
> linux-g78h:~ #
> linux-g78h:~ # cat /etc/grub.conf
> setup --stage2=/boot/grub/stage2 (hd0,0) (hd0,0)
> quit
> linux-g78h:~ #
> linux-g78h:~ # cat /boot/grub/menu.lst
> # Modified by YaST2. Last modification on Mon Jan  7 19:40:30 UTC 2008
> default 0
> timeout 8
> ##YaST - generic_mbr
> gfxmenu (hd0,0)/message
> ##YaST - activate
> 
> ###Don't change this comment - YaST2 identifier: Original name: linux###
> title SUSE Linux Enterprise Server 10 SP1
>     root (hd0,0)
>     kernel /vmlinuz-2.6.16.46-0.12-smp root=/dev/sda2 vga=0x31a
> resume=/dev/sda3 showopts
>     initrd /initrd-2.6.16.46-0.12-smp
> 
> ###Don't change this comment - YaST2 identifier: Original name: failsafe###
> title Failsafe -- SUSE Linux Enterprise Server 10 SP1
>     root (hd0,0)
>     kernel /vmlinuz-2.6.16.46-0.12-smp root=/dev/sda2 vga=normal
> showopts ide=nodma apm=off acpi=off noresume nosmp noapic maxcpus=0
> edd=off 3
>     initrd /initrd-2.6.16.46-0.12-smp
> 
> ###Don't change this comment - YaST2 identifier: Original name: linux###
> title SUSE Linux Enterprise Server 10 SP1 ORG
>     root (hd0,0)
>     kernel /vmlinuz-2.6.16.46-0.12-smp root=/dev/sda2 vga=0x31a
> resume=/dev/sda3 showopts
>     initrd /initrd-2.6.16.46-0.org.12-smp
> 
> 
> So, I modified the fstab and menu.lst to replace all /dev/sdaX with
> /dev/scsi-2221b000155f5d2d4-partX. It won't boot.

/dev/scsi-2221b000155f5d2d4-partX is bogus! Your root device /dev/sda2
actually is edd-int13_dev80-part2, specifically it is
/dev/disk/by-id/edd-int13_dev80-part2.  You should replace /dev/sdaX
with /dev/disk/by-id/edd-int13_dev80-partX

Also, make sure that what ever you replace with is a valid name. For
example, /dev/scsi-2221b000155f5d2d4-partX will NOT exist on your
system where as /dev/disk/by-id/edd-int13_dev80-part2 should exist.
