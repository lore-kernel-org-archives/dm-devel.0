From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Sat, 20 Jun 2009 17:32:58 -0700
Message-ID: <e9c3a7c20906201732h7ff22c23p26da67f300e08c2c@mail.gmail.com>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org> <1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o> <19000.8388.899607.749942@notabene.brown>
	<19002.60755.876186.489524@notabene.brown>
	<1245407630.12264.66.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1245407630.12264.66.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

On Fri, Jun 19, 2009 at 3:33 AM, Heinz Mauelshagen<heinzm@redhat.com> wro=
te:
> On Fri, 2009-06-19 at 11:43 +1000, Neil Brown wrote:
>> - You have your own 'xor' code against which you do a run-time test of
>> =A0 the 'xor_block' code which md/raid5 uses - then choose the fasted.
>> =A0 This really should not be necessary. =A0If you have xor code that =
runs
>> =A0 faster than anything in xor_block, it really would be best to subm=
it
>> =A0 it for inclusion in the common xor code base.
>
> This is in because it actually shows better performance regularly by
> utilizing cache lines etc. more efficiently (tested on Intel, AMD and
> Sparc).
>
> If xor_block would always have been performed best, I'd dropped that
> optimization already.

Data please.  Especially given the claim that it improves upon the
existing per-architecture hand-tuned assembly routines.  If it is
faster great!  Please send patches to improve the existing code.

>>
>> - You have introduced "dm-message" which is a frame work for sending
>> =A0 messages to dm targets.
>
> dm-message is a parser for messages sent to a device-mapper targets
> message interface. It aims at allowing common message parsing functions
> to be shared between targets.
>
> The message interface in general allows for runtime state changes of
> targets like those you found below.
>
> See "dmsetup message ..."
>
>> It is used for adjusting the cache size,
>> =A0 changing the bandwidth used by resync, and doing things with
>> =A0 statistics. =A0Linux already has a framework for sending messages =
to
>> =A0 kernel objects. =A0It is called "sysfs". =A0It would be much nicer=
 if
>> =A0 you could use that.
>
> Looks to me like heavier to program (I counted ~100 LOC of sysfs define=
s
> and calls in md.c) for 3 files used in md.
>
> That needs some more discussion.

Ironically the same argument can be applied to this module.  ~5000 LOC
to re-implement raid5 seems much "heavier to program" than to write
some dmraid ABI compatibility wrappers around the existing md-raid5
code.

[..]
>> =A0 The problem is that when a drive fails you allow writes to continu=
e
>> =A0 without waiting for the metadata to be updated. =A0I.e. metadata
>> =A0 updates are asynchronous.
>> =A0 The problem scenario for raid5 is:
>> =A0 =A0 - a drive fails while a write is in process
>> =A0 =A0 - the drive is marked as faulty and user space is notified
>> =A0 =A0 - that write, and possibly several others, complete and that
>> =A0 =A0 =A0 status is potentially returned to user-space (e.g. for an =
fsync)
>> =A0 =A0 - user space acts on that status (e.g. sends an acknowledgemen=
t over
>> =A0 =A0 =A0 the network)
>> =A0 =A0 - the host crashes before the metadata update completes
>> =A0 =A0 - on reboot, the drive, which just had a transient failure, wo=
rks
>> =A0 =A0 =A0 fine, and the metadata reports that all the drives are goo=
d, but
>> =A0 =A0 =A0 that the array was active so a parity-resync is needed.
>> =A0 =A0 - All parity blocks are recalculated. =A0However that write we
>> =A0 =A0 =A0 mentioned above is only recorded in the parity block. =A0S=
o that
>> =A0 =A0 =A0 data is lost.
>>
>
> Yes, like in the dm raid1 scenario, blocking of writes would have to
> occur until metadata has been updated in order to detect the failing
> drive persistently, hence not updating parity (which contains data
> mandatory to preserve) but recalculating chunks on the transiently
> failing drive utilizing intact parity.

Another problem with dm along these lines is the mechanism for
notifying userspace, I am assuming this is still via uevents?  The
problem is that each notification requires a memory allocation which
might fail under load, especially if the blocked array is in the dirty
page write out path.  The userspace notifications and failed device
handling in md are designed to not require memory allocations.

[..]
>> =A0 Also it does not take account of IO to other partitions on a devic=
e.
>> =A0 It is common to have a number of different arrays on the same devi=
ce
>> =A0 set. =A0You really want to resync to back off based on IO to all o=
f
>> =A0 the device, not just to the array.
>
> Does MD RAID > 0 cope with that in multi-partition RAID configs ?
> E.g.:
> disk1:part1+disk2:part1 -> md0 and disk1:part2+disk2:part2 -> md1 with
> global iostats for disk[12] ?

By default it will hold off resync on other arrays when it notices
that multiple arrays share disks.  A sysfs knob allows parallel
resync.

[..]
>> =A0 As I said, I would rather this didn't exist.
>
> I think its better to offer options to be utilized for different
> purposes. Tradeoff is always (some) overlap.
>
> We don't have one filesystem for all use cases ;-)

That argument does not fly in this case.  md is already suitable for
the dmraid use case (i.e kernel raid/userspace metadata).

>> But it could be
>> =A0 emulated (except for the statistics) if needed - md can already
>> =A0 adjust resync speed and cache size.
>>
>>
>> =A0What is missing is agreement on how to handle synchronous metadata
>> =A0updates. =A0md waits for the drive failure to be acknowledged. =A0I=
t is
>> =A0automatically marked as 'Blocked' on an error, and user-space must
>> =A0clear that flag.
>
> Yes, Mikulas already put thought into that.
> Let's allow him /and others) to join in.
>
>
>>
>> =A0I suspect, using your model, the approach would be a 'dm-message'
>> =A0acknowledging that a given device is faulty. =A0I would, of course,
>> =A0rather this be done via sysfs.
>>
>> =A0I will try to look at factoring out the md specific part of md/raid=
5
>> =A0over the next few days (maybe next week) and see how that looks.
>
> That'll be interesting to see how it fits into the device-mapper
> framework
>

Yes, kernel ABI compatibility is the better [1] way to go.  I will
also revive the ideas/patches I had along these lines.

Regards,
Dan

[1]: ...than dm2md in userspace
