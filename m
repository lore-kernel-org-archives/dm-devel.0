From: "Ivan Lezhnjov Jr." <ivan.lezhnjov.jr@gmail.com>
Subject: Name change: '/dev/dm-0' -> '/dev/lvm/home'
Date: Sat, 24 Nov 2007 02:23:06 +0200
Message-ID: <200711240223.06412.ivan.lezhnjov.jr@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="windows-1251"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I'm using LVM on my system and I've faced an issue that I set myself to 
resolve. The essence of the issue is shown in the following /sbin/lilo -t 
command output: 

> root@sega:/home/users/ilj# /sbin/lilo -t
> Warning: '/proc/partitions' does not match '/dev' directory structure.
>     Name change: '/dev/dm-0' -> '/dev/lvm/home'
> Warning: Name change: '/dev/dm-1' -> '/dev/lvm/tmp'
> Warning: Name change: '/dev/dm-2' -> '/dev/lvm/usr'
> Warning: Name change: '/dev/dm-3' -> '/dev/lvm/var'
> Added linux-2.6.23 *
> Added 2.6.22
> Added linux-2.6.19.5
> The boot sector and the map file have *NOT* been altered.
> 4 warnings were issued.

I'm pretty novice to device-mapper (hey, i'm a mere user! :) ) and LVM. I use 
basic configurations for both. Nothing really special.

These warnings LILO returns weren't always there. They appeared after a recent 
system update (I'm running Source Mage). There were no such warnings 
previously. I contacted a LILO maintainer on a related issue and he kindly 
responded with confirmation that these warnings are not LILO related. As far 
as I know, LVM is a set of userspace tools and the actual job is done by 
device-mapper. So, I don't see much point in contacting LVM developers (at 
least at the present moment) and this is basically why I'm contacting you the 
developers of device-mapper code.

My goal is to comprehend the origin of the warnings and their actual meaning, 
also set things straight so that LILO doesn't return these warnings.

Hopefully, you are the guys that can help me with this :)

Information about what software version numbers I use and configuration 
details:

- linux 2.6.23
(not patched but not vanilla either; configured tuned and tweaked with my own 
two hands :))

device-mapper related linux configuration options:

> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_CRYPT=y
> CONFIG_DM_SNAPSHOT=y
> CONFIG_DM_MIRROR=y
> CONFIG_DM_ZERO=y
> CONFIG_DM_MULTIPATH=y
> # CONFIG_DM_MULTIPATH_EMC is not set
> # CONFIG_DM_MULTIPATH_RDAC is not set
> # CONFIG_DM_DELAY is not set
> # CONFIG_DM9102 is not set

- lilo 22.8
- lvm 2.02.28

Physical Volume I use

> root@sega:/home/users/ilj# pvdisplay
>   --- Physical volume ---
>   PV Name               /dev/sda3
>   VG Name               lvm
>   PV Size               69.87 GB / not usable 3.30 MB
>   Allocatable           yes (but full)
>   PE Size (KByte)       4096
>   Total PE              17886
>   Free PE               0
>   Allocated PE          17886
>   PV UUID               eRl10i-TM4M-Z7yk-JOGu-b0o9-IaNa-G1iThc

Virtual Group on the Physical Volume

> root@sega:/home/users/ilj# vgdisplay
>   --- Volume group ---
>   VG Name               lvm
>   System ID
>   Format                lvm2
>   Metadata Areas        1
>   Metadata Sequence No  13
>   VG Access             read/write
>   VG Status             resizable
>   MAX LV                0
>   Cur LV                4
>   Open LV               4
>   Max PV                0
>   Cur PV                1
>   Act PV                1
>   VG Size               69.87 GB
>   PE Size               4.00 MB
>   Total PE              17886
>   Alloc PE / Size       17886 / 69.87 GB
>   Free  PE / Size       0 / 0
>   VG UUID               PdcYgd-CsWE-CVUJ-po1J-tKGp-VdW9-08bx33

Logical Volumes themselves

> root@sega:/home/users/ilj# lvdisplay
>   --- Logical volume ---
>   LV Name                /dev/lvm/home
>   VG Name                lvm
>   LV UUID                IlQCbp-CY44-E5Fn-VHk2-CGVR-Cgud-aLCtNv
>   LV Write Access        read/write
>   LV Status              available
>   # open                 1
>   LV Size                49.87 GB
>   Current LE             12766
>   Segments               1
>   Allocation             inherit
>   Read ahead sectors     0
>   Block device           253:0
>
>   --- Logical volume ---
>   LV Name                /dev/lvm/tmp
>   VG Name                lvm
>   LV UUID                s9tqUP-V0il-2jd1-suyS-bLpG-Wy2n-zm4Eeu
>   LV Write Access        read/write
>   LV Status              available
>   # open                 1
>   LV Size                2.00 GB
>   Current LE             512
>   Segments               1
>   Allocation             inherit
>   Read ahead sectors     0
>   Block device           253:1
>
>   --- Logical volume ---
>   LV Name                /dev/lvm/usr
>   VG Name                lvm
>   LV UUID                A8PDF8-8o8X-hX2H-WiYq-nBTF-Cbtd-DpVwxq
>   LV Write Access        read/write
>   LV Status              available
>   # open                 1
>   LV Size                14.00 GB
>   Current LE             3584
>   Segments               1
>   Allocation             inherit
>   Read ahead sectors     0
>   Block device           253:2
>
>   --- Logical volume ---
>   LV Name                /dev/lvm/var
>   VG Name                lvm
>   LV UUID                7hagoJ-k3t7-yyZ1-d5Tc-C106-KOQK-3K3vpV
>   LV Write Access        read/write
>   LV Status              available
>   # open                 1
>   LV Size                4.00 GB
>   Current LE             1024
>   Segments               1
>   Allocation             inherit
>   Read ahead sectors     0
>   Block device           253:3

- device-mapper-1.02.22
> root@sega:/home/users/ilj# dmsetup --version
> Library version:   1.02.22 (2007-08-21)
> Driver version:    4.11.0

This is it. If I missed anything let me know, please.
I'm really looking forward to getting answers to the questions I've got. 
Whatever it may take :) I'm more than just curious now since I spent quite a 
period of time trying to figure out the answers on my own, bothered random 
people in real life and on the Internet in forums, IRC and now in 
mailing-list :)

-- 
Ivan Lezhnjov Jr.

Europe, Ukraine, Simferopol. Local Time:
Sat Nov 24 01:56:42 EET 2007

Source Mage GNU/Linux 0.9.6.3, linux-2.6.23 #8
Disassemble To Assemble Something Pure
