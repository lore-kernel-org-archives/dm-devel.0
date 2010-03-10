From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Shared snapshots test
Date: Wed, 10 Mar 2010 08:11:11 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1003100806450.1635@hs20-bc2-1.build.redhat.com>
References: <20100310123713.GA9341@mick>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100310123713.GA9341@mick>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikhail Klepachevskyy <mikhailk1@open-e.com>
Cc: dm-devel@redhat.com, Sergey Tashkinov <sergeyt1@open-e.com>
List-Id: dm-devel.ids

Hi

You need to suspend and resume the origin device after create message and 
before attaching the snapshot.

> Hello!
> 
> I tried to test multisnapshots but unfortunately got some errors.
> Here is what I did:
> 
> 1) Build vanilla linux-2.6.33 kernel using Ubuntu Desktop 9.10
>    config-2.6.31-19-generic config file with
>    CONFIG_DM_MULTISNAPSHOT=m
>    CONFIG_DM_MULTISNAPSHOT_MIKULAS=m
>    CONFIG_DM_MULTISNAPSHOT_DANIEL=m
>    lines added and with patches from http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r16/
>    imposed.
> 
> 2) reboot with new kernel
> 
> 3) # modprobe dm-store-mikulas
> 
>    # modprobe dm-multisnapshot
> 
>    # pvcreate /dev/sdb
> 
>    # vgcreate vg1 /dev/sdb
> 
>    # lvcreate --size=500M --name=lv1 vg1
> 
>    # lvcreate --size=500M --name=lv2 vg1
> 
>    # dd if=/dev/zero of=/dev/mapper/vg1-lv2 bs=4096 count=1
> 
>    # echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnapshot \
>      /dev/mapper/vg1-lv1 /dev/mapper/vg1-lv2 16 0 mikulas 0\
> 	 | dmsetup create ms
> 
>    # dmsetup message /dev/mapper/ms 0 create

dmsetup suspend ms
dmsetup resume ms

>    # echo 0 `blockdev --getsize /dev/mapper/vg1-lv1` multisnap-snap \
>      /dev/mapper/vg1-lv1 0 | dmsetup create ms0
> 
> At this point I got the next error:
> device-mapper: reload ioctl failed: No such file or directory
> Command failed
> 
> And these lines appeared in dmesg:
> [ 6876.506623] device-mapper: table: 252:3: multisnap-snap: Snapshot with this id doesn't exist
> [ 6876.506629] device-mapper: ioctl: error adding target to table
> 
> Could you check all the steps I performed right and what could cause
> those error messages?
> 
> -- 
> Best wishes,
> Mikhail Klepachevskyy

But rather, you could use userspace support for shared snapshots, it makes 
the use much easier, you can use lvcreate, lvremove, lvresize commands:

for lvm-2.02.54: 
http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.02.54/
for lvm-2.02.60:
http://people.redhat.com/mpatocka/patches/userspace/new-snapshots/lvm-2.02.60/
for lvm-2.02.62:
http://people.redhat.com/msnitzer/patches/multisnap/lvm2/LVM2-2.02.62/

Mikulas
