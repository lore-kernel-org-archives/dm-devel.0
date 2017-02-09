From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] dm-zoned: Zoned block device target
Date: Thu, 9 Feb 2017 10:36:06 +0100
Message-ID: <20170209093606.GA8189@lst.de>
References: <20170209041849.30964-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170209041849.30964-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 09, 2017 at 01:18:49PM +0900, Damien Le Moal wrote:
> +
> +/*
> + * Target BIO completion.
> + */
> +static inline void dmz_bio_end(struct bio *bio, int err)
> +{
> +	struct dm_zone_bioctx *bioctx =
> +		dm_per_bio_data(bio, sizeof(struct dm_zone_bioctx));
> +
> +	if (atomic_dec_and_test(&bioctx->ref)) {

It seems like this could be simplified a bit by using bio_chain
to chain the clones to the original bio.
