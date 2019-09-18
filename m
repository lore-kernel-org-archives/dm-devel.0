From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/2] scsi: core: fix missing .cleanup_rq for
 SCSI hosts without request batching
Date: Wed, 18 Sep 2019 16:32:17 +0100
Message-ID: <20190918153217.GN2596@sirena.co.uk>
References: <20190807144948.28265-1-maier@linux.ibm.com>
	<20190807144948.28265-2-maier@linux.ibm.com>
	<CACVXFVM0tFj8CmcHON04_KjxR=QErCbUx0abJgG2W9OBb7akZA@mail.gmail.com>
	<yq136iccsbw.fsf@oracle.com>
	<bec80a65-9a8c-54a9-fe70-876fcbe3d592@linux.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4859397541990601135=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <bec80a65-9a8c-54a9-fe70-876fcbe3d592@linux.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steffen Maier <maier@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>, linux-s390 <linux-s390@vger.kernel.org>, Benjamin Block <bblock@linux.ibm.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Lei <tom.leiming@gmail.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Hannes Reinecke <hare@suse.com>, "Ewan D . Milne" <emilne@redhat.com>, Ming Lei <ming.lei@redhat.com>, linux-block <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids


--===============4859397541990601135==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0NB0lE7sNnW8+0qW"
Content-Disposition: inline


--0NB0lE7sNnW8+0qW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 18, 2019 at 05:09:50PM +0200, Steffen Maier wrote:
> On 8/8/19 4:18 AM, Martin K. Petersen wrote:

> > I'll set up an amalgamated for-next branch tomorrow.

> Martin, is it possible that you re-wrote your for-next and it now no longer
> contains a merged 5.4/scsi-postmerge with those fixes?
> At least I cannot find the fix code in next-20190917 and it fails again for me.

Well, there's no sign of a branch called postmerge in the SCSI history
recently and I've not run into any SCSI-related conflicts so...

--0NB0lE7sNnW8+0qW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2CTgAACgkQJNaLcl1U
h9DyCQgAhI9PE5cah3tJXlfm2IgfE6DGqrY+ZgkKfYQRbESZUGGvH0C8ZHzfdF9s
ew1oLds2WQCiwXttdV/OQrmwkkHibCqk7ZruKQJpmIDN9CmRPnO1EHunK1UFVuli
YGsRLI1Lp/gzfAzbaoA7BihFFKukgTxrZYcH9SfERbpf/raKMrEB9HUbyFDeBBKN
btGkV2DjeLMwQxiwQLTNDZ8NQ9oUwkaX1kGOv3CilW2qDkueaghQnMpyw05kuddR
4F5rE8+vA4jHJssZOqsoUJiNFzc9lloTdKeUDd4tR0qgY/thaG+RA2OVgh1XR1x1
wYZjyEIwrB4FhNOMDMiIl6jcM6uoqw==
=63JF
-----END PGP SIGNATURE-----

--0NB0lE7sNnW8+0qW--


--===============4859397541990601135==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4859397541990601135==--
