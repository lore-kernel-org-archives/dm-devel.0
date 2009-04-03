From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 14/14] barriers
Date: Fri, 3 Apr 2009 19:01:49 +0100
Message-ID: <20090403180149.GV13664@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0902231422490.23293@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0903270209380.17063@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0903270209380.17063@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 27, 2009 at 02:11:04AM -0400, Mikulas Patocka wrote:
> Barrier support.
 
Queued for linux-next.

> +		else {
> +			int error = dm_flush(md);
> +			if (unlikely(error)) {
> +				bio_endio(c, error);
> +				goto next_bio;
> +			}
> +			if (bio_empty_barrier(c)) {
> +				bio_endio(c, 0);
> +				goto next_bio;
> +			}
> +
> +			__split_and_process_bio(md, c);
> +
> +			error = dm_flush(md);
> +			if (!error && md->barrier_error)
> +				error = md->barrier_error;
> +
> +			if (md->barrier_error != DM_ENDIO_REQUEUE)
> +				bio_endio(c, error);
> +		}
  
I made that a separate function.

Alasdair
-- 
agk@redhat.com
