From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/2] dm: update max_io_len to support a
	split_io that	is not a power of 2
Date: Mon, 30 Apr 2012 19:36:06 +0100
Message-ID: <20120430183606.GC8713@agk-dp.fab.redhat.com>
References: <1335588269-807-1-git-send-email-snitzer@redhat.com>
	<20120430161043.GB8713@agk-dp.fab.redhat.com>
	<20120430172359.GA19033@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120430172359.GA19033@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 30, 2012 at 01:24:00PM -0400, Mike Snitzer wrote:
> On Mon, Apr 30 2012 at 12:10pm -0400,
> Alasdair G Kergon <agk@redhat.com> wrote:
> > On Sat, Apr 28, 2012 at 12:44:28AM -0400, Mike Snitzer wrote:
> > > Required to support a target's use of a non power of 2 blocksize.
> > For which targets?
> striped and thin-pool for starters.
> > (merge_bvec supported?)
> Yes.
 
But there's overlap between merge_bvec and split_io.
  - Why does stripe_merge() have:

        if (!q->merge_bvec_fn)
                return max_size;

    when it's already done the division?

    - Couldn't that be changed to avoid split_io causing a split?
        (Except, as ever, across a table reload, which prevents us
	 removing it completely.)

> I cannot see why we'd need a split_io that is larger than 32 bits -- a
> 32bit split_io can support up to 2TB (2**32 * 512b sectors).  Even
> on a LBD (raid) the stripe size (split_io) will not be so large.
 
But is that enforced in the raid code or not?

> But what I think what you're driving at is: 

(I'm not convinced the proposed patch has been tested on 32-bit+LBD,
attempting to divide by a 64-bit number etc.)

> is there a benefit/reason to
> maintain the old code for some target that won't ever use non power of 2
> split_io (e.g. dm-raid at the moment)?  I see no point for the duality
> in the code but I'm open to the idea if you have a specific reason in
> mind -- are you concerned about perf on more obscure/older hardware?

EITHER the 32 bit split_io *must* be enforced (after we've convinced
ourselves 64 bits will never be required);
OR we keep it 64-bit and add some compat code.

Alasdair
