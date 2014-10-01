From: NeilBrown <neilb@suse.de>
Subject: Re: dm-raid: add RAID discard support
Date: Thu, 2 Oct 2014 09:34:03 +1000
Message-ID: <20141002093403.25cc832f@notabene.brown>
References: <1411491106-23676-1-git-send-email-heinzm@redhat.com>
	<yq18ulaszpk.fsf@sermon.lab.mkp.net>
	<20140924093308.120fe616@notabene.brown>
	<yq1zjdpsqry.fsf@sermon.lab.mkp.net>
	<7C39EB56-623A-4318-A558-258ABA32FF12@redhat.com>
	<20140924142157.33475baa@notabene.brown>
	<5422A4C4.4020707@redhat.com>
	<20141001125625.1e0d356a@notabene.brown>
	<20141001133237.GB16521@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8574216850329920209=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141001133237.GB16521@redhat.com>
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

--===============8574216850329920209==
Content-Type: multipart/signed; micalg=pgp-sha1;
	boundary="Sig_/=ZWpf83AwYYcgd/Ucc0m2vT";
	protocol="application/pgp-signature"

--Sig_/=ZWpf83AwYYcgd/Ucc0m2vT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Oct 2014 09:32:37 -0400 Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Sep 30 2014 at 10:56pm -0400,
> NeilBrown <neilb@suse.de> wrote:
>=20
> > On Wed, 24 Sep 2014 13:02:28 +0200 Heinz Mauelshagen <heinzm@redhat.com>
> > wrote:
> >=20
> > >=20
> > > Martin,
> > >=20
> > > thanks for the good explanation of the state of the discard union.
> > > Do you have an ETA for the 'zeroout, deallocate' ... support you ment=
ioned?
> > >=20
> > > I was planning to have a followup patch for dm-raid supporting a dm-r=
aid=20
> > > table
> > > line argument to prohibit discard passdown.
> > >=20
> > > In lieu of the fuzzy field situation wrt SSD fw and discard_zeroes_da=
ta=20
> > > support
> > > related to RAID4/5/6, we need that in upstream together with the init=
ial=20
> > > patch.
> > >=20
> > > That 'no_discard_passdown' table line can be added to dm-raid RAID4/5=
/6=20
> > > table
> > > lines to avoid possible data corruption but can be avoided on RAID1/1=
0=20
> > > table lines,
> > > because the latter are not suffering from any  discard_zeroes_data fl=
aw.
> > >=20
> > >=20
> > > Neil,
> > >=20
> > > are you going to disable discards in RAID4/5/6 shortly
> > > or rather go with your bitmap solution?
> >=20
> > Can I just close my eyes and hope it goes away?
> >=20
> > The idea of a bitmap of uninitialised areas is not a short-term solutio=
n.
> > But I'm not really keen on simply disabling discard for RAID4/5/6 eithe=
r. It
> > would  mean that people with good sensible hardware wouldn't be able to=
 use
> > it properly.
> >=20
> > I would really rather that discard_zeroes_data were only set on devices=
 where
> > it was actually true.  Then it wouldn't be my problem any more.
> >=20
> > Maybe I could do a loud warning
> >   "Not enabling DISCARD on RAID5 because we cannot trust committees.
> >    Set "md_mod.willing_to_risk_discard=3DY" if your devices reads disca=
rded
> >    sectors as zeros"
> >=20
> > and add an appropriate module parameter......
>=20
> I had the same thought and would be happy with this too.  I was going to
> update Heinz's patch to have the same default off but allow user to
> enable:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/c=
ommit/?h=3Dfor-next&id=3D8e0cff64f35971135a6de7907bbc8c3a010aff8f
>=20
> But I'd love to just follow what you arrive at with MD (using the same
> name for the module param in dm-raid).
>=20
> I'm open to getting this done now and included in 3.18 if you are.
>=20
> Mike

How about something like this?
I want to keep it well away from regular API stuff as I hope it is just a
temporary hack until a more general solution can be found and implemented.

Thanks,
NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 183588b11fc1..3ed668c5378c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -64,6 +64,10 @@
 #define cpu_to_group(cpu) cpu_to_node(cpu)
 #define ANY_GROUP NUMA_NO_NODE
=20
+static bool devices_handle_discard_safely =3D false;
+module_param(devices_handle_discard_safely, bool, false);
+MODULE_PARM_DESC(devices_handle_discard_safely,
+		 "Set to Y if all devices in array reliably return zeroes on reads from =
discarded regions");
 static struct workqueue_struct *raid5_wq;
 /*
  * Stripe cache
@@ -6208,7 +6212,7 @@ static int run(struct mddev *mddev)
 		mddev->queue->limits.discard_granularity =3D stripe;
 		/*
 		 * unaligned part of discard request will be ignored, so can't
-		 * guarantee discard_zerors_data
+		 * guarantee discard_zeroes_data
 		 */
 		mddev->queue->limits.discard_zeroes_data =3D 0;
=20
@@ -6233,6 +6237,18 @@ static int run(struct mddev *mddev)
 			    !bdev_get_queue(rdev->bdev)->
 						limits.discard_zeroes_data)
 				discard_supported =3D false;
+			/* Unfortunately, discard_zeroes_data is not currently
+			 * a guarantee - just a hint.  So we only allow DISCARD
+			 * if the sysadmin has confirmed that only safe devices
+			 * are in use but setting a module parameter.
+			 */
+			if (!devices_handle_discard_safely) {
+				if (discard_supported) {
+					pr_info("md/raid456: discard support disabled due to uncertainty.\n");
+					pr_info("Set raid456.devices_handle_discard_safely=3DY to override.\n=
");
+				}
+				discard_supported =3D false;
+			}
 		}
=20
 		if (discard_supported &&

--Sig_/=ZWpf83AwYYcgd/Ucc0m2vT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCyPaznsnt1WYoG5AQLkvA//Zmi+QLFc4s0Bt1lFW8Rr+hhDIZIBT7Fq
ZLpBcCCIF7cJ1zLNda0MNv3KvH58KYQOp+OfJjfhSHkTIUKxinYH57VChMeW2R1P
dIyCBExZyzgpLZxhistIaebbwE9e+Syb/xANarlrQLFFLgMc+IALDLl+if8TnGtB
2qZ53rEfYY2jyymGDJXBC1h69jNISYE9aeL2MVO4+koI4NI5YbQJXo3OeRzUTth/
d2t0O9NeO1lEkmBaFUuRzzz8Sr3vYFOfmahM2EiYudIQVv2VGXlDmFGMfxHw0+Bv
HfLP53yYCk6G+Q6LEFRtlDOOFgEH4l9pUKhwQAQFB8jMPuc1z9sE1n1k4iARPlMu
CxO8yvW1dPrDUCCdCsBp3P+KW48szMBLKcTVdGoEBldPRU4MwCAwu4RAjY0FF78o
khrEyIFWL/bFvJXnzi/cBuknKznxsRTzqBXyeutcKcN/9Nn6sWfu3N80lxPOt7Kn
Yod1r9M2U37I+Y7jMUGFwBNi3lASSKnJoCnohPojMU35IDMRHtgWZx4ISKsJxSos
sp5SkfaG2dR3bbVCmHdZHlKlSesV/Bsq0ccg693KS2Ia34uId7/pDu14FI6MLZRL
NGq4jfq5mGDLjDGEVjtfMcyWHlQsdzYcVSiloJSMMfDEh1JPqe31mzXHANKxzcSw
3MXhdoyheBc=
=IUmt
-----END PGP SIGNATURE-----

--Sig_/=ZWpf83AwYYcgd/Ucc0m2vT--


--===============8574216850329920209==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8574216850329920209==--
