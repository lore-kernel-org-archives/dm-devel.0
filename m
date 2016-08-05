From: james harvey <jamespharvey20@gmail.com>
Subject: Re: During systemd/udev,
 device-mapper trying to work with non-LVM volumes
Date: Fri, 5 Aug 2016 05:27:13 -0400
Message-ID: <CA+X5Wn7Avs+76JHYPvAy7sbAsE-baF_9XXyeGm8RX=MZA8vCew@mail.gmail.com>
References: <CA+X5Wn5tbL02XpG-JMvZ4-Sdg+sv=yymD1s6Afboag59LqD94Q@mail.gmail.com>
	<4d36f133-5e8f-3e89-9038-5268b7b6f770@redhat.com>
	<CA+X5Wn5nZjyC2qk7yDYkMH+LX6kznjoEcubcMjC7tgN+k5vfbw@mail.gmail.com>
	<3608c518-ab93-c7fd-9dad-49650d234de6@redhat.com>
	<CA+X5Wn6L4kvgOkBx2=M97ni=C-WaZuq0+CiuYv1UJr8ZLu1C0g@mail.gmail.com>
	<73dca46b-dd4e-cb35-edcc-6d5d36b2c3ba@redhat.com>
	<CA+X5Wn6_0_ppGN=SX2yMfguG193VSRbXCNSnkqQLRFgoZ=U_Vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+X5Wn6_0_ppGN=SX2yMfguG193VSRbXCNSnkqQLRFgoZ=U_Vw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com, Marian Csontos <mcsontos@redhat.com>
List-Id: dm-devel.ids

Systemd says the LVM/DM developers install their own udev rules and
this is a LVM/DM issue, not a systemd issue.  See
https://github.com/systemd/systemd/issues/3899

On Thu, Aug 4, 2016 at 11:53 PM, james harvey <jamespharvey20@gmail.com> wrote:
> Ok, we can put the BTRFS issues aside.  I've reproduced using EXT4.
>
> Below are close to the minimal steps I can use to create the problem.
> If I remove some of the lvcreates that aren't being used, the problem
> seems to happen less often.  So I'm not sure if that has an affect on
> the race condition, or if I'm just seeing variance, so I've left those
> in there even though they don't appear to do anything.
>
> This appears to be a race condition that occurs while "udevadm trigger
> --action=add --type=devices" is running.  (Editing the systemd udev
> hook, inserting sleep's between udevadm calls shows this - without the
> sleeps it shows during "udevadm settle" is running, since the trigger
> call is running in the background.)  It happens very often, but not
> always.
>
> No idea if that means it's a udevadm (systemd) bug incorrectly giving
> device-mapper something, or a kernel device-mapper bug doing something
> wrong.
>
> Up to date Arch, linux 4.6.4, lvm2 2.02.162, systemd 231.
>
> In /etc/lvm/lvm.conf "locking_type = 1"
>
> I haven't been activating anything manually.  Looks like everything
> needing to be activated is somehow, but possibly things are trying to
> be activated that aren't involved with thin volumes or even LVM.
>
> I just noticed "dmsetup ls" and "dmsetup table" are showing different
> 253:X numbers.  I was only using "dmsetup table" in my original post.
> I don't know which version of the numbers are showing during the
> initramfs.
>
> If the error corresponds to the "dmsetup ls" numbers, than the error
> in this current boot refers to "disk2-disk2thin_tdata" and
> "disk3-persistent3", which is ext4. Over an mdadm array, the error
> occurs, and on a single lv it doesn't occur.
>
> If the error corresponds to the "dmsetup table" numbers, then the
> error refers to a device not in the table as well as possibly
> "disk2-disk2thin-tpool".
>
> Attached is another "lvmdump -m" file.  And a full dmesg (6MB, using
> systemd log level debug, etc) is available at:
> https://github.com/systemd/systemd/files/403118/udevError.shutdown-log.txt
>
> If during the install I skip making the mdadm boot array and just use
> a single partition, this doesn't happen.
>
> The error on this run is:
> :: Triggering uevents...
> [ 3.106579] device-mapper: table: 253:7: thin: Unable to
> activate thin device while pool is suspended
> [ 3.290255] device-mapper: table: 253:17: thin: Unable to
> activate thin device while pool is suspended
> . . .
>
> ==============================
>
> $ sudo dmsetup ls
> disk3-disk3thin (253:15)
> disk2-main2 (253:10)
> disk3-disk3thin-tpool (253:14)
> disk3-disk3thin_tdata (253:13)
> disk1-disk1thin-tpool (253:2)
> disk1-disk1thin_tdata (253:1)
> disk3-disk3thin_tmeta (253:12)
> disk3-main3 (253:16)
> disk2-disk2thin (253:9)
> disk1-disk1thin_tmeta (253:0)
> disk2-persistent2 (253:11)
> disk1-disk1thin (253:3)
> disk2-disk2thin-tpool (253:8)
> disk2-disk2thin_tdata (253:7)
> disk1-persistent1 (253:5)
> disk2-disk2thin_tmeta (253:6)
> disk1-main1 (253:4)
> disk3-persistent3 (253:17)
>
> ==============================
>
> $ sudo dmsetup table
>
> disk3-disk3thin: 0 1048576000 linear 253:14 0
> disk2-main2: 0 209715200 thin 253:8 1
> disk3-disk3thin-tpool: 0 1048576000 thin-pool 253:12 253:13 512 0 0
> disk3-disk3thin_tdata: 0 1048576000 linear 8:35 264192
> disk1-disk1thin-tpool: 0 1048576000 thin-pool 253:0 253:1 512 0 0
> disk1-disk1thin_tdata: 0 1048576000 linear 8:3 264192
> disk3-disk3thin_tmeta: 0 262144 linear 8:35 1048840192
> disk3-main3: 0 209715200 thin 253:14 1
> disk2-disk2thin: 0 1048576000 linear 253:8 0
> disk1-disk1thin_tmeta: 0 262144 linear 8:3 1048840192
> disk2-persistent2: 0 209715200 thin 253:8 2
> disk1-disk1thin: 0 1048576000 linear 253:2 0
> disk2-disk2thin-tpool: 0 1048576000 thin-pool 253:6 253:7 512 0 0
> disk2-disk2thin_tdata: 0 1048576000 linear 8:19 264192
> disk1-persistent1: 0 209715200 thin 253:2 2
> disk2-disk2thin_tmeta: 0 262144 linear 8:19 1048840192
> disk1-main1: 0 209715200 thin 253:2 1
> disk3-persistent3: 0 209715200 thin 253:14 2
>
> ==============================
>
> $ sudo lvmdump -m
> Creating dump directory: /root/lvmdump-terra-2016080534140
>
> Gathering LVM & device-mapper version info...
> Gathering dmsetup info...
> Gathering process info...
> Gathering console messages...
> Gathering /etc/lvm info...
> Gathering /dev listing...
> Gathering /sys/block listing...
> Gathering LVM metadata from Physical Volumes...
> /dev/sda3
> /dev/sdb3
> /dev/sdc3
> Creating report tarball in /root/lvmdump-terra-2016080534140.tgz...
>
> ==============================
>
> /dev/sd{a,b,c}1 3.5G Linux RAID
> /dev/sd{a,b,c}2 3.5G Linux RAID
> /dev/sd{a,b,c}3 4.5T Linux LVM
>
> { Setup LVM and filesystems }
>
> ({ This causes the issue })
> # mdadm --create --verbose --name=main_boot --homehost="none" --level
> 1 --metadata 1.0 --raid-devices=3 /dev/md1 /dev/sda1 /dev/sdb1
> /dev/sdc1
> # mkfs.ext4 -F -L main_boot /dev/disk/by-id/md-name-main_boot
>
> ({ This appears to prevent the issue })
> # mkfs.ext4 -F -L main_boot /dev/sda
>
> ({ Then, either way, continuing })
> # pvcreate --yes --pvmetadatacopies 2 /dev/sda3
> # vgcreate disk1 /dev/sda3
> # pvcreate --yes --pvmetadatacopies 2 /dev/sdb3
> # vgcreate disk2 /dev/sdb3
> # pvcreate --yes --pvmetadatacopies 2 /dev/sdc3
> # vgcreate disk3 /dev/sdc3
> # lvcreate --size 500G --thinpool disk1thin disk1
> # lvcreate --size 500G --thinpool disk2thin disk2
> # lvcreate --size 500G --thinpool disk3thin disk3
> # lvcreate --virtualsize 100G --name main1 disk1/disk1thin
> # lvcreate --virtualsize 100G --name main2 disk2/disk2thin
> # lvcreate --virtualsize 100G --name main3 disk3/disk3thin
> # mkfs.ext4 -L main /dev/disk1/main1
> # mount /dev/disk1/main1 /mnt
> # mkdir /mnt/boot
> # mount /dev/dev/sda1 /mnt/boot
> # lvcreate --virtualsize 100G --name persistent1 disk1/disk1thin
> # lvcreate --virtualsize 100G --name persistent2 disk2/disk2thin
> # lvcreate --virtualsize 100G --name persistent3 disk3/disk3thin
>
> { Install Arch Linux}
> # vi /etc/pacman.d/mirrorlist
> # pacstrap -i base syslinux gptfdisk lvm2
> # arch-chroot /mnt
> # vi /etc/locale.gen
> # locale-gen
> # locale > /etc/locale.conf
>
> ({ If using the mdadm to cause the error })
> # mdadm --detail --scan > /etc/mdadm.conf
>
> ({ Then, either way, continuing })
> # vi /etc/nsswitch.conf
> # systemd enable systemd-resolved systemd-networkd
> # ln -s /usr/share/zoneinfo/America/Detroit /etc/localtime
> # hwclock --utc --systohc
> # passwd
> { Add lvm2 between block and filesystems}
> # vi /etc/mkinitcpio.conf
> # mkinitcpio -p linux
> # echo hostname > /etc/hostname
> # vi /etc/systemd/network/enp31s0.network
> # syslinux-install_update -i -a -m
> # vi /boot/syslinux/syslinux.cfg
> {{ After exiting the arch-chroot }}
> # ln -f -s /run/systemd/resolve/resolv.conf /mnt/etc/resolv.conf
>
> { Reboot }
>
> ==============================
