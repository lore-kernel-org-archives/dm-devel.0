From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Revert "raid5: make release_stripe lockless" because it
 causes test regression
Date: Mon, 25 Nov 2013 11:05:28 +1100
Message-ID: <20131125110528.046b861e@notabene.brown>
References: <alpine.LRH.2.02.1311221502360.28281@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fVz4Xo9pPEYRR6GCbp4pzC4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1311221502360.28281@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, Zdenek Kabelac <zkabelac@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

--Sig_/fVz4Xo9pPEYRR6GCbp4pzC4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Nov 2013 15:07:08 -0500 (EST) Mikulas Patocka
<mpatocka@redhat.com> wrote:

> Revert 773ca82fa1ee58dd1bf88b6a5ca385ec83a2cac6 and
> d265d9dc1d25a69affc21ae9fe5004b9d09c10ef.
>=20
> The lvm testsuite (from=20
> ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.104.tgz) fails with unkillabl=
e=20
> lvm and dmsetup processes on kernel 3.12. The testsuite passes on 3.11.=20
> Bisect shows that the failure is caused by patch=20
> 773ca82fa1ee58dd1bf88b6a5ca385ec83a2cac6. When I revert this patch on 3.1=
2=20
> kernel, the testsuite finishes and there are no unkillable processes.
>=20
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@kernel.org	# 3.12

I certainly don't plan to revert these patches unless we fail to understand
and fix the problem.

Does commit ad4068de49862b083ac2a15bc50689bb30ce3e44 fix the problem?

Thanks,
NeilBrown

>=20
> ---
>  drivers/md/raid5.c |   70 +++-------------------------------------------=
-------
>  drivers/md/raid5.h |    3 --
>  2 files changed, 5 insertions(+), 68 deletions(-)
>=20
> Index: linux-3.12-fast/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.12-fast.orig/drivers/md/raid5.c	2013-11-21 22:45:20.000000000=
 +0100
> +++ linux-3.12-fast/drivers/md/raid5.c	2013-11-21 23:39:01.000000000 +0100
> @@ -293,62 +293,12 @@ static void __release_stripe(struct r5co
>  		do_release_stripe(conf, sh);
>  }
> =20
> -static struct llist_node *llist_reverse_order(struct llist_node *head)
> -{
> -	struct llist_node *new_head =3D NULL;
> -
> -	while (head) {
> -		struct llist_node *tmp =3D head;
> -		head =3D head->next;
> -		tmp->next =3D new_head;
> -		new_head =3D tmp;
> -	}
> -
> -	return new_head;
> -}
> -
> -/* should hold conf->device_lock already */
> -static int release_stripe_list(struct r5conf *conf)
> -{
> -	struct stripe_head *sh;
> -	int count =3D 0;
> -	struct llist_node *head;
> -
> -	head =3D llist_del_all(&conf->released_stripes);
> -	head =3D llist_reverse_order(head);
> -	while (head) {
> -		sh =3D llist_entry(head, struct stripe_head, release_list);
> -		head =3D llist_next(head);
> -		/* sh could be readded after STRIPE_ON_RELEASE_LIST is cleard */
> -		smp_mb();
> -		clear_bit(STRIPE_ON_RELEASE_LIST, &sh->state);
> -		/*
> -		 * Don't worry the bit is set here, because if the bit is set
> -		 * again, the count is always > 1. This is true for
> -		 * STRIPE_ON_UNPLUG_LIST bit too.
> -		 */
> -		__release_stripe(conf, sh);
> -		count++;
> -	}
> -
> -	return count;
> -}
> -
>  static void release_stripe(struct stripe_head *sh)
>  {
>  	struct r5conf *conf =3D sh->raid_conf;
>  	unsigned long flags;
> -	bool wakeup;
> =20
> -	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
> -		goto slow_path;
> -	wakeup =3D llist_add(&sh->release_list, &conf->released_stripes);
> -	if (wakeup)
> -		md_wakeup_thread(conf->mddev->thread);
> -	return;
> -slow_path:
>  	local_irq_save(flags);
> -	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
>  	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
>  		do_release_stripe(conf, sh);
>  		spin_unlock(&conf->device_lock);
> @@ -596,8 +546,7 @@ get_active_stripe(struct r5conf *conf, s
>  			if (atomic_read(&sh->count)) {
>  				BUG_ON(!list_empty(&sh->lru)
>  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> -				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state)
> -				    && !test_bit(STRIPE_ON_RELEASE_LIST, &sh->state));
> +				    && !test_bit(STRIPE_ON_UNPLUG_LIST, &sh->state));
>  			} else {
>  				if (!test_bit(STRIPE_HANDLE, &sh->state))
>  					atomic_inc(&conf->active_stripes);
> @@ -4293,10 +4242,6 @@ static void raid5_unplug(struct blk_plug
>  			 */
>  			smp_mb__before_clear_bit();
>  			clear_bit(STRIPE_ON_UNPLUG_LIST, &sh->state);
> -			/*
> -			 * STRIPE_ON_RELEASE_LIST could be set here. In that
> -			 * case, the count is always > 1 here
> -			 */
>  			__release_stripe(conf, sh);
>  			cnt++;
>  		}
> @@ -5007,13 +4952,11 @@ static void raid5_do_work(struct work_st
>  	handled =3D 0;
>  	spin_lock_irq(&conf->device_lock);
>  	while (1) {
> -		int batch_size, released;
> -
> -		released =3D release_stripe_list(conf);
> +		int batch_size;
> =20
>  		batch_size =3D handle_active_stripes(conf, group_id, worker);
>  		worker->working =3D false;
> -		if (!batch_size && !released)
> +		if (!batch_size)
>  			break;
>  		handled +=3D batch_size;
>  	}
> @@ -5048,9 +4991,7 @@ static void raid5d(struct md_thread *thr
>  	spin_lock_irq(&conf->device_lock);
>  	while (1) {
>  		struct bio *bio;
> -		int batch_size, released;
> -
> -		released =3D release_stripe_list(conf);
> +		int batch_size;
> =20
>  		if (
>  		    !list_empty(&conf->bitmap_list)) {
> @@ -5075,7 +5016,7 @@ static void raid5d(struct md_thread *thr
>  		}
> =20
>  		batch_size =3D handle_active_stripes(conf, ANY_GROUP, NULL);
> -		if (!batch_size && !released)
> +		if (!batch_size)
>  			break;
>  		handled +=3D batch_size;
> =20
> @@ -5503,7 +5444,6 @@ static struct r5conf *setup_conf(struct=20
>  	INIT_LIST_HEAD(&conf->delayed_list);
>  	INIT_LIST_HEAD(&conf->bitmap_list);
>  	INIT_LIST_HEAD(&conf->inactive_list);
> -	init_llist_head(&conf->released_stripes);
>  	atomic_set(&conf->active_stripes, 0);
>  	atomic_set(&conf->preread_active_stripes, 0);
>  	atomic_set(&conf->active_aligned_reads, 0);
> Index: linux-3.12-fast/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-3.12-fast.orig/drivers/md/raid5.h	2013-11-21 23:29:32.000000000=
 +0100
> +++ linux-3.12-fast/drivers/md/raid5.h	2013-11-21 23:29:35.000000000 +0100
> @@ -197,7 +197,6 @@ enum reconstruct_states {
>  struct stripe_head {
>  	struct hlist_node	hash;
>  	struct list_head	lru;	      /* inactive_list or handle_list */
> -	struct llist_node	release_list;
>  	struct r5conf		*raid_conf;
>  	short			generation;	/* increments with every
>  						 * reshape */
> @@ -324,7 +323,6 @@ enum {
>  	STRIPE_OPS_REQ_PENDING,
>  	STRIPE_ON_UNPLUG_LIST,
>  	STRIPE_DISCARD,
> -	STRIPE_ON_RELEASE_LIST,
>  };
> =20
>  /*
> @@ -463,7 +461,6 @@ struct r5conf {
>  	 */
>  	atomic_t		active_stripes;
>  	struct list_head	inactive_list;
> -	struct llist_head	released_stripes;
>  	wait_queue_head_t	wait_for_stripe;
>  	wait_queue_head_t	wait_for_overlap;
>  	int			inactive_blocked;	/* release of inactive stripes blocked,


--Sig_/fVz4Xo9pPEYRR6GCbp4pzC4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUpKUSDnsnt1WYoG5AQKahQ//VXeJLIDTNzK2IFxd3/niQtJAfrtMArUn
0r4NKRRwhgnX897FoiKHwk5LIvEeUXUBR6qnJIEU1uUu7cgF9oFNgvbgYFdcg2IL
6uWt2AmtZQ3MM8/FM3JttrGwiKvKOToKa/Y9hkKflAoK5n1FVAdK8B3GfZGF5frm
FPofC/FjFYn0vkBT2pabzpFTyYxy0Dzfwkh3Oi5vinU0CnoDp8bngvxij4wYnXSl
+atgzPjgChU508Uiqn0xv2IP1mjxhwZbGWPyYnpR5V2xyLXYfYKTwB0jF53VInci
2WZBj2Z9slbIMtsmxTJmhIPhGp4U9cp3Sop0rppaUywYyIu9j8n3x2UqLPOg2Lmu
apucWUCKm/8P7TbMMZHBR3B2iE57OtA+3GCapA3FuoCALX0ORZ3OTxi/R7XZf8CA
0McOUAGNOeIVif99H1O9+WrACUcXmPH9StudYG7+pvtqwaljpDB7Ppm9nTWZpbyv
li661bVVISDW4fzABWcWU2YVEBe8BPItliQbusle2KFDRDnBgTJNtLWdANSGvbvx
VlNpbh7dFqMSjQ5GGhsH5sJm3DRrU6hW8z00pjJ1tmlqeUgEBLdcjCPQsMve5vw0
eC6pBBYGT4XDOwXCvAEGd0UxP0TLFIsh3xxjZRguK/a0a7IKOrPiiQFQXguwYr9F
3tIOR2ttClA=
=AayS
-----END PGP SIGNATURE-----

--Sig_/fVz4Xo9pPEYRR6GCbp4pzC4--
