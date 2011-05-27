From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] block: Move non-rotational flag to queue limits
Date: Fri, 27 May 2011 09:02:49 -0400
Message-ID: <20110527130248.GA17219@redhat.com>
References: <4DDEA689.2090004@fusionio.com>
 <1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
 <1306464169-4291-3-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1306464169-4291-3-git-send-email-martin.petersen@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jaxboe@fusionio.com, msb@chromium.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, May 26 2011 at 10:42pm -0400,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> To avoid special-casing the non-rotational flag when stacking it is
> moved from the queue flags to be part of the queue limits. This allows
> us to handle it like the remaining I/O topology information.

blk_queue_nonrot vs blk_queue_non_rotational lends itself to a small
amount of confusion.

What about:
 s/blk_queue_nonrot/blk_queue_non_rotational/
 s/blk_queue_non_rotational/blk_queue_set_non_rotational/
?

Otherwise, looks great.

Acked-by: Mike Snitzer <snitzer@redhat.com>
