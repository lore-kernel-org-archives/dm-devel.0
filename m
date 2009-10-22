From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: Re: Re: trimmable dm-snapshot?
Date: Thu, 22 Oct 2009 16:16:32 -0600
Message-ID: <4AE0D9C0.9050801@filteredperception.org>
References: <4ADFCC0D.6000903@filteredperception.org>	<20091022142050.GB19699@redhat.com>
	<4AE0D02A.7070806@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4AE0D02A.7070806@filteredperception.org>
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
> Mike Snitzer wrote:
>> On Wed, Oct 21 2009 at 11:05pm -0400,
>> Douglas McClendon <dmc.fedora@filteredperception.org> wrote:
>>
>>> Has anyone looked into the idea of dm-snapshots responding
>>> appropriately to trims from filesystems?
>>>
>>> I.e. the efficiency problem of a dm-snapshotted ext filesystem
>>> having files created and then deleted?  I.e. in such a scenario,
>>> resources in the cow device end up taken that could be freed if the
>>> dm layer could efficiently respond to trim notifications by
>>> discarding any useless exceptions?
>>>
>>> I've been poking around pondering whether an offline quick hack
>>> might be possible with libext2fs and enough knowledge of the on-disk
>>> persistent snapshot format.  I.e. just walk the exception chunks in
>>> the cow device, use libext2fs (sufficient? easiest way?) to
>>> determine whether all the fsblocks/sectors the chunk contains are
>>> all currently unneeded, and if so reclaiming that space (possibly by
>>> relocating the last exception. I'm still a distance from truly
>>> grokking the on-disk format along with the rest of the dm-snapshot
>>> and exception-store code).
>>>
>>> Does any of this make sense?  Been looked at?  Seem like a
>>> reasonable avenue to pursue?
>>
>> The snapshot must faithfully maintain a copy of the origin's data
>> relative to a particular point in time.  You can't use changes to the
>> origin (trim or any other change) to delete the exceptions that a
>> snapshot is already maintaining.  That would invalidate the whole intent
>> of the snapshot.
> 
> I wasn't asking about trimmable dm-snapshot-origin devices, only 
> trimmable[1] dm-snapshot devices.
> 
> Thinking about snapshot-origin devices, what you say is a valid reason 
> why such optimization is not remotely easy (or feasible at all).

Actually, a way you might accomplish a corresponding optimization with 
dm-snapshot-origin would be this-

- At filesystem mount time, a sequence of initial discard requests for 
all unused portions of the filesystem is passed down to the block/dm 
layer.  Then, the dm-snapshot-origin code would know to never create an 
exception for a chunk that is a subset of those regions.

-dmc
