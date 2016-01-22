From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: I/O block when removing thin device on the same pool
Date: Fri, 22 Jan 2016 14:58:07 +0100
Message-ID: <56A2356F.2040705@redhat.com>
References: <CAKTMprME2=oCyjxNxLPsXcgSsAzcBW2-dLjjN1CNPAPe0w-bow@mail.gmail.com>
	<569F6F08.1040503@redhat.com>
	<CAJFSNy4yT_8j8Jqm7qggzNgeHLOE0db6dwUxrn1auH_W=sMscA@mail.gmail.com>
	<20160121194405.GA22766@redhat.com>
	<20160122133828.GN26774@soda.linbit>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160122133828.GN26774@soda.linbit>
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

Dne 22.1.2016 v 14:38 Lars Ellenberg napsal(a):
> On Thu, Jan 21, 2016 at 02:44:06PM -0500, Mike Snitzer wrote:
>>>> Dne 20.1.2016 v 11:05 Dennis Yang napsal(a):
>>>>>
>>>>> Hi,
>>>>>
>>>>> I had noticed that I/O requests to one thin device will be blocked
>>>>> when the other thin device is being deleting. The root cause of this
>>>>> is that to delete a thin device will eventually call dm_btree_del()
>>>>> which is a slow function and can block. This means that the device
>>>>> deleting process will need to hold the pool lock for a very long time
>>>>> to wait for this function to delete the whole data mapping subtree.
>>>>> Since I/O to the devices on the same pool needs to held the same pool
>>>>> lock to lookup/insert/delete data mapping, all I/O will be blocked
>>>>> until the delete process finish.
>>>>>
>>>>> For now, I have to discard all the mappings of a thin device before
>>>>> deleting it to prevent I/O from being blocked. Since these discard
>>>>> requests not only take lots of time to finish but hurt the pool I/O
>>>>> throughput, I am still looking for other better solutions to fix this
>>>>> issue.
>>>>>
>>>>> I think the main problem is still the big pool lock in dm-thin which
>>>>> hurts both the scalability and performance of. I am wondering if there
>>>>> is any plan on improving this or any better fix for the I/O block
>>>>> problem.
>>
>> Just so I'm aware: which kernel are you using?
>>
>> dm_pool_delete_thin_device() takes pmd->root_lock so yes it is very
>> coarse-grained; especially when you consider concurrent IO to another
>> thin device from the same pool will call interfaces, like
>> dm_thin_find_block(), which also take the same pmd->root_lock.
>
> We have seen lvremove of thin snapshots sometimes minutes,
> even ~20 minutes before.
> So that means blocking IO to other devices in that pool
> (e.g. the typically currently in-use "origin") for minutes.
>
> That was, iirc, with ~10 TB origin, mostly allocated,
> tens of "rotating" snapshots, 64k chunk size,
> and considerable random write change rate on the origin.
>
> I'd like to propose a different approach for lvremove of thin devices
> (using "made up terms" instead of the correct device mapper vocabulary,
> because I'm lazy):
> on lvremove of a thin device, take all the locks you need,
> even if that implies blocking IO to other devices,
> BUT
> then don't do all the "delete" right there while holding those
> locks, but convert the device into a "i-am-currently-removing-myself"
> target, and release all the locks. That should be fast (enough).
>
> Then this "i-am-currently-removing-myself" target would have its .open()
> return some error, so it cannot even be opened anymore (or something
> with similar effect), start some kernel thread that does the actual
> "wipe" and "unref/unmap" from the tree and all that stuff "in the
> background", using much finer granular temporary locking for each
> processed region.
>
> If that then takes 20 minutes, someone may still care, but at least it
> does not block IO to the other active devices in the pool.
>
> Or is something like this already going on?
>

Hi

Please always specify kernel in-use.
Eventually retry with last officially released one (e.g. 4.4)
There were number of improvements in speed of discard.

Also - you may try to use thin-pool with '--discards  nopassdown'
(or even ignore) in case TRIM is very limiting factor
(with impacting free space in thin-pool for 'ignore' one)

Zdenek
