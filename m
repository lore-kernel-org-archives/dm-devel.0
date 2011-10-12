From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] blk-flush: fix invalid BUG_ON in blk_insert_flush
Date: Wed, 12 Oct 2011 15:18:28 -0700
Message-ID: <20111012221828.GI6281@google.com>
References: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
 <1318454562-25291-3-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1318454562-25291-3-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, christophe@saout.de, dm-devel@redhat.com, msnitzer@redhat.com
List-Id: dm-devel.ids

On Wed, Oct 12, 2011 at 05:22:42PM -0400, Jeff Moyer wrote:
> A user reported a regression due to commit
> 4853abaae7e4a2af938115ce9071ef8684fb7af4 (block: fix flush
> machinery for stacking drivers with differring flush flags).
> Part of the problem is that blk_insert_flush required a
> single bio be attached to the request.  In reality, having
> no attached bio is also a valid case, as can be observed with
> an empty flush.
> 
> [1] http://www.redhat.com/archives/dm-devel/2011-September/msg00154.html
> 
> Reported-by: Christophe Saout <christophe@saout.de>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Duplicate SOB's and missing space after '/*' in the comment.  Other
than that,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
