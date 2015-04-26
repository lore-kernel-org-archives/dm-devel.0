From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block,
	dm: don't copy bios for request clones
Date: Sun, 26 Apr 2015 09:35:09 -0400
Message-ID: <20150426133509.GA2471@redhat.com>
References: <1429957432-20672-1-git-send-email-hch@lst.de>
	<553BD948.5040302@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <553BD948.5040302@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Apr 25 2015 at  2:13pm -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 04/25/2015 12:23 PM, Christoph Hellwig wrote:
> > Currently dm-multipath has to clone the bios for every request sent
> > to the lower devices, which wastes cpu cycles and ties down memory.
> > 
> > This patch instead adds a new REQ_CLONE flag that instructs req_bio_endio
> > to not complete bios attached to a request, which we set on clone
> > requests similar to bios in a flush sequence.  With this change I/O
> > errors on a path failure only get propagated to dm-multipath, which
> > can then either resubmit the I/O or complete the bios on the original
> > request.
> > 
> Hehe.
> 
> I seem to remember having sent a similar patch about a year ago;
> which then got shot down due to the missing partial completion
> handling.

But your approch was entirely different and _not_ acceptable considering
it completely eliminated request cloning.  In the context of blk-mq we
need the request to be allocated directly from the blk-mq device --
"cloning" allows enough indirection to make that workable (as has
already landed upstream).

And based on discussion that hch, Jens and I had at LSF eliminating the
cloning of a request's bios was very much a near term goal.  I even
forecast as much in this commit 022333427 ("dm: optimize dm_mq_queue_rq
to _not_ use kthread if using pure blk-mq"):
 "In the future the bioset allocations will hopefully go away (by
  removing support for partial completions of bios in a cloned request)."

> > I've done some basic testing of this on a Linux target with ALUA support,
> > and it survives path failures during I/O nicely.
> > 
> So did I ...
> 
> Anyway; we've discussed this at LSF in Boston, haven't we?
> AFAICR we've found that having to resubmit the entire command
> in the case of partial completion is okay with the storage
> vendors, so this patch is a viable way of handling things.
> 
> _But_ I really would like to have a consensus here that this
> _is_ the correct way of handling partial request; because
> if that is the case then we should adopt this strategy
> throughout the SCSI layer (ie in scsi_io_completion())
> and document the fact.
> 
> I really don't like to have two different completion paths;
> we should decide on one way and then use it throughout
> the stack.

Can you elaborate on why DM should be constrained by what SCSI does?
For DM partial completion was more about trapping failures more quickly
(not concerns about command resubmission, etc).
AFAICT there is no reason to impose that both eliminate partial
completion at the same time.  What am I missing?

But if you have consensus from storage vendors that eliminating partial
completion is OK then why not just make it happen?  If you do so for 4.2
then it'll look like we coordinated between DM and SCSI ;)

Mike
