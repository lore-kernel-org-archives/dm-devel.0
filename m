From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Device Mapper MultiPath
Date: Fri, 3 Apr 2009 10:23:23 -0400
Message-ID: <20090403142323.GA26508@mars.virtualiron.com>
References: <20090402215008.GA14752@thumper2>
	<739475537.2943331238709482966.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <739475537.2943331238709482966.JavaMail.root@zimbra16-e3.priv.proxad.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Apr 02, 2009 at 11:58:03PM +0200, christophe.varoqui@free.fr wrot=
e:
> I can reproduce Andy's multipathd behaviour with scsi_debug (symmetrix =
arrays too)... only with the upstream directio checker. My guess is that =
the async code in there misbehaves. Needs review.

I saw this behavior as well on RHEL5U3 with the upstream multipath.
My fix was to replace all of the libaio calls with syscalls, as I attribu=
ted
the issue to libaio !=3D kernel libaio, and left it at that.

Andy, are you using a recent version of libaio and kernel? Like
Fedora Core 10?
>=20
> ----- Mail Original -----
> De: "Andy" <genanr@emsphone.com>
> =C0: "device-mapper development" <dm-devel@redhat.com>
> Envoy=E9: Jeudi 2 Avril 2009 23h50:08 GMT +01:00 Amsterdam / Berlin / B=
erne / Rome / Stockholm / Vienne
> Objet: Re: [dm-devel] Device Mapper MultiPath
>=20
> On Thu, Apr 02, 2009 at 03:32:33PM -0400, Konrad Rzeszutek wrote:
> > On Thu, Apr 02, 2009 at 02:09:56PM -0500, Andy wrote:
> > > On Wed, Apr 01, 2009 at 04:31:08PM -0400, Konrad Rzeszutek wrote:
> > > > On Wed, Apr 01, 2009 at 03:08:41PM -0500, Andy wrote:
> > > > > On Tue, Mar 31, 2009 at 08:25:59PM -0400, Konrad Rzeszutek wrot=
e:
> > > > > > On Tue, Mar 31, 2009 at 09:07:08PM -0300, Rodrigo Nascimento =
wrote:
> > > > > > > Hi All,
> > > > > > >=20
> > > > > > > I'm a student of computer sciences and I'd like to collabor=
ate with the
> > > > > > > development of the DM-MP.
> > > > > > > I know that maybe you received this kind of message during =
all time, but I
> > > > > >=20
> > > > > > I think you are the first :-)
> > > > > >=20
> > > > > > > really want to help, with anything.
> > > > > >=20
> > > > > > Shakedown help would be nice. As in, trying to yank stuff und=
erneath it,=20
> > > > > > add new block disks, remove them, add them, remove them, edit=
 the
> > > > > > multipath.conf file and issue 'reconfigure', resize the maps,=
=20
> > > > > > then add 1000+LUNs, and while they are being added, start rem=
oving the
> > > > > > LUNs, then for extra fun call 'dmsetup remove_all' while in a=
nother
> > > > > > thread you run 'multipath'. Ooh, and see if there are any mem=
ory leaks
> > > > > > while this all is being done.
> > > > > >=20
> > > > >=20
> > > > > What I would really like to see is online resizing of non-parti=
tioned dm
> > > > > block devices.  I would love to be able to resize an underlying=
 dm-mp block
> > > > > device, and the just grow the filesystem without using a extra,=
 un-needed,
> > > >=20
> > > > Benjamin posted a CVS patch of this, that I've forward-ported to =
work with
> > > > the latest git. It is attached.
> > > >=20
> > > >=20
> > >=20
> > > Thanks, I must have missed that post.  Unfortantly, I am having pro=
blems with
> > > multipathd in the latest git.  It fails all my paths and hangs.  It=
 I go
> >=20
> > Ugh. That doesn't bode well. Try running it with 'strace' to see if i=
t is hanging
> > on the ioctl or what not.
> >=20
>=20
> The multipathd process is just sitting there polling, but I don't think=
 it
> gets to a point where it can handle requests from an interactive versio=
n of
> itself.
>=20
> I do see detecting or failing the paths in the log:
>=20
> Apr 02 16:24:01 | sdc: ownership set to test1_vm1
> Apr 02 16:24:01 | sdc: not found in pathvec
> Apr 02 16:24:01 | sdc: mask =3D 0xc
> Apr 02 16:24:01 | sdc: path checker =3D directio (controller setting)
> Apr 02 16:24:01 | sdc: state =3D running
> Apr 02 16:24:01 | directio: starting new request
> Apr 02 16:24:01 | directio: async io getevents returns -14 (errno=3DNo =
such file or directory)
> Apr 02 16:24:01 | directio: abort check on timeout
> Apr 02 16:24:01 | sdc: state =3D 2
> Apr 02 16:24:01 | sdc: checker msg is "directio checker reports path is=
 down"
> Apr 02 16:24:01 | sde: ownership set to test1_vm1
> Apr 02 16:24:01 | sde: not found in pathvec
> Apr 02 16:24:01 | sde: mask =3D 0xc
> Apr 02 16:24:01 | sde: path checker =3D directio (controller setting)
> Apr 02 16:24:01 | sde: state =3D running
> Apr 02 16:24:01 | directio: starting new request
> Apr 02 16:24:01 | directio: async io getevents returns -14 (errno=3DNo =
such file or directory)
> Apr 02 16:24:01 | directio: abort check on timeout
> Apr 02 16:24:01 | sde: state =3D 2
> Apr 02 16:24:01 | sde: checker msg is "directio checker reports path is=
 down"
> Apr 02 16:24:01 | test1_vm1: pgfailover =3D -1 (internal default)
> Apr 02 16:24:01 | test1_vm1: pgpolicy =3D multibus (LUN setting)
> Apr 02 16:24:01 | test1_vm1: selector =3D round-robin 0 (LUN setting)
> Apr 02 16:24:01 | test1_vm1: features =3D 0 (controller setting)
> Apr 02 16:24:01 | test1_vm1: hwhandler =3D 0 (controller setting)
> Apr 02 16:24:01 | test1_vm1: rr_weight =3D 1 (controller setting)
> Apr 02 16:24:01 | test1_vm1: minio =3D 1 (LUN setting)
> Apr 02 16:24:01 | test1_vm1: no_path_retry =3D NONE (internal default)
> Apr 02 16:24:01 | pg_timeout =3D NONE (internal default)
> Apr 02 16:24:01 | test1_vm1: set ACT_NOTHING (no usable path)
> Apr 02 16:24:01 | sdb: ownership set to u01_vm1
> Apr 02 16:24:01 | sdb: not found in pathvec
> Apr 02 16:24:01 | sdb: mask =3D 0xc
> Apr 02 16:24:01 | sdb: path checker =3D directio (controller setting)
> Apr 02 16:24:01 | sdb: state =3D running
> Apr 02 16:24:01 | directio: starting new request
> Apr 02 16:24:01 | directio: async io getevents returns -14 (errno=3DNo =
such file or directory)
> Apr 02 16:24:01 | directio: abort check on timeout
> Apr 02 16:24:01 | sdb: state =3D 2
> Apr 02 16:24:01 | sdb: checker=20
>=20
> Other than that, I did not see anything significant in the strace or th=
e
> debugging messages.
>=20
> Andy
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
