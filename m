From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-integrity: fix inefficient allocation of stack
	space
Date: Thu, 20 Jul 2017 06:45:35 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1707200626380.32226@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1707191122240.2305@file01.intranet.prod.int.rdu2.redhat.com>
	<22895.42876.199753.299282@quad.stoffel.home>
	<20170719190230.GC20480@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170719190230.GC20480@redhat.com>
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
Cc: dm-devel@redhat.com, John Stoffel <john@stoffel.org>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Wed, 19 Jul 2017, Mike Snitzer wrote:

> On Wed, Jul 19 2017 at  2:39pm -0400,
> John Stoffel <john@stoffel.org> wrote:
> 
> > >>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:
> > 
> > Mikulas> When using block size greater than 512 bytes, the dm-integrity target
> > Mikulas> allocates journal space inefficiently, it allocates one entry for each
> > Mikulas> 512-byte chunk of data, fills entries for each block of data and leaves
> > Mikulas> the remaining entries unused. This doesn't cause data corruption, but it
> > Mikulas> causes severe performance degradation.
> > 
> > Mikulas> This patch fixes the journal allocation. As a safety it also
> > Mikulas> adds BUG that fires if the variables representing journal
> > Mikulas> usage get out of sync (it's better to crash than continue and
> > Mikulas> corrupt data, so BUG is justified).
> > 
> > No, I don't agree.  You should lock down the block device(s) using the
> > dm-integrity target, but you should NOT take down the entire system
> > because of this.  Just return a failure up the stack that forces the
> > device into read only mode so that there's a chance to debug this
> > issue.
> > 
> > Using a BUG_ON, especially for code that isn't proven, is just wrong.
> > Do a WARN_ONCE() and then return an error instead.
> 
> I'll remove the BUG_ON from this stable@ fix.

Don't - the BUG will help developers in the future if they break the code. 
It is much easier to debug a BUG than to debug data corruption.

> Mikulas, please have a look at handling the failure more gracefully 
> (maybe like John suggests). In general, there are too many BUG_ON()s in 
> the dm-integrity code.  I let them slide for inclusion but it would 
> probably be a good idea to look at eliminating them and putting the 
> dm-integrity device into "fail mode" in the face of critical errors -- 
> much like dm-thinp and dm-cache has.

It's better to write a void function that calls BUG in case of bug in the 
code than to write a function returning error code, propagate the error 
code to the callers and try to handle the error code. How should the error 
code be handled if memory is already corrupted? In this paper they say 
that half of the code written for Multics was error recovery - 
http://multicians.org/unix.html - I don't want to go down that path and 
write code to handle conditions that can't happen.

> Mike

Mikulas
