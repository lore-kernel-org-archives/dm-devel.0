From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [dm-devel] [PATCH 02/13] dm-mpath: Avoid that path removal can
 trigger an infinite loop
Date: Thu, 27 Apr 2017 15:11:43 +0000
Message-ID: <1493305901.2625.1.camel@sandisk.com>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
         <20170426183728.10821-3-bart.vanassche@sandisk.com>
         <fabbb802-5743-1193-3d4e-841404db2372@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <fabbb802-5743-1193-3d4e-841404db2372@suse.de>
Content-Language: en-US
Content-ID: <0D85A49438E9AD4FAF01F1AD713D862E@namprd04.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, 2017-04-27 at 07:46 +0200, Hannes Reinecke wrote:
> On 04/26/2017 08:37 PM, Bart Van Assche wrote:
> > +	clone =3D blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC)=
;
> >  	if (IS_ERR(clone)) {
> >  		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
> > -		return r;
> > +		pr_debug("blk_get_request() returned %ld%s - requeuing\n",
> > +			 PTR_ERR(clone), blk_queue_dying(q) ?
> > +			 " (path offline)" : "");
> > +		if (blk_queue_dying(q)) {
> > +			atomic_inc(&m->pg_init_in_progress);
> > +			activate_path(pgpath);
> > +			return DM_MAPIO_REQUEUE;
> > +		}
> > +		return DM_MAPIO_DELAY_REQUEUE;
> >  	}
> >  	clone->bio =3D clone->biotail =3D NULL;
> >  	clone->rq_disk =3D bdev->bd_disk;
>=20
> At the very least this does warrant some inline comments.
> Why do we call activate_path() here, seeing that the queue is dying?

Hello Hannes,

activate_path() is not only able to activate a path but can also change
the state of a path to offline. The body of the activate_path() function
makes that clear and that is why I had not added a comment above the
activate_path() call:

static void activate_path(struct pgpath *pgpath)
{
	struct request_queue *q =3D bdev_get_queue(pgpath->path.dev->bdev);

	if (pgpath->is_active && !blk_queue_dying(q))
		scsi_dh_activate(q, pg_init_done, pgpath);
	else
		pg_init_done(pgpath, SCSI_DH_DEV_OFFLINED);
}

Bart.=
