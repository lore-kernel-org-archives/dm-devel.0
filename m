From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: edits for r16 of shared snapshot patches [was: Re:
 userspace patches for shared snapshots]
Date: Wed, 10 Mar 2010 15:45:14 -0500
Message-ID: <20100310204513.GA29283@redhat.com>
References: <Pine.LNX.4.64.1002101858410.15802@hs20-bc2-1.build.redhat.com>
	<20100225221324.GA29946@redhat.com>
	<Pine.LNX.4.64.1002252327100.29287@hs20-bc2-1.build.redhat.com>
	<20100226211702.GA23893@redhat.com>
	<20100303223740.GA12242@redhat.com>
	<Pine.LNX.4.64.1003040502020.16112@hs20-bc2-1.build.redhat.com>
	<20100304132228.GA20534@redhat.com>
	<20100305174747.GA777@redhat.com>
	<Pine.LNX.4.64.1003090332350.21412@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003090332350.21412@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 09 2010 at  3:41am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > You can see the edits here:
> > http://people.redhat.com/msnitzer/patches/multisnap/kernel/2.6.33/r16a/r16_edits.patch
> > 
> > Boils down to:
> > * use __func__ rather than hardcoding the function name
> >   - this fixed ~3 inconsistencies (incorrect function names) and should
> >     help if/when we do any function renaming in later phases of review
> 
> It consumes one more stack word for every function where this conversion 
> was performed ... I don't know if it's worth it ... likely it doesn't 
> matter.
> 
> The problem here is that GCC is preallocating the space for all outgoing 
> arguments in the function prologue, so if the function has something like 
> this
> if (bug_happened) {
> 	printk("%s: bug happened: %d %d %d %d %d %d %d %d", __func__, a, 
> b, c, d, e, f, g, h, i);
> }
> the whole function always wastes 10 stack words, even if the bug doesn't 
> happen :(
> 
> But that one word because of __func__ maybe doesn't matter (there are much 
> more wasted already in these printks). Or do you think that it's better to 
> not do this __func__ conversion?

I think the use of __func__ reduces the maintenance cost of keeping the
printk updated if the code were to change.  Like I said, I found ~3
remaining function name inconsistencies.  Plus I had already fixed a few
others in my previous large whitespace patch.

Anyway, I understand your point on the extra word associated with using
__func__ but feel using it is more helpful.

Mike
