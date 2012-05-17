From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: dm thin: commit pool's metadata on last close of
	thin device
Date: Thu, 17 May 2012 09:44:00 +0200
Message-ID: <4FB4AC40.1060201@redhat.com>
References: <1337206793-30658-1-git-send-email-snitzer@redhat.com>
	<Pine.LNX.4.64.1205162033500.12442@file.rdu.redhat.com>
	<20120517040007.GA32219@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120517040007.GA32219@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Edward Thornber <thornber@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Dne 17.5.2012 06:00, Mike Snitzer napsal(a):
> On Wed, May 16 2012 at  8:43pm -0400,
> Mikulas Patocka<mpatocka@redhat.com>  wrote:
>
>>
>>
>> On Wed, 16 May 2012, Mike Snitzer wrote:
>>
>>> Reinstate dm_flush_all and dm_table_flush_all.  dm_blk_close will
>>> now trigger the .flush method of all targets within a table on the last
>>> close of a DM device.
>>>
>>> In the case of the thin target, the thin_flush method will commit the
>>> backing pool's metadata.
>>>
>>> Doing so avoids a deadlock that has been observed with the following
>>> sequence (as can be triggered via "dmsetup remove_all"):
>>> - IO is issued to a thin device, thin device is closed
>>> - pool's metadata device is suspended before the pool is
>>> - because the pool still has outstanding IO we deadlock because the
>>>    pool's metadata device is suspended
>>>
>>> Signed-off-by: Mike Snitzer<snitzer@redhat.com>
>>> Cc: stable@vger.kernel.org
>>
>> I'd say --- don't do this sequence.
>>
>> Device mapper generally expects that devices are suspended top-down ---
>> i.e. you should first suspend the thin device and then suspend its
>> underlying data and metadata device. If you violate this sequence and
>> suspend bottom-up, you get deadlocks.
>>
>> For example, if dm-mirror is resynchronizing and you suspend the
>> underlying leg or log volume and then suspend dm-mirror, you get a
>> deadlock.
>>
>> If dm-snapshot is merging and you suspend the underlying snapshot or
>> origin volume and then suspend snapshot-merget target, you get a deadlock.
>>
>> These are not bugs in dm-mirror or dm-snapshot, this is expected behavior.
>> Userspace shouldn't do any bottom-up suspend sequence.
>>
>> In the same sense, if you suspend the underlying data or metadata pool and
>> then suspend dm-thin, you get a deadlock too. Fix userspace so that it
>> doesn't do it.
>
> Yeah, I agree.  I told Zdenek it'd be best to just not do it.
>
> 'dmsetup remove_all' is a dumb command that invites these deadlocks when
> more sophisticated stacking is being used.
>
> But all said, in general I don't have a problem with triggering a target
> specific "flush" on device close.
>
> (Though the implementation of thin_flush could be made more
> intelligent... as is we can see a pretty good storm of redundant
> metadata commits if 100s of thin devices are closed simultaneously --
> creating pmd->root_lock write lock contention).


I'd say it differently - the question here is whether we really want to 
support forced removal of devices or we keep them stuck in the system.

The system must expect that device become unavailable anytime (hw fault),
and if the device is not mounted and unused, it should not be a problem to
remove such device (even suspended).

However current code basically removes thinpool target (has open count 0),
but keeps data and metadata devices  (the problem is worse, if the metadata 
device is replaced with error target in this moment).

Also not - there is not a problem in userspace code as such (except the case 
of discardless devices - where the change is simple quite unexpected new 
behavior of device table, thus older tools cannot work properly with it).
The error is technically in the 'teardown' code for the test case - which
used to assume that something with open count 0 could be easily removed - and 
unremovable targets might be replaced with error targets (so underlying devs 
could be detached as well) - however with current thinp target, we are in
some troubles and I'd like to see them behaving like all other dm targets.

Zdenek
