From: james harvey <jamespharvey20@gmail.com>
Subject: Re: During systemd/udev,
	device-mapper trying to work with non-LVM volumes
Date: Tue, 2 Aug 2016 22:11:31 -0400
Message-ID: <CA+X5Wn6L4kvgOkBx2=M97ni=C-WaZuq0+CiuYv1UJr8ZLu1C0g@mail.gmail.com>
References: <CA+X5Wn5tbL02XpG-JMvZ4-Sdg+sv=yymD1s6Afboag59LqD94Q@mail.gmail.com>
	<4d36f133-5e8f-3e89-9038-5268b7b6f770@redhat.com>
	<CA+X5Wn5nZjyC2qk7yDYkMH+LX6kznjoEcubcMjC7tgN+k5vfbw@mail.gmail.com>
	<3608c518-ab93-c7fd-9dad-49650d234de6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3608c518-ab93-c7fd-9dad-49650d234de6@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, Marian Csontos <mcsontos@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Before I respond to all the other questions, lets clear up the
underlying misunderstanding here.

Maybe I'm missing something, but I think most/all of the responders
are thinking I'm using LVM snapshots.  If I am missing something,
saying "doesn't make sense" or "howto" doesn't really help.  Although
I may not be using LVM in the same way most people use it, I don't see
what instructions I'm violating.  I am NEVER EVER planning on running
LVM snapshots.  I'm NEVER EVER going to run "lvcreate -s".  I know you
can't make block level copies of BTRFS volumes that it can see at
once.  I have NEVER EVER ran "{l,v}gchange".

I want to have thin provisioning with KVM virtual machines.  I'm never
going to use docker, and I'm never going to use snapper on an LVM
snapshot basis, only having it use BTRFS snapshots.

Can't someone use thinly-provisioned LOGICAL volumes, and NEVER EVER
use thinly-provisioned SNAPSHOT volumes?  I've repeatedly said I'm not
using thin-provisioned snapshots.

Isn't the problem running BTRFS on LVM2 when a LVM2-snapshot is made,
that BTRFS gets confused by duplicate signatures?

So, if a user is NEVER EVER going to use LVM2 snapshots, isn't that OK?

/dev/sd{a,b,c}1 3.5G Linux RAID - to be used as /dev/md1 labeled main_boot
/dev/sd{a,b,c}2 3.5G Linux RAID - to be used as /dev/md2 labeled snapper_boot
/dev/sd{a,b,c}3 4.6T Linux LVM
# mdadm --create --name=main_boot --level 1 --metadata=1.0
--raid-devices=3 /dev/md1 /dev/sda1 /dev/sdb1 /dev/sdc1
# mkfs.btrfs --label main_boot /dev/disk/by-id/md-name-main_boot
# mdadm --create --name=snapper_boot --level 1 --metadata=1.0
--raid-devices=3 /dev/md2 /dev/sda2 /dev/sdb2 /dev/sdc2
# mkfs.btrfs --label snapper_boot /dev/disk/by-id/md-name-snapper_boot
# pvcreate /dev/disk/sda3
# vgcreate disk1 /dev/disk/sda3
# pvcreate /dev/disk/sdb3
# vgcreate disk2 /dev/disk/sdb3
# pvcreate /dev/disk/sdc3
# vgcreate disk3 /dev/disk/sdc3
# lvcreate --size 500G --thinpool disk1thin disk1
# lvcreate --size 500G --thinpool disk2thin disk2
# lvcreate --size 500G --thinpool disk3thin disk3
# lvcreate --virtualsize 100G --name main1 disk1/disk1thin
# lvcreate --virtualsize 100G --name main2 disk2/disk2thin
# lvcreate --virtualsize 100G --name main3 disk3/disk3thin
# mkfs.btrfs --label main --metadata raid1 --data raid1
/dev/disk1/main1 /dev/disk2/main2 /dev/disk3/main3

Then install to /dev/disk/by-label/main and using
/dev/disk/by-label/main_boot as its /boot?

Then only using btrfs subvolumes (snapshots) and NEVER EVER running
again ANY lv command having to do with main1/main2/main3?

On Thu, Jul 28, 2016 at 10:12 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> Dne 28.7.2016 v 03:33 james harvey napsal(a):
>>
>> On Wed, Jul 27, 2016 at 2:49 PM, Marian Csontos <mcsontos@redhat.com>
>> wrote:
>>>
>>> On 07/23/2016 01:14 AM, james harvey wrote:
>>>>
>>>>
>>>> If I understand what's going on here, I think device-mapper is trying
>>>> to work with two volumes that don't involve LVM, causing the errors.
>>>
>>>
>>>
>>> If I understand correctly, these volumes DO involve LVM.
>>>
>>> It is not LV on top of your BTRFS volumes, but your BTRFS volumes are on
>>> top
>>> of LVM.
>>
>>
>> I do have some BTRFS volumes on top of LVM, including my 2 root
>> volumes, but my 2 boot partitions don't involve LVM.  They're raw disk
>> partitions - MD RAID 1 - BTRFS.
>>
>> The kernel error references "table: 253:21" and "table: 253:22".
>> These entries are not referred to by running dmsetup.  If these
>> correspond to dm-21 and dm-22, those are the boot volumes that don't
>> involve LVM at all.
>
>
> This doesn't make much sense.
>
> 253:XX are all DM devices -  few lines above you say   boot partitions are
> 'raw disks'  now you say dm-21 & dm-22  are boot volumes ??
>
> LVM is volume manager - LV is DM device (maintained by lvm2 command)
> There is nothing like  lvm2 device - it's always 'dm' device.
>
> lvm2  dm device has   LVM-   prefix in UUID
>
> In your 'dmsetup into -c' output all DM device have this prefix - so
> all your DM device are lvm2  maintained devices.
>
>>
>>> Using BTRFS with thin-shapshots is not a good idea, especially, if you
>>> have
>>> multiple snapshots of btrfs' underlying device active.
>>>
>>> Why are you usingn BTRFS on top of thin-pool?
>>> BTRFS does have snapshots and IMHO you should pick either BTRFS or
>>> thin-pool.
>>
>>
>> I'm not using thin-snapshots, just the thin-provisioning feature.  Is
>
>
> Again doesn't make sense...

Can you say a little more on this?  Just saying it doesn't make sense
gives me no direction.  I understand why many people might like to use
thin-snapshots, but can't a user just use thin-provisioning and NEVER
EVER use the LVM thin-snapshots?

>> running BTRFS in that scenario still a bad situation?  Why's that?
>> I'm going to be using a lot of virtual machines, which is my main
>> reason for wanting thin-provisioning.
>
>
> HOWTO....

Again, just saying I'm doing it wrong doesn't help.

>
>>
>> I'm only using btrfs snapshots.
>>
>>>> Is this a device-mapper bug?  A udev bug?  Something I have configured
>>>> wrong?
>
>
> Seems like 99.99999% wrong configuration....
>
>
>>>
>>> Which distribution?
>>> Kernel, lvm version?
>>
>>
>> Sorry for not mentioning.  Arch, kernel 4.6.4, lvm 2.02.161, device
>> mapper 1.02.131, thin-pool 1.18.0
>>
>>> Ideally run `lvmdump -m` and post output, please.
>>
>>
>> The number of kernel errors during boot that I'm getting seems to be
>> random.  (Probably some type of race condition?)  My original post
>> happened to be that it was using the ones not using LVM, but sometimes
>> it's doing it on LVM backed volumes too.  Occasionally it gives no
>> kernel errors.
>>
>> On this boot, I have these errors:
>>
>> ==========
>> [    3.319387] device-mapper: table: 253:5: thin: Unable to activate
>> thin device while pool is suspended
>> [    3.394258] device-mapper: table: 253:6: thin: Unable to activate
>> thin device while pool is suspended
>> [    3.632259] device-mapper: table: 253:13: thin: Unable to activate
>> thin device while pool is suspended
>> [    3.698752] device-mapper: table: 253:14: thin: Unable to activate
>> thin device while pool is suspended
>> [    4.045282] device-mapper: table: 253:21: thin: Unable to activate
>> thin device while pool is suspended
>> [    4.117778] device-mapper: table: 253:22: thin: Unable to activate
>> thin device while pool is suspended
>> ==========
>>
>
>
> Completely confused about this - are you trying to operate with thin devices
> yourself with some 'dmsetup' commands ?   Eventually using 'docker' ?
> Or maybe you haven configured lockless lvm2, where volumes are activated
> with locking_type==0  ?
>
> Lvm surely doesn't try to activate thinLV from a suspended thin-pool ?
>
> So you really need to expose sequence of command you try to execute - we do
> not have have crystal ball to reverse engineer your wrongly issued commands
> out of kernel error messages -  i.e. is it some 'lvchange/vgchange'
> producing it - then take  '-vvvv' trace out of those commands.
>
> Also -  why do you even mix  btrfs with mdadm & lvm2??
>
> btrfs has it's own solution for raid as well as for volume management.
>
> Combining  'btrfs' and lvm2 snapshot is basically a 'weapon of mass
> destruction'  since  btrfs  has no idea which disk to use when multiple same
> devices with same signature appears in the system.
>
> I'd strongly recommend to read some doc first to get familiar with basic
> bricks of your device stack.
>
> The usage presented in tgz doesn't look like a proper use-case for lvm2 at
> all, and rather a misuse based on misunderstanding how all these
> technologies do work.
>
> Regards
>
> Zdenek
>
