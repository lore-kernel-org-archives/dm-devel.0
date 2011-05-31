From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] block: Move non-rotational flag to queue limits
Date: Tue, 31 May 2011 08:49:13 -0400
Message-ID: <20110531124913.GB12679@redhat.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
 <1306464169-4291-3-git-send-email-martin.petersen@oracle.com>
 <20110527130248.GA17219@redhat.com>
 <yq1k4d7zk56.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1k4d7zk56.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, msb@chromium.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 30 2011 at 10:19pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> blk_queue_nonrot vs blk_queue_non_rotational lends itself to a
> Mike> small amount of confusion.
> 
> Yeah, I just didn't feel like mucking with the existing call. But it
> looks like there are only a handful of users.
> 
> 
> Mike> What about:
> Mike>  s/blk_queue_nonrot/blk_queue_non_rotational/
> Mike>  s/blk_queue_non_rotational/blk_queue_set_non_rotational/
> Mike> ?
> 
> Most of our other block layer calls take the form blk_queue_max_foo()
> for setting foo and {bdev,queue}_max_foo() for querying.
> 
> So I guess the most appropriate thing to do would be to do something
> like this?
> 
> 
> block: Move non-rotational flag to queue limits
> 
> To avoid special-casing the non-rotational flag when stacking it is
> moved from the queue flags to be part of the queue limits. This allows
> us to handle it like the remaining I/O topology information.
> 
> Also rename blk_queue_nonrot() to be consistent with block layer calling
> conventions.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
