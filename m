From: Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 06/26] block: Add bio_end_sector()
Date: Tue, 25 Sep 2012 13:54:52 +0200
Message-ID: <20120925115452.GF8143@soda.linbit>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
	<1348526106-17074-7-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1348526106-17074-7-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-dev>
List-Post: <mailto:drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-dev>,
	<mailto:drbd-dev-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-dev-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <chris.mason-5c4llco8/ftWk0Htik3J/w@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 24, 2012 at 03:34:46PM -0700, Kent Overstreet wrote:
> Just a little convenience macro - main reason to add it now is preparing
> for immutable bio vecs, it'll reduce the size of the patch that puts
> bi_sector/bi_size/bi_idx into a struct bvec_iter.


For the DRBD part:

> diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
> index 01b2ac6..d90a1fd 100644
> --- a/drivers/block/drbd/drbd_req.c
> +++ b/drivers/block/drbd/drbd_req.c
> @@ -1144,7 +1144,7 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
>  	/* to make some things easier, force alignment of requests within the
>  	 * granularity of our hash tables */
>  	s_enr = bio->bi_sector >> HT_SHIFT;
> -	e_enr = bio->bi_size ? (bio->bi_sector+(bio->bi_size>>9)-1) >> HT_SHIFT : s_enr;
> +	e_enr = (bio_end_sector(bio) - 1) >> HT_SHIFT;

You ignored the bio->bi_size ? : ;

#define bio_end_sector(bio)	((bio)->bi_sector + bio_sectors(bio))
which turns out (bio->bi_sector + (bio->bi_size >> 9))

Note that bi_size may be 0, bio_end_sector(bio)-1 then is bi_sector -1,
for an empty flush with bi_sector == 0, this ends up as (sector_t)-1ULL,
and this code path breaks horribly.


+	e_enr = bio->bi_size ? (bio_end_sector(bio) - 1) >> HT_SHIFT : s_enr;


Thanks,
	Lars
