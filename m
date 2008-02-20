From: "Rogan, Julian" <Julian.Rogan@Unilever.com>
Subject: RE: multipath errors on first set-up
Date: Wed, 20 Feb 2008 09:42:17 -0000
Message-ID: <DFB2D7E03264FB4392B70A38BFF9FC710202657B@BRBSEVS20000.s2.ms.unilever.com>
References: <20080219192317.GI15608@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080219192317.GI15608@ether.msp.redhat.com>
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

Hi,
Here is the output:

multipath -l
3600508b300930230a7495ae1b9500074
[size=3D1 TB][features=3D"0"][hwhandler=3D"0"]
\_ round-robin 0 [enabled]
  \_ 0:0:0:1 sda  8:0     [active]
\_ round-robin 0 [enabled]
  \_ 1:0:0:1 sdb  8:16    [active]
\_ round-robin 0 [enabled]
  \_ 2:0:0:1 sdc  8:32    [active]
\_ round-robin 0 [enabled]
  \_ 3:0:0:1 sdd  8:48    [active]

A map was created:

/dev/mapper/3600508b300930230a7495ae1b9500074
=20


with regards,
                  Julian
Name: Julian Rogan
Role: Unix Server Analyst
Department: Enterprise Hosting
Regional Group: Unilever Europe IT Services
Telephone : +44 (0) 1244 50 1356
Mobile: +44 (0) 7876 390715
Office Base: Unity House, St Davids Park, Ewloe, UK. CH5 3XT
Unilever U.K. Central Resources Limited
Registered in England & Wales; Company No 29140
Registered Office: Unilever House, Blackfriars, London, EC4P 4BQ=20


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Benjamin Marzinski
Sent: Tuesday, February 19, 2008 7:23 PM
To: device-mapper development
Subject: Re: [dm-devel] multipath errors on first set-up

On Mon, Feb 18, 2008 at 04:42:27PM -0000, Rogan, Julian wrote:
> Hi,
> Thanks for the reply.
>=20
> I have fixed the invaliud messages output by installed the 64 bit=20
> version of multipath.
> I have re-tried the build stage but the mpathX device file is still=20
> not being created.
>=20
> Here is the output:
>=20
> output from multipath -v4
>=20
>=20
> cciss!c0d0 blacklisted
> dm-0 blacklisted
> dm-1 blacklisted
> dm-2 blacklisted
> dm-3 blacklisted
> dm-4 blacklisted
> dm-5 blacklisted
> fd0 blacklisted
> hda blacklisted
> md0 blacklisted
> ram0 blacklisted
> ram10 blacklisted
> ram11 blacklisted
> ram12 blacklisted
> ram13 blacklisted
> ram14 blacklisted
> ram15 blacklisted
> ram1 blacklisted
> ram2 blacklisted
> ram3 blacklisted
> ram4 blacklisted
> ram5 blacklisted
> ram6 blacklisted
> ram7 blacklisted
> ram8 blacklisted
> ram9 blacklisted
> path sda not found in pathvec
>=20
> =3D=3D=3D=3D=3D path sda =3D=3D=3D=3D=3D
> bus =3D 1
> dev_t =3D 8:0
> size =3D 3906810493
> vendor =3D HP
> product =3D MSA VOLUME
> rev =3D 6.86
> h:b:t:l =3D 0:0:0:1
> tgt_node_name =3D 0x500508b300930230
> serial =3D PB9840PX3TF0C0
> path checker =3D readsector0 (internal default) state =3D 2 getprio =3D=
=20
> (null) (internal default) prio =3D 1 getuid =3D /sbin/scsi_id -g -u -s=20
> /block/%n (internal default) uid =3D 3600508b300930230a7495ae1b9500074=20
> (callout) path sdb not found in pathvec
>=20
> =3D=3D=3D=3D=3D path sdb =3D=3D=3D=3D=3D
> bus =3D 1
> dev_t =3D 8:16
> size =3D 3906810493
> vendor =3D HP
> product =3D MSA VOLUME
> rev =3D 6.86
> h:b:t:l =3D 1:0:0:1
> tgt_node_name =3D 0x500508b300930230
> serial =3D PB9840PX3TJ0FU
> path checker =3D readsector0 (internal default) state =3D 2 getprio =3D=
=20
> (null) (internal default) prio =3D 1 getuid =3D /sbin/scsi_id -g -u -s=20
> /block/%n (internal default) uid =3D 3600508b300930230a7495ae1b9500074=20
> (callout) path sdc not found in pathvec
>=20
> =3D=3D=3D=3D=3D path sdc =3D=3D=3D=3D=3D
> bus =3D 1
> dev_t =3D 8:32
> size =3D 3906810493
> vendor =3D HP
> product =3D MSA VOLUME
> rev =3D 6.86
> h:b:t:l =3D 2:0:0:1
> tgt_node_name =3D 0x500508b300930230
> serial =3D PB9840PX3TF0C0
> path checker =3D readsector0 (internal default) state =3D 2 getprio =3D=
=20
> (null) (internal default) prio =3D 1 getuid =3D /sbin/scsi_id -g -u -s=20
> /block/%n (internal default) uid =3D 3600508b300930230a7495ae1b9500074=20
> (callout) path sdd not found in pathvec
>=20
> =3D=3D=3D=3D=3D path sdd =3D=3D=3D=3D=3D
> bus =3D 1
> dev_t =3D 8:48
> size =3D 3906810493
> vendor =3D HP
> product =3D MSA VOLUME
> rev =3D 6.86
> h:b:t:l =3D 3:0:0:1
> tgt_node_name =3D 0x500508b300930230
> serial =3D PB9840PX3TJ0FU
> path checker =3D readsector0 (internal default) state =3D 2 getprio =3D=
=20
> (null) (internal default) prio =3D 1 getuid =3D /sbin/scsi_id -g -u -s=20
> /block/%n (internal default) uid =3D 3600508b300930230a7495ae1b9500074=20
> (callout) # # all paths :
> #
> 3600508b300930230a7495ae1b9500074 0:0:0:1 sda  8:0     [MSA VOLUME
> ]
> 3600508b300930230a7495ae1b9500074 1:0:0:1 sdb  8:16    [MSA VOLUME
> ]
> 3600508b300930230a7495ae1b9500074 2:0:0:1 sdc  8:32    [MSA VOLUME
> ]
> 3600508b300930230a7495ae1b9500074 3:0:0:1 sdd  8:48    [MSA VOLUME
> ]
> pgpolicy =3D failover (internal default) selector =3D round-robin 0=20
> (internal default) features =3D 0 (internal
> default) hwhandler =3D 0 (internal default) 0 3906810493 multipath 0 0 =
4

> 1 round-robin 0 1 1 8:0 1000 round-robin 0 1 1 8:16 1000 round-robin 0

> 1 1
> 8:32 1000 round-robin 0 1 1 8:48 1000 action preset to 0 action set to

> 4
> create: 3600508b300930230a7495ae1b9500074
> [size=3D1 TB][features=3D"0"][hwhandler=3D"0"] \_ round-robin 0
>   \_ 0:0:0:1 sda  8:0
> \_ round-robin 0
>   \_ 1:0:0:1 sdb  8:16
> \_ round-robin 0
>   \_ 2:0:0:1 sdc  8:32
> \_ round-robin 0
>   \_ 3:0:0:1 sdd  8:48
>=20
> message 3600508b300930230a7495ae1b9500074 0 switch_group 1
>=20
> =20
> messages in /var/adm/messages:
>=20
> Feb 18 16:32:18 brli036a multipathd: path checkers start up Feb 18=20
> 16:32:18 brli036a multipathd: multipathd startup succeeded Feb 18=20
> 16:32:38 brli036a multipathd: 3600508b300930230a7495ae1b9500074:
> event checker started
> Feb 18 16:32:38 brli036a multipathd: add
> 3600508b300930230a7495ae1b9500074 devmap Feb 18 16:32:39 brli036a=20
> multipathd: 8:0: readsector0 checker reports path is up Feb 18=20
> 16:32:39 brli036a multipathd: 8:0: reinstated Feb 18 16:32:39 brli036a

> multipathd: 8:16: readsector0 checker reports path is up Feb 18=20
> 16:32:39 brli036a multipathd: 8:16: reinstated Feb 18 16:32:39=20
> brli036a multipathd: 8:32: readsector0 checker reports path is up Feb=20
> 18 16:32:39 brli036a multipathd: 8:32: reinstated
>=20
>=20
> I did comment out all of /etc/modules.conf as you suggested before I=20
> restarted,

Can you run

# multipath -l

It looks like a multipath map was created.  It's possible that the
device nodes weren't created correctly.=20

-Ben

=20
> Is there a problem with RHEL 4 QU2?
>=20
> with regards,
>                   Julian
> Name: Julian Rogan
> Role: Unix Server Analyst
> Department: Enterprise Hosting
> Regional Group: Unilever Europe IT Services Telephone : +44 (0) 1244=20
> 50 1356
> Mobile: +44 (0) 7876 390715
> Office Base: Unity House, St Davids Park, Ewloe, UK. CH5 3XT Unilever=20
> U.K. Central Resources Limited Registered in England & Wales; Company=20
> No 29140 Registered Office: Unilever House, Blackfriars, London, EC4P=20
> 4BQ
>=20
>=20
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Benjamin Marzinski
> Sent: Friday, February 15, 2008 8:20 PM
> To: device-mapper development
> Subject: Re: [dm-devel] multipath errors on first set-up
>=20
> On Fri, Feb 15, 2008 at 04:22:07PM -0000, Rogan, Julian wrote:
> >    Hi,
> >    I am using multipath for the first time with little joy.
>=20
> <snip>
> =20
> >    based on some other documents I made the following changes to
> >    /etc/multipath.conf
>=20
> You can probably leave the entire /etc/multipath.conf commented out.
> Everything should just autodetect correctly.
> =20
> >    I ran
> >    multipath -v3 to recreate I get the following:
>=20
> <snip>
>=20
> >    device-mapper ioctl cmd 14 failed: Invalid argument
> >    message 3600508b300930230a7495ae1b9500074 0 switch_group 1
> >    failed
> >=20
> >    Note sure if "path sdX not found in pathvec" relevant
>=20
> No, that's supposed to be there.
> =20
> >    anyway no mpaths have been created.
> >=20
> >    I hope there is someone out there who can give me some help with
> this.
>=20
> No chance you can update to a more recent version of RHEL4?
>=20
> The device-mapper message means the command you send to device-mapper=20
> didn't work.  However, it looks completely sensible.  What version of=20
> device-mapper are you using?
>=20
> # rpm -q device-mapper
>=20
> I'm guessing that you will see something like
> device-mapper-1.01.04-1.0.RHEL4
>=20
> device-mapper-multipath-0.4.5-6.0.RHEL4 needs
> device-mapper-1.02.*
>=20
> Look at things from my side, it definitely seems like RHEL 4.2 says it

> uses device-mapper-1.01, which doesn't make any sense, since
> device-mapper-multipath-0.4.5-6.0.RHEL4 was definitely compiled=20
> against device-mapper-1.02, and I don't believe that the can both 1.01

> and 1.02 can coexist on a system.
>=20
> The easy solution is to upgrade to at least RHEL 4.3
>=20
> If that's impossible, you can try to upgrade device-mapper to
> device-mapper-1.02.02-1.0.RHEL4 or later.  This might cause all sorts=20
> of dependancy issues. It may be easier to downgrade=20
> device-mapper-multipath to device-mapper-multipath-0.4.5-5.2.RHEL4
>=20
> I'm not sure why this incompatibility exists now, since it obviously=20
> didn't when RHEL 4.2 was originally released. My best guess is that
> device-mapper-multipath-0.4.5-6.0.RHEL4 didn't really get released=20
> until RHEL 4.3, but that's just a guess.
>=20
> Of course, if you already have device-mapper-1.02.* on your system,=20
> and are still seeing these issues, then something else is going on.
>=20
> -Ben
>=20
> >    with regards,
> >    Julian Rogan
>=20
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
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

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
