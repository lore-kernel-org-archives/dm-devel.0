From: Muthu Kumar <muthu.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Tue, 11 Sep 2012 11:36:28 -0700
Message-ID: <CAFR8ued=Le4B4i_Rf4eECXsVgKvce9J7bO9sDSS91PFzBZ6j5w@mail.gmail.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
	<1347055973-11581-3-git-send-email-koverstreet@google.com>
	<20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120910002810.GA23241@moria.home.lan>
	<20120910172210.GC14103@google.com>
	<20120910202435.GG16360@google.com>
	<20120910204010.GA32310@google.com>
	<20120910213349.GH16360@google.com>
	<20120910213710.GA7677@google.com>
	<20120910215633.GA19739@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120910215633.GA19739-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
List-Id: dm-devel.ids

Kent,

On Mon, Sep 10, 2012 at 2:56 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
..
<snip>
..

>
> +static void bio_alloc_rescue(struct work_struct *work)
> +{
> +       struct bio_set *bs = container_of(work, struct bio_set, rescue_work);
> +       struct bio *bio;
> +
> +       while (1) {
> +               spin_lock(&bs->rescue_lock);
> +               bio = bio_list_pop(&bs->rescue_list);
> +               spin_unlock(&bs->rescue_lock);
> +
> +               if (!bio)
> +                       break;
> +
> +               generic_make_request(bio);
> +       }
> +}
> +
> +static void punt_bios_to_rescuer(struct bio_set *bs)
> +{
> +       struct bio_list punt, nopunt;
> +       struct bio *bio;
> +
> +       /*
> +        * In order to guarantee forward progress we must punt only bios that
> +        * were allocated from this bio_set; otherwise, if there was a bio on
> +        * there for a stacking driver higher up in the stack, processing it
> +        * could require allocating bios from this bio_set, and doing that from
> +        * our own rescuer would be bad.
> +        *
> +        * Since bio lists are singly linked, pop them all instead of trying to
> +        * remove from the middle of the list:
> +        */
> +
> +       bio_list_init(&punt);
> +       bio_list_init(&nopunt);
> +
> +       while ((bio = bio_list_pop(current->bio_list)))
> +               bio_list_add(bio->bi_pool == bs ? &punt : &nopunt, bio);
> +
> +       *current->bio_list = nopunt;
> +
> +       spin_lock(&bs->rescue_lock);
> +       bio_list_merge(&bs->rescue_list, &punt);
> +       spin_unlock(&bs->rescue_lock);
> +
> +       queue_work(bs->rescue_workqueue, &bs->rescue_work);
> +}


Does this preserve the CPU from which the bio was submitted
originally. Not familiar with cmwq, may be Tejun can clarify.

Tejun - the question is, do we honor the rq_affinity with the above
rescue worker implementation?

Regards,
Muthu
