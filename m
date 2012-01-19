From: Spelic <spelic@shiftmail.org>
Subject: Re: Multisnap / dm-thin
Date: Thu, 19 Jan 2012 13:21:06 +0100
Message-ID: <4F180AB2.3060801@shiftmail.org>
References: <4F16A07C.7040705@shiftmail.org> <20120119093343.GB3942@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-reply-to: <20120119093343.GB3942@ubuntu>
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

On 01/19/12 10:33, Joe Thornber wrote:
> On Wed, Jan 18, 2012 at 11:35:40AM +0100, Spelic wrote:
>> Hello all,
>> I would need the multisnap feature, i.e., the ability to make many
>> snapshots without high performance degradation...
>> I saw it mentioned around, but it does not seem to be in the kernel
>> yet. Is it planned to be introduced? Is there an ETA?
>>
>> Note that I am not very fond of the new dm-thin which is planned to
>> have a multisnap-equivalent feature, because of the fragmentation it
>> will cause (I suppose a defragmenter is long way to come). Not
>> having fragmentation is the reason for using blockdevices instead of
>> loop mounted files after all isn't it?
> The point of multisnap is that blocks of data are shared between
> multiple snapshots (unlike the current single snap implementation).
> Saving both disk space, and probably more importantly, redundant
> copying.  As such I struggle to see why you think it's possible to do
> this and keep all the data contiguous.

I would be using only the origin, which should be fully allocated and 
hence fully contiguous.
Snapshots would be backups for me, and readonly. I am not interested in 
the performances on those, I am only interested that their presence does 
not degrade the performances of origin too much (that's important 
otherwise I would see no improvement compared to current LVM 
implementation).

Now that I think of this, I could preallocate everything in your dm-thin 
and hope it comes out contiguous, but explicitly supporting something 
similar to the --contiguous=y of lvm would be much better.
Also, in this sense the discard support in your dm-thin would worsen 
things for me. If you implement it I think it should be possible to 
disable it.

> Both Mikulas' multisnap, and
> my thinp, use btrees to store the metadata, and allocate data blocks
> on a first come first served basis.

Mikulas' multisnap works the same way wrt what I wrote above? Contiguity 
of origin cannot be guaranteed?


> Fragmentation is a big concern; but until I have a good idea what real
> world usage patterns for thinp are I'm a bit short of data to base any
> improvements to the allocator on.  If you want to help I'd love to
> know your usage scenario, and the slow down you're observing as the
> pool ages.

I was using files for VM disk images. Sparse files. Disk performances in 
the VM would be very low at times and I couldn't understand why, until I 
tried to copy one of those files sequentially and I saw even sequential 
read was very low, like less than 80MB/sec when it should have been at 
least 500MB/sec on that array, while other VM images that were fully 
preallocated files this was not a problem. So I moved to LVM contiguous 
devices and this has not been a problem anymore.

> As far as a defragmenter goes.  My first approach will be allowing
> people to set a 'copy-on-read' flag on thin devices that they feel are
> too fragmented.  This will then trigger the current machinery for
> breaking sharing - but reallocating according to the _current_ io
> usage pattern.

I don't get it... if you also allocate a fragment for reads, the end 
result would be more fragmentation and not less...?

> This should be a very small change, when I see
> real world fragmentation, I'll implement it.
>
> Maybe your requirement is for the origin to be a preexisting,
> contiguous device?

Yes!

> In which case see the other discussion thread with
> Ted Tso.

Hmmm I can't seem to be able to find it
I see this thread with Tso
--- Re: [dm-devel] About the thin provision function @ kernel 3.2 or later.
but it seems to talk about a snapshot of an external origin.
Supporting a readonly external origin is easy but it's not what I want.
Supporting a r/w external origin... I don't know how it could ever be 
done since you won't receive notifications of the underlying origin 
changing. Would that be made with a sort of hook points in all device 
types in the kernel?

Seems a big can of worms to go that way just for my use case.
For my use case it would be simpler if there was a way to fully 
preallocate a contiguous origin in thinp, and then the ability to 
disable discard implementation when it gets implemented. Clearly this 
would go against the name "thin".

I don't know if Mikulas's multisnap would be more apt for this.


Another question: is support from userspace (LVM) planned? Is there an 
ETA? Will that be from you or we are waiting for LVM people to pick it up?
Because being just DM it seems a bit hard to use.


Thanks for your explanations and your hard work
S.
