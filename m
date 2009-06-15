From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] Handle multipath paths in a path group
	properly during pg_init
Date: Mon, 15 Jun 2009 16:16:58 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF46F009AA5@cosmail01.lsi.com>
References: <1238436452.5858.2.camel@chandra-ubuntu>
	<1240872495.22154.7.camel@chandra-ubuntu>
	<1240947117.13184.8.camel@chandra-ubuntu>
	<1244246693.28800.23.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1244246693.28800.23.camel@chandra-ubuntu>
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
To: "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

I have seen this race condition earlier on my system. Problem is resolved=
 after testing with this patch. Thanks.   =20
--Babu Moger=20

> -----Original Message-----
> From: Chandra Seetharaman [mailto:sekharan@us.ibm.com]
> Sent: Friday, June 05, 2009 7:05 PM
> To: device-mapper development
> Cc: Alasdair G Kergon; Moger, Babu
> Subject: Re: [dm-devel] [PATCH] Handle multipath paths in a path group
> properly during pg_init
>=20
> Found a race condition where pg_init_in_progress being incremented when
> queue_work() returns without queuing the work.
>=20
> Changed the code to increment pg_init_in_progress only when queue_work
> returns success.
>=20
> Tested in 2.6.30-rc8
>=20
> ---------------------------------------------------
> From: Chandra Seetharaman <sekharan@us.ibm.com>
>=20
> Fixed a problem affecting reinstatement of passive paths and another
> problem with io lockup during device offline/online.
>=20
> Before we moved the hardware handler from dm to SCSI, it performed a
> pg_init
> for a path group and didn't maintain any state about each path in hardw=
are
> handler code.
>=20
> But in SCSI dh, such state is now maintained, as we want to fail I/O ea=
rly
> on a
> path if it is not the active path.
>=20
> All the hardware handlers have a state now and set to active or some fo=
rm
> of
> inactive.  They have prep_fn() which uses this state to fail the I/O
> without
> it ever being sent to the device.
>=20
> So in effect when dm-multipath calls scsi_dh_activate(), activate is
> sent to only one path and the "state" of that path is changed
> appropriately
> to "active" while other paths in the same path group are never changed
> as they never got an "activate".
>=20
> In order make sure all the paths in a path group gets their state set
> properly when a pg_init happens, we need to call scsi_dh_activate() on
> all paths in a path group.
>=20
> Doing this at the hardware handler layer is not a good option as we
> want the multipath layer to define the relationship between path and pa=
th
> groups and not the hardware handler.
>=20
> Attached patch sends an "activate" on each path in a path group when a
> path group is switched. It also sends an activate when a path is
> reinstated.
>=20
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Signed-off-by: Alasdair G Kergon <agk@redhat.com>
>=20
> ---
>  drivers/md/dm-mpath.c |   63 +++++++++++++++++++++--------------------=
---
> ------
>  1 file changed, 26 insertions(+), 37 deletions(-)
>=20
> Index: linux-2.6.29/drivers/md/dm-mpath.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.29.orig/drivers/md/dm-mpath.c
> +++ linux-2.6.29/drivers/md/dm-mpath.c
> @@ -35,6 +35,7 @@ struct pgpath {
>=20
>  	struct dm_path path;
>  	struct work_struct deactivate_path;
> +	struct work_struct activate_path;
>  };
>=20
>  #define path_to_pgpath(__pgp) container_of((__pgp), struct pgpath, pat=
h)
> @@ -64,8 +65,6 @@ struct multipath {
>  	spinlock_t lock;
>=20
>  	const char *hw_handler_name;
> -	struct work_struct activate_path;
> -	struct pgpath *pgpath_to_activate;
>  	unsigned nr_priority_groups;
>  	struct list_head priority_groups;
>  	unsigned pg_init_required;	/* pg_init needs calling? */
> @@ -128,6 +127,7 @@ static struct pgpath *alloc_pgpath(void)
>  	if (pgpath) {
>  		pgpath->is_active =3D 1;
>  		INIT_WORK(&pgpath->deactivate_path, deactivate_path);
> +		INIT_WORK(&pgpath->activate_path, activate_path);
>  	}
>=20
>  	return pgpath;
> @@ -160,7 +160,6 @@ static struct priority_group *alloc_prio
>=20
>  static void free_pgpaths(struct list_head *pgpaths, struct dm_target *=
ti)
>  {
> -	unsigned long flags;
>  	struct pgpath *pgpath, *tmp;
>  	struct multipath *m =3D ti->private;
>=20
> @@ -169,10 +168,6 @@ static void free_pgpaths(struct list_hea
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
> @@ -202,7 +197,6 @@ static struct multipath *alloc_multipath
>  		m->queue_io =3D 1;
>  		INIT_WORK(&m->process_queued_ios, process_queued_ios);
>  		INIT_WORK(&m->trigger_event, trigger_event);
> -		INIT_WORK(&m->activate_path, activate_path);
>  		m->mpio_pool =3D mempool_create_slab_pool(MIN_IOS, _mpio_cache);
>  		if (!m->mpio_pool) {
>  			kfree(m);
> @@ -427,8 +421,8 @@ static void process_queued_ios(struct wo
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
> @@ -446,19 +440,15 @@ static void process_queued_ios(struct wo
>  		must_queue =3D 0;
>=20
>  	if (m->pg_init_required && !m->pg_init_in_progress && pgpath) {
> -		m->pgpath_to_activate =3D pgpath;
>  		m->pg_init_count++;
>  		m->pg_init_required =3D 0;
> -		m->pg_init_in_progress =3D 1;
> -		init_required =3D 1;
> +		list_for_each_entry(tmp, &pgpath->pg->pgpaths, list) {
> +			if (queue_work(kmpath_handlerd, &tmp->activate_path))
> +				m->pg_init_in_progress++;
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
> @@ -924,9 +914,13 @@ static int reinstate_path(struct pgpath
>=20
>  	pgpath->is_active =3D 1;
>=20
> -	m->current_pgpath =3D NULL;
> -	if (!m->nr_valid_paths++ && m->queue_size)
> +	if (!m->nr_valid_paths++ && m->queue_size) {
> +		m->current_pgpath =3D NULL;
>  		queue_work(kmultipathd, &m->process_queued_ios);
> +	} else if (m->hw_handler_name && (m->current_pg =3D=3D pgpath->pg)) {
> +		if (queue_work(kmpath_handlerd, &pgpath->activate_path))
> +			m->pg_init_in_progress++;
> +	}
>=20
>  	dm_path_uevent(DM_UEVENT_PATH_REINSTATED, m->ti,
>  		      pgpath->path.dev->name, m->nr_valid_paths);
> @@ -1102,35 +1096,30 @@ static void pg_init_done(struct dm_path
>=20
>  	spin_lock_irqsave(&m->lock, flags);
>  	if (errors) {
> -		DMERR("Could not failover device. Error %d.", errors);
> -		m->current_pgpath =3D NULL;
> -		m->current_pg =3D NULL;
> +		if (pgpath =3D=3D m->current_pgpath) {
> +			DMERR("Could not failover device. Error %d.", errors);
> +			m->current_pgpath =3D NULL;
> +			m->current_pg =3D NULL;
> +		}
>  	} else if (!m->pg_init_required) {
>  		m->queue_io =3D 0;
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
>=20
>=20
