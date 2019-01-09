From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH 1/1] dm: add dust target
Date: Wed, 9 Jan 2019 01:03:08 +0000
Message-ID: <BYAPR04MB581645C55BCC328E193D3DBEE78B0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <1546889483-6341-1-git-send-email-bgurney@redhat.com>
	<1546889483-6341-2-git-send-email-bgurney@redhat.com>
	<20190108001049.GM11315@octiron.msp.redhat.com>
	<CAHhmqcSLxihW3L+w=MZ22Z9pbU13MLD7Bn6YQey-u1soFp-KJw@mail.gmail.com>
	<20190108162314.GA16936@redhat.com>
	<CAHhmqcTfKniu1eP+fBwHf4gohOfUaz_cgaC3EUezNauUAk6O-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bryan Gurney <bgurney@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: John Dorminy <jdorminy@redhat.com>, Joe Shimkus <jshimkus@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "tjaskiew@redhat.com" <tjaskiew@redhat.com>, John Pittman <jpittman@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 2019/01/09 4:53, Bryan Gurney wrote:
> On Tue, Jan 8, 2019 at 11:23 AM Mike Snitzer <snitzer@redhat.com> wrote:
>>
>> On Tue, Jan 08 2019 at 10:30am -0500,
>> Bryan Gurney <bgurney@redhat.com> wrote:
>>
>>> On Mon, Jan 7, 2019 at 7:10 PM Benjamin Marzinski <bmarzins@redhat.com> wrote:
>>>>
>>>> On Mon, Jan 07, 2019 at 02:31:23PM -0500, Bryan Gurney wrote:
>>>>> +
>>>>> +static int dust_map_read(struct dust_device *dd, sector_t thisblock,
>>>>> +                      bool fail_read_on_bb)
>>>>> +{
>>>>> +     unsigned long flags;
>>>>> +     struct badblock *bblk;
>>>>> +
>>>>> +     spin_lock_irqsave(&dd->dust_lock, flags);
>>>>> +     bblk = dust_rb_search(&dd->badblocklist, thisblock);
>>>>
>>>> I don't see the benefit of doing dust_rb_search() if fail_read_on_bb
>>>> isn't set. It just slows the read without using the result.
>>>
>>> This is something that I have to admit was unintentional, but I like
>>> it: it keeps the timing consistent between the "enabled" and
>>> "disabled" modes (a.k.a.: the "fail_read_on_bad_block" and "bypass"
>>> modes).
>>>
>>> The primary goal of this target is to be a close simulation of a drive
>>> with bad sectors.  Therefore, it would be good to have a consistent
>>> "seek time" between the two modes.  There could be test cases where a
>>> problem only appears on a "faster" (or "slower") device, but that's
>>> not what this test device is intended to test.
>>>
>>> Considering the above, can we leave this as is?  (I can leave a
>>> comment explaining the desire for timing consistency between the
>>> "enabled" and "disabled" states.)
>>
>> But this extra work isn't "seek time", it is CPU time.  So no, there is
>> no benefit to doing this.
>>
> 
> OK; I will fix it to avoid searching the rbtree if the device is in
> the "disabled" mode.

I agree with Mike here. And considering "seek" time when dealing with bad
sectors emulation does not really matter anyway. Seek happens only once, for the
head to go above the track containing the sector. After that, the command
execution time when a read hits a bad sector is largely dominated by rotational
latency as the disk retries reading the bad sector again and again repeatedly.
That means every read takes one revolution of the platter (8.3 ms on a regular
7200 rpm disk). The total execution time can literally reach seconds for a
single command as the disk goes through different stages of error recovering
procedures (which can succeed, or fail in the end). So even keeping the rbtree
search, you would be very far off a precise emulation.

> 
>>>>> +     if (fail_read_on_bb && bblk) {
>>>>> +             spin_unlock_irqrestore(&dd->dust_lock, flags);
>>>>> +             return DM_MAPIO_KILL;
>>>>> +     }
>>>>> +
>>>>> +     spin_unlock_irqrestore(&dd->dust_lock, flags);
>>>>> +     return DM_MAPIO_REMAPPED;
>>>>> +}
>>>>> +
>>>>> +static int dust_map_write(struct dust_device *dd, sector_t thisblock,
>>>>> +                       bool fail_read_on_bb)
>>>>> +{
>>>>> +     unsigned long flags;
>>>>> +     struct badblock *bblk;
>>>>> +
>>>>> +     spin_lock_irqsave(&dd->dust_lock, flags);
>>>>> +     bblk = dust_rb_search(&dd->badblocklist, thisblock);
>>>>> +
>>>>> +     if (fail_read_on_bb && bblk) {
>>>>
>>>> The same goes for here as well.
>>>
>>> Please see my above comment for dust_map_read().
>>
>> Nope, see above ;)
>>
>>>>> +/*
>>>>> + * Target parameters:
>>>>> + *
>>>>> + * <device_path> <blksz>
>>>>> + *
>>>>> + * device_path: path to the block device
>>>>> + * blksz: block size (valid choices: 512, 4096)
>>>>> + */
>>>>> +static int dust_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>>>> +{
>>>>> +     struct dust_device *dd;
>>>>> +     const char *device_path = argv[0];
>>>>> +     unsigned int blksz;
>>>>> +     unsigned int sect_per_block;
>>>>> +
>>>>> +     if (argc != 2) {
>>>>> +             ti->error = "requires exactly 2 arguments";
>>>>> +             return -EINVAL;
>>>>> +     }
>>>>> +
>>>>> +     if (kstrtouint(argv[1], 10, &blksz) || !blksz) {
>>>>> +             ti->error =
>>>>> +                     "Invalid block size parameter -- please enter 512 or 4096";
>>>>> +             return -EINVAL;
>>>>> +     }
>>>>
>>>> Why check for !blksz above, when the code only allows 512 and 4096? Why
>>>> not just check for those values in the first "if" statement?
>>>>
>>>
>>> This is actually a two-stage check: the first stage checks for
>>> non-numeric input:
>>>
>>> # dmsetup create dust1 --table '0 10483712 dust /dev/vdb1 foo'
>>> stdout:
>>> "device-mapper: reload ioctl on dust1  failed: Invalid argument"
>>> printk:
>>> "kernel: device-mapper: table: 253:2: dust: Invalid block size
>>> parameter -- please enter 512 or 4096"
>>>
>>> ...and the second stage checks for the usable block sizes:
>>>
>>> # dmsetup create dust1 --table '0 10483712 dust /dev/vdb1 520'
>>> stdout:
>>> "device-mapper: reload ioctl on dust1  failed: Invalid argument"
>>> printk:
>>> "kernel: device-mapper: table: 253:2: dust: Invalid block size --
>>> please enter 512 or 4096"
>>>
>>> These different messages help to clarify whether the parameter isn't a
>>> usable integer, or isn't an integer at all.  (Perhaps the message are
>>> a bit too similar).
>>>
>>> Given the above, should there still be a 2-stage check, or should this
>>> be folded into one that simply checks whether blksz is 512 or 4096?
>>
>> I'm fine with it as is, but I have a different concern: why does this
>> target need to override the queue_limits at all?  What is the benefit to
>> rigidly imposing the provided 512 or 4096 bytes for all of
>> {logical_block,physical_block,minimum_io,optimal_io}_size?
>>
> 
> This is a bit of a complex question, which may cover multiple areas.
> I unfortunately don't have as much expertise in the "backend" of the
> original test target code at the heart of dm-dust; I'm still learning
> it as I go.
> 
> On the "frontend": The "bad block list" has a "grain size" of the
> block size of the device (therefore, "block 1" of a 4096-byte block
> device starts at byte offset 4096, while "block 1" of a 512-byte block
> device starts at byte offset 512.)
> 
> There is definitely value in dm-dust emulating a 4K native device, as
> it will help to reproduce bugs.  In the absence of a real device that
> is 4K native, it can be created on top of a 512-byte logical block
> size device to create a "512-byte write detector", of sorts.

I do not understand this statement. If you emulate a 4K phys sector disk on top
of a 512 native disk, emulating the errors based on bad sectors set with a
granularity of 512B do not make sense since the real drive will NEVER report
partially good or bad sectors. The entire 4K is good or it is not. So the
emulation side should only manage 4K entries, regardless of the underlying disk
actual LBA size.

Also please note that these days, most enterprise class disks can have there
sector size changed between 4K and 512B with a low level format operation.
You may want to try that on the disks you have.

> 
> (An early version of dm-dust was actually a reproducer for the commit
> "isofs: reject hardware sector size > 2048 bytes".)
> 
>> If the underlying device is a 4K native device it simply cannot handle
>> 512b IO.  At a minimum you need to verify that the underlying device can
>> even handle 512b IO.
>>
> 
> This specific case is a bug, and I want to fix it.  (During earlier
> testing, I was wondering why it was possible to set up a 512-byte
> dm-dust device on top of a 4K native device.)
> 
> I need to add a check in the "dmsetup create" process, to verify if
> the underlying device's logical_block_size is small enough to handle
> the minimum I/O size.

You may want to check against the physical_block_size, and not the logical. SMR
disks that are 512 e (512B logical and 4K physical) can handle reads in 512B
units but writes have to be 4K. These are exceptions though and kind of breaking
all LBA definitions known to men... This check on the physical_block_size can be
limited to setups where the underlying disk is SMR.


> 
> 
> Thanks,
> 
> Bryan
> 
>> In general, this ability to override the block core's normal limits
>> stacking (based on underlying device capabilities) needs proper
>> justification.
>>
>> Mike
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 


-- 
Damien Le Moal
Western Digital Research
