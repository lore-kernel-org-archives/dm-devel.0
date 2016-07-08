From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [dm-devel] [RFC] block: fix blk_queue_split() resource	exhaustion
Date: Fri, 8 Jul 2016 15:59:39 +0200
Message-ID: <20160708135939.GX13335@soda.linbit>
References: <1189799501.20160708192424@pvgoran.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1189799501.20160708192424@pvgoran.name>
 <20160708130035.GW13335@soda.linbit>
Sender: linux-bcache-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Fri, Jul 08, 2016 at 07:24:24PM +0600, Pavel Goran wrote:
> Friday, July 8, 2016, 7:00:35 PM, you wrote:
> > On Fri, Jul 08, 2016 at 07:39:36PM +1000, NeilBrown wrote:
> >> I think we just might be in violent agreement.
> 
> > I thought so, too :-)
> 
> > Should I merge both patches,
> > rename to ".queue" and ".tmp",
> > and submit for inclusion?
> 
> Could you please *not* use ".tmp"? I have a feeling it's even worse than "X"
> and "Y". :)
> 
> I suggest to leave it as ".recursion", or maybe use something like
> ".downstream".

"Naming is hard" :-)

.recursion and .queue, then,
because .remainder does no longer fit.

Also, what about "Cc: Stable"?
The patch does not strictly fall into the "stable" rules,
(too many lines...).
But it should go there anyways, I think.
I'll just add those tags, and wait for the heat?

    Lars Ellenberg
