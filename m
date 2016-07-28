From: Marian Csontos <mcsontos@redhat.com>
Subject: Re: During systemd/udev,
 device-mapper trying to work with non-LVM volumes
Date: Thu, 28 Jul 2016 15:13:32 +0200
Message-ID: <a0ddfe76-9f37-d6d8-6b35-9533b5641d6f@redhat.com>
References: <CA+X5Wn5tbL02XpG-JMvZ4-Sdg+sv=yymD1s6Afboag59LqD94Q@mail.gmail.com>
	<4d36f133-5e8f-3e89-9038-5268b7b6f770@redhat.com>
	<CA+X5Wn5nZjyC2qk7yDYkMH+LX6kznjoEcubcMjC7tgN+k5vfbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+X5Wn5nZjyC2qk7yDYkMH+LX6kznjoEcubcMjC7tgN+k5vfbw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: james harvey <jamespharvey20@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 07/28/2016 03:33 AM, james harvey wrote:
> On Wed, Jul 27, 2016 at 2:49 PM, Marian Csontos <mcsontos@redhat.com> wrote:
>> On 07/23/2016 01:14 AM, james harvey wrote:
>>>
>>> If I understand what's going on here, I think device-mapper is trying
>>> to work with two volumes that don't involve LVM, causing the errors.
>>
>>
>> If I understand correctly, these volumes DO involve LVM.
>>
>> It is not LV on top of your BTRFS volumes, but your BTRFS volumes are on top
>> of LVM.
>
> I do have some BTRFS volumes on top of LVM, including my 2 root
> volumes, but my 2 boot partitions don't involve LVM.  They're raw disk
> partitions - MD RAID 1 - BTRFS.
>
> The kernel error references "table: 253:21" and "table: 253:22".
> These entries are not referred to by running dmsetup.  If these
> correspond to dm-21 and dm-22, those are the boot volumes that don't
> involve LVM at all.
>
>> Using BTRFS with thin-shapshots is not a good idea, especially, if you have
>> multiple snapshots of btrfs' underlying device active.
>>
>> Why are you usingn BTRFS on top of thin-pool?
>> BTRFS does have snapshots and IMHO you should pick either BTRFS or
>> thin-pool.
>
> I'm not using thin-snapshots, just the thin-provisioning feature.  Is
> running BTRFS in that scenario still a bad situation?  Why's that?
> I'm going to be using a lot of virtual machines, which is my main
> reason for wanting thin-provisioning.
>
> I'm only using btrfs snapshots.
>
>>> Is this a device-mapper bug?  A udev bug?  Something I have configured
>>> wrong?
>>
>> Hard to say...
>>
>> Which distribution?
>> Kernel, lvm version?
>
> Sorry for not mentioning.  Arch, kernel 4.6.4, lvm 2.02.161, device
> mapper 1.02.131, thin-pool 1.18.0
>
>> Ideally run `lvmdump -m` and post output, please.
>
> The number of kernel errors during boot that I'm getting seems to be
> random.  (Probably some type of race condition?)  My original post
> happened to be that it was using the ones not using LVM, but sometimes
> it's doing it on LVM backed volumes too.  Occasionally it gives no
> kernel errors.
>
> On this boot, I have these errors:
>
> ==========
> [    3.319387] device-mapper: table: 253:5: thin: Unable to activate
> thin device while pool is suspended
> [    3.394258] device-mapper: table: 253:6: thin: Unable to activate
> thin device while pool is suspended
> [    3.632259] device-mapper: table: 253:13: thin: Unable to activate
> thin device while pool is suspended
> [    3.698752] device-mapper: table: 253:14: thin: Unable to activate
> thin device while pool is suspended
> [    4.045282] device-mapper: table: 253:21: thin: Unable to activate
> thin device while pool is suspended
> [    4.117778] device-mapper: table: 253:22: thin: Unable to activate
> thin device while pool is suspended
> ==========
>
> I've attached lvmdump-terra-snapper-2016072803258.tgz created during
> the boot that gave these 6 errors.

James, there is nothing in the logs suggesting any of the devices is not 
DM device.

*_boot devices are "md" devices, (9:{0,1,2})

These are all thin LVs (/disk({1,2,3})-(main|snapper)\1/):

For example 253:5 and 6:

Name                  Maj Min Stat Open Targ Event  UUID 

disk3-main3           253   6 L--w    0    1      0 
LVM-OHvenodGhFiZBRegTTkz6jt26MhoNxmCEdGScUBBGM5Sk6922y7HeBL0OJfOMO4v
disk3-snapper3        253   5 L--w    1    1      0 
LVM-OHvenodGhFiZBRegTTkz6jt26MhoNxmCZ3VcsAUU8fynWzcVnr81EJxpJh3Z8IE9


This looks like an issue with locking, where activation of thin-volume 
is attempted and gets past through locks while while the pool is 
suspended, or that there is something else in the system suspending the 
pool.

This should not normally happen, any chance "locking_type" in 
/etc/lvm/lvm.conf your initramdisk is set to 0 or 5?

May be full journal would help us to see more...

Also these seems to have no effect on running system, as I see in the 
dmsetup outputs all the affected LVs were activated afterwards, or have 
you activated them manually?

-- Martian

>
> I've also attached lvmdump-terra-snapper-2016072812433.tgz created
> during a different boot, that only errors on 253:13 and 253:21.



>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
