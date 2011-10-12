From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] blk-flush: move the queue kick into
 blk_insert_cloned_request
Date: Wed, 12 Oct 2011 15:17:32 -0700
Message-ID: <20111012221732.GH6281@google.com>
References: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
 <1318454562-25291-2-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1318454562-25291-2-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, christophe@saout.de, dm-devel@redhat.com, msnitzer@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 12, 2011 at 05:22:41PM -0400, Jeff Moyer wrote:
> A dm-multipath user reported[1] a problem when trying to boot
> a kernel with commit 4853abaae7e4a2af938115ce9071ef8684fb7af4
> (block: fix flush machinery for stacking drivers with differring
> flush flags) applied.  It turns out that an empty flush request
> can be sent into blk_insert_flush.  When the BUG_ON was fixed
> to allow for this, I/O on the underlying device would stall.  The
> reason is that blk_insert_cloned_request does not kick the queue.
> In the aforementioned commit, I had added a special case to
> kick the queue if data was sent down but the queue flags did
> not require a flush.  A better solution is to push the queue
> kick up into blk_insert_cloned_request.
> 
> This patch, along with a follow-on which fixes the BUG_ON, fixes
> the issue reported.
> 
> [1] http://www.redhat.com/archives/dm-devel/2011-September/msg00154.html
> 
> Reported-by: Christophe Saout <christophe@saout.de>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thank you for fixing this, but one curiosity, what happens for !flush
cloned requests?  Is someone else responsible for kicking the queue?

-- 
tejun
