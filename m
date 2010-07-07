From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] optimize one of the cache flushes
Date: Thu, 8 Jul 2010 00:30:38 +0100
Message-ID: <20100707233038.GK22664@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1007071819070.6578@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007071819070.6578@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jul 07, 2010 at 06:22:24PM -0400, Mikulas Patocka wrote:
>  	if (!bio_empty_barrier(bio)) {
>  		__split_and_process_bio(md, bio);
> -		dm_flush(md);
> +		/*
> +		 * If the request isn't supported, don't waste time with
> +		 * the second flush.
> +		 */
> +		if (md->barrier_error != -EOPNOTSUPP)
> +			dm_flush(md);

Can we safely skip it with any other types of failures there too?
  
Alasdair
