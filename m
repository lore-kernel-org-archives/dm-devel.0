From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: [dm-devel] [PATCH v2 1/1] block: fix blk_queue_split() resource
 exhaustion
Date: Tue, 12 Jul 2016 19:18:58 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1607121834220.16228@mail.ewheeler.net>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com> <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com> <20160711141042.GY13335@soda.linbit> <87lh17efap.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lh17efap.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Tue, 12 Jul 2016, NeilBrown wrote:

> On Tue, Jul 12 2016, Lars Ellenberg wrote:
> ....
> >
> > Instead, I suggest to distinguish between recursive calls to
> > generic_make_request(), and pushing back the remainder part in
> > blk_queue_split(), by pointing current->bio_lists to a
> > 	struct recursion_to_iteration_bio_lists {
> > 		struct bio_list recursion;
> > 		struct bio_list queue;
> > 	}
> >
> > By providing each q->make_request_fn() with an empty "recursion"
> > bio_list, then merging any recursively submitted bios to the
> > head of the "queue" list, we can make the recursion-to-iteration
> > logic in generic_make_request() process deepest level bios first,
> > and "sibling" bios of the same level in "natural" order.
> >
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > Signed-off-by: Roland Kammerer <roland.kammerer@linbit.com>
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> 
> Thanks again for doing this - I think this is a very significant
> improvement and could allow other simplifications.

Thank you Lars for all of this work!  

It seems like there have been many 4.3+ blockdev stacking issues and this 
will certainly address some of those (maybe all of them?).  (I think we 
hit this while trying drbd in 4.4 so we dropped back to 4.1 without 
issue.)  It would be great to hear 4.4.y stable pick this up if 
compatible.


Do you believe that this patch would solve any of the proposals by others 
since 4.3 related to bio splitting/large bios?  I've been collecting a 
list, none of which appear have landed yet as of 4.7-rc7 (but correct me 
if I'm wrong):

A.  [PATCH v2] block: make sure big bio is splitted into at most 256 bvecs
	by Ming Lei: https://patchwork.kernel.org/patch/9169483/

B.  block: don't make BLK_DEF_MAX_SECTORS too big
	by Shaohua Li: http://www.spinics.net/lists/linux-bcache/msg03525.html

C.  [1/3] block: flush queued bios when process blocks to avoid deadlock
	by Mikulas Patocka: https://patchwork.kernel.org/patch/9204125/
		(was https://patchwork.kernel.org/patch/7398411/)

D.  dm-crypt: Fix error with too large bios
	by Mikulas Patocka: https://patchwork.kernel.org/patch/9138595/

The A,B,D are known to fix large bio issues when stacking dm+bcache 
(though the B,D are trivial and probably necessary even with your patch).

Patch C was mentioned earlier in this thread by Mike Snitzer and you 
commented briefly that his patch might solve the issue; given that, and in 
the interest of minimizing duplicate effort, which of the following best 
describes the situation?

  1. Your patch could supersede Mikulas's patch; they address the same 
issue.

  2. Mikulas's patch addresses different issues such and both patches 
should be applied.

  3. There is overlap between both your patch and Mikulas's such that both 
#1,#2 are true and effort to solve this has been duplicated.


If #3, then what might be done to resolve the overlap?

What are the opinions of the authors and can a consensus be reached so we 
can see these pushed upstream with the appropriate stable Cc tags and 
ultimately fix 4.4.y?


--
Eric Wheeler
