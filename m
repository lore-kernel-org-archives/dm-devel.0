From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] additional bio list helpers
Date: Tue, 06 Feb 2007 16:05:24 -0500 (EST)
Message-ID: <20070206.160524.39151213.k-ueda@ct.jp.nec.com>
References: <45C85FBF.7060207@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45C85FBF.7060207@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, breeves@redhat.com
Cc: mauelshagen@redhat.com
List-Id: dm-devel.ids

Hi Bryn,

On Tue, 06 Feb 2007 11:00:15 +0000, "Bryn M. Reeves" <breeves@redhat.com> wrote:
> @@ -33,9 +55,6 @@ static inline void bio_list_add(struct bio_list *bl, struct bio *bio)
>  
>  static inline void bio_list_merge(struct bio_list *bl, struct bio_list *bl2)
>  {
> -	if (!bl2->head)
> -		return;
> -
>  	if (bl->tail)
>  		bl->tail->bi_next = bl2->head;
>  	else

This one breaks the bio_list if bl2 is a empty list.
Probably missed to add like below?
-----------------------------------
+	if (bio_list_empty(bl2))
+		return;
-----------------------------------

Other small comments are below:

> @@ -14,11 +14,33 @@ struct bio_list {
>  	struct bio *tail;
>  };
>  
> +static inline int  bio_list_empty(struct bio_list *bl)
> +{
> +	return bl->head == NULL && bl->tail == NULL;
> +}

I think that bl->tail is always NULL when bl->head is NULL,
unless the bio_list is corrupted.  So no need to check bl->tail.

> +#define bio_for_each(bio, bl) \
> +	for (bio = (bl)->head; bio; bio = bio->bi_next)
> +
> +static inline int bio_list_nr(struct bio_list *bl)
> +{
> +	int i=0;
> +	struct bio *bio;
> +
> +	if(bio_list_empty(bl))
> +		return i;

I think that this check in not needed because it is covered
by bio_for_each() below.

> +	bio_for_each(bio, bl)
> +		i++;
> +	return i;
> +}


> @@ -58,6 +77,40 @@ static inline void bio_list_merge_head(struct bio_list *bl,
>  	bl->head = bl2->head;
>  }
>  
> +static inline void bio_list_join(struct bio_list *bl, struct bio_list *bl2)
> +{
> +	if (bio_list_empty(bl2))
> +		return;
> +
> +	bl2->tail->bi_next = bl->head;
> +	bl->head = bl2->head;
> +
> +	if (!bl->tail)
> +		bl->tail = bl2->tail;
> +}
> +
> +static inline void bio_list_join_init(struct bio_list *bl, struct bio_list *bl2)
> +{
> +	bio_list_join(bl, bl2);
> +	bio_list_init(bl2);
> +}

I think that bio_list_join() is same as existing bio_list_merge_head().

Regards,
Kiyoshi Ueda
