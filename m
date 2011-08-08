From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm crypt: Always disable discard zeroes data flag
Date: Mon, 8 Aug 2011 18:05:28 -0400
Message-ID: <20110808220527.GD10390@redhat.com>
References: <1312840093-4731-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1312840093-4731-1-git-send-email-mbroz@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Aug 08 2011 at  5:48pm -0400,
Milan Broz <mbroz@redhat.com> wrote:

> If optional discard support in dm-crypt is enabled,
> discards requests bypass crypt queue and blocks
> of the underlying device are discarded.
> 
> But for read path, discarded blocks are handled
> as the same as normal ciphertext blocks, thus decrypted.
> 
> So if underlying device announces discarded regions
> return zeroes, dm-crypt must disable this flag because
> after decryption there is just random noise instead of zeroes.
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>
> ---
>  drivers/md/dm-crypt.c         |    1 +
>  drivers/md/dm-table.c         |   19 +++++++++++++++++++
>  include/linux/device-mapper.h |    5 +++++
>  3 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 49da55c..b6ac710 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1698,6 +1698,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	}
>  
>  	ti->num_flush_requests = 1;
> +	ti->discard_zeroes_unsupported = 1;

I'd prefer 'discard_zeroes_data_unsupported'

>  	return 0;
>  
>  bad:
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 61d3e83..5294f29 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1330,6 +1330,22 @@ static bool dm_table_is_nonrot(struct dm_table *t)
>  	return 1;
>  }
>  
> +static bool dm_table_discard_zeroes(struct dm_table *t)

Likewise, dm_table_discard_zeroes_data().

> +{
> +	struct dm_target *ti;
> +	unsigned i = 0;
> +
> +	/* Ensure that all targets supports discard zeroes. */
> +	while (i < dm_table_get_num_targets(t)) {
> +		ti = dm_table_get_target(t, i++);
> +
> +		if (ti->discard_zeroes_unsupported)
> +			return 0;
> +	}
> +
> +	return 1;
> +}
> +
>  void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  			       struct queue_limits *limits)
>  {
> @@ -1357,6 +1373,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	else
>  		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
>  
> +	if (!dm_table_discard_zeroes(t))
> +		q->limits.discard_zeroes_data = 0;
> +
>  	dm_table_set_integrity(t);
>  
>  	/*
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index ba99936..2416cf1 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -208,6 +208,11 @@ struct dm_target {
>  	 * whether or not its underlying devices have support.
>  	 */
>  	unsigned discards_supported:1;
> +
> +	/*
> +	 * Set if this target does not return zeroes on discarded blocks.
> +	 */
> +	unsigned discard_zeroes_unsupported:1;
>  };
>  
>  /* Each target can link one of these into the table */
> -- 
> 1.7.5.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
