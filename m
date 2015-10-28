From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 6/6] dm-stripe: Fix error message
Date: Wed, 28 Oct 2015 15:51:28 -0400
Message-ID: <20151028195128.GA22241@redhat.com>
References: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
	<1445974740-8362-6-git-send-email-kusumi.tomohiro@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1445974740-8362-6-git-send-email-kusumi.tomohiro@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On Tue, Oct 27 2015 at  3:39pm -0400,
Tomohiro Kusumi <kusumi.tomohiro@gmail.com> wrote:

> The meaning of "not divisible by chunk size" has changed after
> d793e684, so the error message here should probably be using
> "Stripe length" since tmp_len is result of width/stripes, but
> not the whole target device size.
> 
> Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
> ---
>  drivers/md/dm-stripe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index 797ddb9..85cb09f 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -127,7 +127,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  
>  	tmp_len = width;
>  	if (sector_div(tmp_len, chunk_size)) {
> -		ti->error = "Target length not divisible by "
> +		ti->error = "Stripe length not divisible by "
>  		    "chunk size";
>  		return -EINVAL;
>  	}

There is no need for this change.  The user-facing error is more
meaningful.  The only input that is being checked here is the specified
target length.

Dropping this patch.
