From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: Re: Re: trimmable dm-snapshot?
Date: Thu, 22 Oct 2009 19:02:13 -0600
Message-ID: <4AE10095.3040407@filteredperception.org>
References: <4ADFCC0D.6000903@filteredperception.org>	<20091022142050.GB19699@redhat.com>	<4AE0D02A.7070806@filteredperception.org>
	<4AE0D9C0.9050801@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AE0D9C0.9050801@filteredperception.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Douglas McClendon wrote:
> Douglas McClendon wrote:
>> Mike Snitzer wrote:
>>> On Wed, Oct 21 2009 at 11:05pm -0400,
>>> Douglas McClendon <dmc.fedora@filteredperception.org> wrote:
>>>
>>>> Has anyone looked into the idea of dm-snapshots responding
>>>> appropriately to trims from filesystems?
>>>>
>>>> I.e. the efficiency problem of a dm-snapshotted ext filesystem
>>>> having files created and then deleted?  I.e. in such a scenario,
>>>> resources in the cow device end up taken that could be freed if the
>>>> dm layer could efficiently respond to trim notifications by
>>>> discarding any useless exceptions?
>>>>
>>>> I've been poking around pondering whether an offline quick hack
>>>> might be possible with libext2fs and enough knowledge of the on-disk
>>>> persistent snapshot format.  I.e. just walk the exception chunks in
>>>> the cow device, use libext2fs (sufficient? easiest way?) to
>>>> determine whether all the fsblocks/sectors the chunk contains are
>>>> all currently unneeded, and if so reclaiming that space (possibly by
>>>> relocating the last exception. I'm still a distance from truly
>>>> grokking the on-disk format along with the rest of the dm-snapshot
>>>> and exception-store code).
>>>>
>>>> Does any of this make sense?  Been looked at?  Seem like a
>>>> reasonable avenue to pursue?
>>>
>>> The snapshot must faithfully maintain a copy of the origin's data
>>> relative to a particular point in time.  You can't use changes to the
>>> origin (trim or any other change) to delete the exceptions that a
>>> snapshot is already maintaining.  That would invalidate the whole intent
>>> of the snapshot.
>>
>> I wasn't asking about trimmable dm-snapshot-origin devices, only 
>> trimmable[1] dm-snapshot devices.
>>
>> Thinking about snapshot-origin devices, what you say is a valid reason 
>> why such optimization is not remotely easy (or feasible at all).
> 
> Actually, a way you might accomplish a corresponding optimization with 
> dm-snapshot-origin would be this-
> 
> - At filesystem mount time, a sequence of initial discard requests for 
> all unused portions of the filesystem is passed down to the block/dm 
> layer.  Then, the dm-snapshot-origin code would know to never create an 
> exception for a chunk that is a subset of those regions.

Or rather, since dm-snapshot-origins are presumably often created 
against already mounted filesystems, this would have to happen either at 
filesystem mount time, or snapshot-origin creation time.  The latter 
detecting that the origin device is mounted, and then somehow triggering 
the fs layer to send the information which is basically equivalent to 
the sequence of initial discard requests described.  And then of course 
upon unmount, the dm layer would discard it's mask of chunks that it 
doesn't care about.

But again, I'm personally only interested in the dm-snapshot case which 
is much simpler.  A subset of the  target audience for such a feature 
also happens to be well defined and quite large.  I.e. people using 
devicemapper snapshot based persistent liveUSBs (such as fedora-12 and 
soon with my help centos-5.4).  I know there is some probability that 
fedora 13 or 14 may move to unionfs based persistence ala Valerie 
Aurora's work.  However were the aforemention optimization to be 
implemented, the benefits of unionfs for LiveOS cow storage drop 
dramatically (to nothing afaics).

More generally this just seems like an extremely natural interaction of 
the recently developed discard request mechanism and dm-snapshot.  The 
former may have been primarily implemented for SSD performance benefits, 
but it seems that dm-snaphot can benefit greatly as well from the 
general infrastructure of the fs layer exposing this information to the 
lower block layer.

I'd be more than happy to do the legwork and put together the patch, but 
I wouldn't want to do so unless I can get buy in from established 
developers that this is worth doing.

-dmc
