From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-thin: don't send discards to shared blocks
Date: Wed, 18 Jul 2012 13:15:22 +0100
Message-ID: <20120718121521.GA5986@ubuntu>
References: <Pine.LNX.4.64.1207161837500.10793@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207161837500.10793@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Ack, but ...

On Mon, Jul 16, 2012 at 06:39:33PM -0400, Mikulas Patocka wrote:
> --- linux-3.5-rc6-fast.orig/drivers/md/dm-thin.c	2012-07-16 21:47:46.000000000 +0200
> +++ linux-3.5-rc6-fast/drivers/md/dm-thin.c	2012-07-17 00:35:25.000000000 +0200
> @@ -1259,7 +1259,10 @@ static void process_discard(struct thin_
>  
>  			cell_release_singleton(cell, bio);
>  			cell_release_singleton(cell2, bio);
> -			remap_and_issue(tc, bio, lookup_result.block);
> +			if ((!lookup_result.shared) & pool->pf.discard_passdown)

... I'd rather a logical && there.

- Joe
