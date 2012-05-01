From: Spelic <spelic@shiftmail.org>
Subject: Re: dm-thin f.req. : SEEK_DATA / SEEK_HOLE / SEEK_DISCARD
Date: Tue, 01 May 2012 17:52:45 +0200
Message-ID: <4FA006CD.3050204@shiftmail.org>
References: <4F9FDCC2.2080905@shiftmail.org> <20120501141023.GA20313@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <20120501141023.GA20313@ubuntu>
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
Cc: Joe Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On 05/01/12 16:10, Joe Thornber wrote:
> On Tue, May 01, 2012 at 02:53:22PM +0200, Spelic wrote:
>> Dear dm-thin developers,
>> I thought that it would be immensely useful to have a SEEK_DATA /
>> SEEK_HOLE implementation for dm-thin and/or even for the older
>> non-thin snapshotting mechanism.
>> This would allow to implement a mechanism like the acclaimed "zfs
>> send" with dm snapshots, i.e. cheaply replicate a thin snapshot
>> remotely once the parent snapshot has been replicated already.
>> Extremely useful imho.
>> Is there any plan to do that?
> I'm planning to do replication via userland.  There's a new message
> that allows userland to access a read-only copy of the metadata.  From
> this, and using some intermediate snapshots we can work out what data
> is changing and replicate it (asynchronously).
>
>> The "HOLE" would mean "data comes from parent snapshot/device",
>> while DATA is "data that has changed since the parent snapshot".
> This sounds like the external snapshots feature that I just added.
> See documentation in latest kernel.

I'm looking at it right now
Well, I was thinking at a parent snapshot and child snapshot (or anyway 
an older and a more recent snapshot of the same device) so I'm not sure 
that's the feature I needed... probably I'm missing something and need 
to study more


>> Another question / feature request: I would like to know if reading
>> an area of a thin device after a discard is guaranteed to return
>> zeroes (and/or can be identified as empty from userspace via a
>> seek_data / seek_hole or equivalent mechanism).
> A great question.  If the discard exactly covers some dm-thin blocks,

I'm not sure I have understood the full nomenclature of dm-thin yet :-) 
... "dm-thin blocks" would be the same thing as so called "pool 
blocksize" as talked in the thread " Re: [PATCH 2/2] dm thin: support 
for non power of 2 pool blocksize" right? so that's customizable now and 
not necessarily in power of 2...

But those are anyway quite big, default is what, 64 megabytes? (which is 
in fact a good thing for preventing excessive fragmentation...)

Now an obvious question:
If userspace sends multiple smaller discards eventually covering the 
whole block, the block will still be unmapped correctly, right?
If yes: so you do preserve the information of what part of the block is 
has already been discarded, and what part is not... so it would be 
possible to return zeroes if the unmapped sub-part of the block is being 
read... right?


> then the mappings will be removed.  Any future io to that block will
> trigger the block to be reprovisioned.

(note: here we are talking of a full block now unmapped, different 
situation from above)
Ok, supposing I do *not* write, so it does not get reprovisioned, what 
does reading from there return; does it return zeroes, or it returns 
nonzero data coming from the parent snapshot at the same offset?



> ...
> As for identifying empty blocks from userland: there is an inherant
> race here.  What would you do with the info?

You are right , I would definitely need to take a snapshot prior to 
reading that... so consider my question related to reading a snapshot of 
a device which has been partially discarded...


Thank you
S.
