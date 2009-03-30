From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] Handle multipath paths in a path group
	properly during pg_init
Date: Mon, 30 Mar 2009 15:14:24 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4668F3539@cosmail01.lsi.com>
References: <1238436452.5858.2.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1238436452.5858.2.camel@chandra-ubuntu>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, dm-devel <dm-devel@redhat.com>
Cc: Anderson <andmike@us.ibm.com>, Mike, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


Reviewed and Tested-by: Babu Moger <babu.moger@lsi.com>

> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Monday, March 30, 2009 1:08 PM
> To: dm-devel
> Cc: Alasdair G Kergon; Moger, Babu; Hannes Reinecke; Mike Anderson
> Subject: [PATCH] Handle multipath paths in a path group properly during
> pg_init
>=20
> Resending the patch to get in patchwork...
> -------
> The problem reported by Moger Babu was caused due to the architectural
> change made when we moved from dm hardware handler to SCSI hardware
> handler.
>=20
> Thanks Babu for finding and reporting the bug.
>=20
> All of the hardware handlers, do have a state now, and they are set to
> active and (some form of) inactive. All of them have prep_fn, which use
> this "state" to fail the I/O without it ever being sent to the device.
>=20
> As Babu has noted in his email, the pg_init/activate is sent on only on=
e
> path and the "state" of that path is changed appropriately to "active"
> while other paths in the same path group are never changed as they neve=
r
> got an "activate".
>=20
> Attached is a patch (compiled, tested, but not clean yet), which makes
> changes in the dm-multipath layer to send an "activate" on each paths i=
n
> the path groups.
>=20
> Mike (Anderson) and I had a discussion about whether to implement this
> in the dm-mulitpath layer or in the SCSI hardware handler layer and we
> came to a conclusion that it is best suited to be in the dm-mulitpath
> layer as it is the one that knows the relationship between different
> paths.
>=20
> If it were to be done at the Hardware handler layer, then the hardware
> handler may end up having a different notion of the path relationship
> and hence may not work as expected by the dm-multipath layer.
>=20
> This patch has been tested by Hannes in EMC storage. Babu and I tested =
it
> in LSI storage.
> ----------
>=20
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
>=20
> ---
> Index: linux-2.6.29/drivers/md/dm-mpath.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.29.orig/drivers/md/dm-mpath.c
> +++ linux-2.6.29/drivers/md/dm-mpath.c
> @@ -36,6 +36,7 @@ struct pgpath {
>=20
>  	struct dm_path path;
>  	struct work_struct deactivate_path;
> +	struct work_struct activate_path;
>  };
>=20
>  #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, pat=
h)
> @@ -65,8 +66,6 @@ struct multipath {
>  	spinlock_t lock;
>=20
>  	const char *hw_handler_name;
> -	struct work_struct activate_path;
> -	struct pgpath *pgpath_to_activate;
>  	unsigned nr_priority_groups;
>  	struct list_head priority_groups;
>  	unsigned pg_init_required;	/* pg_init needs calling? */
> @@ -129,6 +128,7 @@ static struct pgpath *alloc_pgpath(void)
>  	if (pgpath) {
>  		pgpath->is_active =3D 1;
>  		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
> +		INIT_WORK(&pgpath->activate_path, activate_path);
>  	}
>=20
>  	return pgpath;
> @@ -170,10 +170,6 @@ static void free_pgpaths(struct list_hea
>  		if (m->hw_handler_name)
>  			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
>  		dm_put_device(ti, pgpath->path.dev);
> -		spin_lock_irqsave(&m->lock, flags);
> -		if (m->pgpath_to_activate =3D=3D pgpath)
> -			m->pgpath_to_activate =3D NULL;
> -		spin_unlock_irqrestore(&m->lock, flags);
>  		free_pgpath(pgpath);
>  	}
>  }
> @@ -203,7 +199,6 @@ static struct multipath *alloc_multipath
>  		m->queue_io =3D 1;
>  		INIT_WORK(&m->process_queued_ios, process_queued_ios);
>  		INIT_WORK(&m->trigger_event, trigger_event);
> -		INIT_WORK(&m->activate_path, activate_path);
>  		m->mpio_pool =3D mempool_create_slab_pool(MIN_IOS, _mpio_cache);
>  		if (!m->mpio_pool) {
>  			kfree(m);
> @@ -428,8 +423,8 @@ static void process_queued_ios(struct wo
>  {
>  	struct multipath *m =3D
>  		container_of(work, struct multipath, process_queued_ios);
> -	struct pgpath *pgpath =3D NULL;
> -	unsigned init_required =3D 0, must_queue =3D 1;
> +	struct pgpath *pgpath =3D NULL, *tmp;
> +	unsigned must_queue =3D 1;
>  	unsigned long flags;
>=20
>  	spin_lock_irqsave(&m->lock, flags);
> @@ -447,19 +442,15 @@ static void process_queued_ios(struct wo
>  		must_queue =3D 0;
>=20
>  	if (m->pg_init_required && !m->pg_init_in_progress && pgpath) {
> -		m->pgpath_to_activate =3D pgpath;
>  		m->pg_init_count++;
>  		m->pg_init_required =3D 0;
> -		m->pg_init_in_progress =3D 1;
> -		init_required =3D 1;
> +		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
> +			queue_work(kmpath_handlerd, &tmp->activate_path);
> +			m->pg_init_in_progress++;
> +		}
>  	}
> -
>  out:
>  	spin_unlock_irqrestore(&m->lock, flags);
> -
> -	if (init_required)
> -		queue_work(kmpath_handlerd, &m->activate_path);
> -
>  	if (!must_queue)
>  		dispatch_queued_ios(m);
>  }
> @@ -1111,27 +1102,20 @@ static void pg_init_done(struct dm_path
>  		pg->bypassed =3D 0;
>  	}
>=20
> -	m->pg_init_in_progress =3D 0;
> -	queue_work(kmultipathd, &m->process_queued_ios);
> +	m->pg_init_in_progress--;
> +	if (!m->pg_init_in_progress)
> +		queue_work(kmultipathd, &m->process_queued_ios);
>  	spin_unlock_irqrestore(&m->lock, flags);
>  }
>=20
>  static void activate_path(struct work_struct *work)
>  {
>  	int ret;
> -	struct multipath *m =3D
> -		container_of(work, struct multipath, activate_path);
> -	struct dm_path *path;
> -	unsigned long flags;
> +	struct pgpath *pgpath =3D
> +		container_of(work, struct pgpath, activate_path);
>=20
> -	spin_lock_irqsave(&m->lock, flags);
> -	path =3D &m->pgpath_to_activate->path;
> -	m->pgpath_to_activate =3D NULL;
> -	spin_unlock_irqrestore(&m->lock, flags);
> -	if (!path)
> -		return;
> -	ret =3D scsi_dh_activate(bdev_get_queue(path->dev->bdev));
> -	pg_init_done(path, ret);
> +	ret =3D scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev));
> +	pg_init_done(&pgpath->path, ret);
>  }
>=20
>  /*
>=20
