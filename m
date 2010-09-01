From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/5] dm: implement REQ_FLUSH/FUA support for bio-based dm
Date: Wed, 1 Sep 2010 09:43:43 -0400
Message-ID: <20100901134343.GA25260@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283162296-13650-3-git-send-email-tj@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Aug 30 2010 at  5:58am -0400,
Tejun Heo <tj@kernel.org> wrote:

> This patch converts bio-based dm to support REQ_FLUSH/FUA instead of
> now deprecated REQ_HARDBARRIER.
> 
> * -EOPNOTSUPP handling logic dropped.

Can you expand on _why_ -EOPNOTSUPP handling is no longer needed?  And
please at it to the final patch header.

This removal isn't unique to DM's conversion to FLUSH+FUA but I couldn't
easily find the justification for its removal in the larger 30+ patch
patchset either -- other patches are terse on the removal too.

Other than that.

Acked-by: Mike Snitzer <snitzer@redhat.com>
