From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v2 19/26] bounce: Refactor __blk_queue_bounce
 to not use bi_io_vec
Date: Thu, 20 Sep 2012 17:29:16 -0700
Message-ID: <20120921002916.GM5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
	<1347322957-25260-20-git-send-email-koverstreet@google.com>
	<20120921002555.GV7264@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120921002555.GV7264@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 20, 2012 at 05:25:55PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Mon, Sep 10, 2012 at 05:22:30PM -0700, Kent Overstreet wrote:
> > A bunch of what __blk_queue_bounce() was doing was problematic for the
> > immutable bvec work; this cleans that up and the code is quite a bit
> > smaller, too.
> > 
> > The __bio_for_each_segment() in copy_to_high_bio_irq() was changed
> > because that one's looping over the original bio, not the bounce bio -
> > since the bounce code doesn't own that bio the __ version wasn't
> > correct.
> 
> I do like the new implementation.  I think the function is broken
> before and after tho.  Allocating from fs_bio_set from block layer is
> never safe and nothing seems to prevent multiple allocators compete in
> the bounce page mempool.  This will need a separate bioset and the
> multiple mempool allocation would have to be put inside a mutex.

Yeah, I should've at least made a note of that.

I should really add "audit all uses of fs_bio_set" to my todo list.

> Also, how was this tested?

Changed queue_bounce_pfn() to return 0, forcing all io to be bounced.
