From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] expose dm-stripe target's topology I/O hints
Date: Thu, 27 Aug 2009 14:12:20 +0100
Message-ID: <20090827131220.GN643@agk-dp.fab.redhat.com>
References: <1250864238-4093-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1250864238-4093-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 21, 2009 at 10:17:18AM -0400, Mike Snitzer wrote:
> Add .io_hints to 'struct target_type' to allow the I/O hints portion of
> the 'struct queue_limits' to be set by each target.  Expose dm-stripe
> target's topology I/O hints.
 
Do you still think this should go into 2.6.31?
If so, please supply a revised patch header that explains the benefits
of having the patch (and reference the new stuff in 2.6.31 that it
uses).

> +	limits->io_opt = chunk_size * sc->stripes;

blk_queue_io_opt() ?

>  	.version = {1, 2, 0},

Ought to inc that too when adding a new fn.

> +		/* Set I/O hints portion of queue limits */

Where else are these called I/O hints or is this a new term to define
(or avoid)?

Alasdair
