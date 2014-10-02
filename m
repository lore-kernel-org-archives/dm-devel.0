From: NeilBrown <neilb@suse.de>
Subject: Re: dm-raid: add RAID discard support
Date: Thu, 2 Oct 2014 12:00:49 +1000
Message-ID: <20141002120049.58dba551@notabene.brown>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
	<5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
	<20141001133237.GB16521@redhat.com>
	<20141002093403.25cc832f@notabene.brown>
	<20141002013135.GA21091@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7129079703625829388=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141002013135.GA21091@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

--===============7129079703625829388==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/7GwfDf1yHFaSP3x8HJGnvlf";
	protocol="application/pgp-signature"

--Sig_/7GwfDf1yHFaSP3x8HJGnvlf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Oct 2014 21:31:36 -0400 Mike Snitzer <snitzer@redhat.com> wrote:

> Hi,
>=20
> On Wed, Oct 01 2014 at  7:34pm -0400,
> NeilBrown <neilb@suse.de> wrote:
>=20
> > On Wed, 1 Oct 2014 09:32:37 -0400 Mike Snitzer <snitzer@redhat.com> wro=
te:
> >=20
> > >=20
> > > I had the same thought and would be happy with this too.  I was going=
 to
> > > update Heinz's patch to have the same default off but allow user to
> > > enable:
> > > https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.g=
it/commit/?h=3Dfor-next&id=3D8e0cff64f35971135a6de7907bbc8c3a010aff8f
> > >=20
> > > But I'd love to just follow what you arrive at with MD (using the same
> > > name for the module param in dm-raid).
> > >=20
> > > I'm open to getting this done now and included in 3.18 if you are.
> > >=20
> > > Mike
> >=20
> > How about something like this?
> > I want to keep it well away from regular API stuff as I hope it is just=
 a
> > temporary hack until a more general solution can be found and implement=
ed.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 183588b11fc1..3ed668c5378c 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -64,6 +64,10 @@
> >  #define cpu_to_group(cpu) cpu_to_node(cpu)
> >  #define ANY_GROUP NUMA_NO_NODE
> > =20
> > +static bool devices_handle_discard_safely =3D false;
> > +module_param(devices_handle_discard_safely, bool, false);
> > +MODULE_PARM_DESC(devices_handle_discard_safely,
> > +		 "Set to Y if all devices in array reliably return zeroes on reads f=
rom discarded regions");
> >  static struct workqueue_struct *raid5_wq;
> >  /*
> >   * Stripe cache
> > @@ -6208,7 +6212,7 @@ static int run(struct mddev *mddev)
> >  		mddev->queue->limits.discard_granularity =3D stripe;
> >  		/*
> >  		 * unaligned part of discard request will be ignored, so can't
> > -		 * guarantee discard_zerors_data
> > +		 * guarantee discard_zeroes_data
> >  		 */
> >  		mddev->queue->limits.discard_zeroes_data =3D 0;
> > =20
> > @@ -6233,6 +6237,18 @@ static int run(struct mddev *mddev)
> >  			    !bdev_get_queue(rdev->bdev)->
> >  						limits.discard_zeroes_data)
> >  				discard_supported =3D false;
> > +			/* Unfortunately, discard_zeroes_data is not currently
> > +			 * a guarantee - just a hint.  So we only allow DISCARD
> > +			 * if the sysadmin has confirmed that only safe devices
> > +			 * are in use but setting a module parameter.
> > +			 */
> > +			if (!devices_handle_discard_safely) {
> > +				if (discard_supported) {
> > +					pr_info("md/raid456: discard support disabled due to uncertainty.=
\n");
> > +					pr_info("Set raid456.devices_handle_discard_safely=3DY to overrid=
e.\n");
> > +				}
> > +				discard_supported =3D false;
> > +			}
> >  		}
> > =20
> >  		if (discard_supported &&
>=20
>=20
> There is a typo in the new block comment above: "are in use but setting
> a module parameter".  s/but/by/

Fixed, thanks.


>=20
> But thinking further: should this be a per array override?  E.g. for DM
> this could easily be a dm-raid table parameter.  But I know the MD
> implementation would likely be more cumbersome (superblock update?).

If you want to use discard selectively on some arrays, you can mount
filesystems with appropriate options, or be careful in your use of 'fstrim'.

I see the module option as something to force people to think or ask before
"blindly" using DISCARD.  I don't see it is a configuration tool.

>=20
> Though given the (hopefully) temporary nature of this, maybe it isn't
> worth it for MD.  Maybe be a bit more precise in the MODULE_PARM_DESC
> with:=20
> "Set to Y if all devices in each array reliably returns zeroes on reads
> from discarded regions" ?

I added the 'each'.  I don't agree with the 's' on 'returns' :-(

Thanks,
NeilBrown



--Sig_/7GwfDf1yHFaSP3x8HJGnvlf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCyx0Tnsnt1WYoG5AQIvOBAAkxxkArxkk7ufKZXM3sLjw0lVElH38W3V
9CFAfdChWvwrigaLbmZIUl8Lj4qjjhudz6pbVzcpK35X3kWBJDF9roKvfVvkZsHW
mMwKmDf1braZLXhi/MvNUcBxXNPz69K27zdaY1JKORpBnUx3BTfxAJS4N32Cg4w7
Wfj9LdX+fDGVfuYyOcXuwU2WUwFiUcZpjqejQvjmwf17zQfqnJ8GGQZ3Kr2imulA
ICaTqgPT3SXHJ7KbXC4qHPkQ2XhxTUbWDzii7Q1i5GTyXx6qtFSEamsPIKIJByk+
8Hl4nuCoapHQ4ZMbiuxRk75UgTdemej4JRV97XxWu7BcAsKhkKDdwH9wk8orR66S
Ks3rVHlrsI/myRWcu5ZJFXIbP7GiDLXTnfNGYkkM2XlwUoAnZepXVpLzTgQhKylu
sdBgmmk3yDEu1a913K6yHKUGiqkMSRHZcGUYzxopflBFEAzCrgK6ekKJwwvH/fBG
sLNVe+MYSCJo/Vg1kDPDS3fzgHXEhP5HHmtMOln+pG/RAIE6ThP21QsRQaG1xkX4
NidWwphUSYYAtv8yhJPLnDGtuVKMkiYM8dBwB1f1iWdZ1cVDc//tVqB99ztTUteI
nWXxJxDeS5eWU4rtp6OrNYF7tUfuOVx5YqQhLTd1d1uRY0LWNvUvKe5rTXAvmg+p
PnLZIF4T3RY=
=/1XF
-----END PGP SIGNATURE-----

--Sig_/7GwfDf1yHFaSP3x8HJGnvlf--


--===============7129079703625829388==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7129079703625829388==--
