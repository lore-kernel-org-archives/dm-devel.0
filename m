From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tools - checker for DDN S2A8500
Date: Fri, 04 Aug 2006 08:41:44 +0200
Message-ID: <44D2EC28.4030502@suse.de>
References: <44C75AC0.1030905@ext.bull.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44C75AC0.1030905@ext.bull.net>
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
Cc: =?ISO-8859-1?Q?Ludovic_Fran=E7ois?= <lfrancois@datadirectnet.com>, Alain Moulle <Alain.Moulle@bull.net>, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Frederic TEMPORELLI wrote:
> Hello,
>=20
>=20
> When using multipath-tools 0.4.7, I would like to reports that DDN=20
> S2A8500 disk array reports a wrong status whith 'readsector0' checker.=20
> 'directio' seems to be the right checker for such storage system (see=20
> following logs).
> Can you update hwtable.c in this way ?
>=20
>=20
> multipathd logs when using 'readsector0':
>=20
> [root@iotiger2 ~]# multipathd -d -v3
> Jul 26 10:53:59 | --------start up--------
> Jul 26 10:53:59 | read /etc/multipath.conf
> Jul 26 10:53:59 | dm-0: blacklisted
> Jul 26 10:53:59 | dm-1: blacklisted
> Jul 26 10:53:59 | dm-2: blacklisted
> Jul 26 10:53:59 | dm-3: blacklisted
> Jul 26 10:53:59 | hda: blacklisted
> Jul 26 10:53:59 | loop0: blacklisted
> Jul 26 10:53:59 | loop1: blacklisted
> Jul 26 10:53:59 | loop2: blacklisted
> Jul 26 10:53:59 | loop3: blacklisted
> Jul 26 10:53:59 | loop4: blacklisted
> Jul 26 10:53:59 | loop5: blacklisted
> Jul 26 10:53:59 | loop6: blacklisted
> Jul 26 10:53:59 | loop7: blacklisted
> Jul 26 10:53:59 | ram0: blacklisted
> Jul 26 10:53:59 | ram1: blacklisted
> Jul 26 10:53:59 | ram2: blacklisted
> ...
> Jul 26 10:53:59 | sdc: not found in pathvec
> Jul 26 10:53:59 | sdc: mask =3D 0x1f
> Jul 26 10:53:59 | sdc: bus =3D 1
> Jul 26 10:53:59 | sdc: dev_t =3D 8:32
> Jul 26 10:53:59 | sdc: size =3D 571416576
> Jul 26 10:53:59 | sdc: vendor =3D DDN
> Jul 26 10:53:59 | sdc: product =3D S2A 8500
> Jul 26 10:53:59 | sdc: rev =3D 5.22
> Jul 26 10:53:59 | sdc: h:b:t:l =3D 4:0:0:0
> Jul 26 10:53:59 | sdc: tgt_node_name =3D 0x20000001ff0302a8
> Jul 26 10:53:59 | sdc: serial =3D
> Jul 26 10:53:59 | sdc: path checker =3D readsector0 (config file defaul=
t)
> Jul 26 10:53:59 | sdc: state =3D 1
> Jul 26 10:53:59 | sdc: checker msg is "readsector0 checker reports path=
=20
> is down"
> Jul 26 10:53:59 | sdc: getuid =3D /sbin/scsi_id -g -u -s /block/%n (con=
fig=20
> file default)
> Jul 26 10:53:59 | sdc: uid =3D 360001ff02002110102a8fe1c220f0100 (callo=
ut)
> Jul 26 10:53:59 | sdd: not found in pathvec
> Jul 26 10:53:59 | sdd: mask =3D 0x1f
> Jul 26 10:53:59 | sdd: bus =3D 1
> Jul 26 10:53:59 | sdd: dev_t =3D 8:48
> Jul 26 10:53:59 | sdd: size =3D 571416576
> Jul 26 10:53:59 | sdd: vendor =3D DDN
> Jul 26 10:53:59 | sdd: product =3D S2A 8500
> Jul 26 10:53:59 | sdd: rev =3D 5.22
> Jul 26 10:53:59 | sdd: h:b:t:l =3D 4:0:0:1
> Jul 26 10:53:59 | sdd: tgt_node_name =3D 0x20000001ff0302a8
> Jul 26 10:53:59 | sdd: serial =3D
> Jul 26 10:53:59 | sdd: path checker =3D readsector0 (config file defaul=
t)
> Jul 26 10:53:59 | sdd: state =3D 1
> Jul 26 10:53:59 | sdd: checker msg is "readsector0 checker reports path=
=20
> is down"
> Jul 26 10:53:59 | sdd: getuid =3D /sbin/scsi_id -g -u -s /block/%n (con=
fig=20
> file default)
> Jul 26 10:53:59 | sdd: uid =3D 360001ff02002110102a8fe20220f0300 (callo=
ut)
> Jul 26 10:53:59 | sde: not found in pathvec
> ...
>=20
> then, multipathd logs when using 'directio':
>=20
> Jul 26 10:56:09 | --------start up--------
> Jul 26 10:56:09 | read /etc/multipath.conf
> Jul 26 10:56:09 | dm-0: blacklisted
> Jul 26 10:56:09 | dm-1: blacklisted
> Jul 26 10:56:09 | dm-2: blacklisted
> Jul 26 10:56:09 | dm-3: blacklisted
> Jul 26 10:56:09 | dm-4: blacklisted
> Jul 26 10:56:09 | hda: blacklisted
> Jul 26 10:56:09 | loop0: blacklisted
> Jul 26 10:56:09 | loop1: blacklisted
> Jul 26 10:56:09 | loop2: blacklisted
> Jul 26 10:56:09 | loop3: blacklisted
> Jul 26 10:56:09 | loop4: blacklisted
> Jul 26 10:56:09 | loop5: blacklisted
> Jul 26 10:56:09 | loop6: blacklisted
> Jul 26 10:56:09 | loop7: blacklisted
> Jul 26 10:56:09 | ram0: blacklisted
> Jul 26 10:56:09 | ram1: blacklisted
> Jul 26 10:56:09 | ram2: blacklisted
> ...
> Jul 26 10:56:09 | sdc: not found in pathvec
> Jul 26 10:56:09 | sdc: mask =3D 0x1f
> Jul 26 10:56:09 | sdc: bus =3D 1
> Jul 26 10:56:09 | sdc: dev_t =3D 8:32
> Jul 26 10:56:09 | sdc: size =3D 571416576
> Jul 26 10:56:09 | sdc: vendor =3D DDN
> Jul 26 10:56:09 | sdc: product =3D S2A 8500
> Jul 26 10:56:09 | sdc: rev =3D 5.22
> Jul 26 10:56:09 | sdc: h:b:t:l =3D 4:0:0:0
> Jul 26 10:56:09 | sdc: tgt_node_name =3D 0x20000001ff0302a8
> Jul 26 10:56:09 | sdc: serial =3D
> Jul 26 10:56:09 | sdc: path checker =3D directio (config file default)
> Jul 26 10:56:09 | sdc: state =3D 0
> Jul 26 10:56:09 | sdc: getprio =3D /bin/true (config file default)
> Jul 26 10:56:09 | sdc: prio =3D 0
> Jul 26 10:56:09 | sdc: getuid =3D /sbin/scsi_id -g -u -s /block/%n (con=
fig=20
> file default)
> Jul 26 10:56:09 | sdc: uid =3D 360001ff02002110102a8fe1c220f0100 (callo=
ut)
> Jul 26 10:56:09 | sdd: not found in pathvec
> Jul 26 10:56:09 | sdd: mask =3D 0x1f
> Jul 26 10:56:09 | sdd: bus =3D 1
> Jul 26 10:56:09 | sdd: dev_t =3D 8:48
> Jul 26 10:56:09 | sdd: size =3D 571416576
> Jul 26 10:56:09 | sdd: vendor =3D DDN
> Jul 26 10:56:09 | sdd: product =3D S2A 8500
> Jul 26 10:56:09 | sdd: rev =3D 5.22
> Jul 26 10:56:09 | sdd: h:b:t:l =3D 4:0:0:1
> Jul 26 10:56:09 | sdd: tgt_node_name =3D 0x20000001ff0302a8
> Jul 26 10:56:09 | sdd: serial =3D
> Jul 26 10:56:09 | sdd: path checker =3D directio (config file default)
> Jul 26 10:56:09 | sdd: state =3D 0
> Jul 26 10:56:09 | sdd: getprio =3D /bin/true (config file default)
> Jul 26 10:56:09 | sdd: prio =3D 0
> Jul 26 10:56:09 | sdd: getuid =3D /sbin/scsi_id -g -u -s /block/%n (con=
fig=20
> file default)
> Jul 26 10:56:09 | sdd: uid =3D 360001ff02002110102a8fe20220f0300 (callo=
ut)
> Jul 26 10:56:09 | sde: not found in pathvec
> Jul 26 10:56:09 | sde: mask =3D 0x1f
> Jul 26 10:56:09 | sde: bus =3D 1
> Jul 26 10:56:09 | sde: dev_t =3D 8:64
> Jul 26 10:56:09 | sde: size =3D 571416576
> Jul 26 10:56:09 | sde: vendor =3D DDN
> Jul 26 10:56:09 | sde: product =3D S2A 8500
> Jul 26 10:56:09 | sde: rev =3D 5.22
> Jul 26 10:56:09 | sde: h:b:t:l =3D 4:0:0:2
> Jul 26 10:56:09 | sde: tgt_node_name =3D 0x20000001ff0302a8
> Jul 26 10:56:09 | sde: serial =3D
> Jul 26 10:56:09 | sde: path checker =3D directio (config file default)
> Jul 26 10:56:09 | sde: state =3D 0
> Jul 26 10:56:09 | sde: getprio =3D /bin/true (config file default)
> Jul 26 10:56:09 | sde: prio =3D 0
> Jul 26 10:56:09 | sde: getuid =3D /sbin/scsi_id -g -u -s /block/%n (con=
fig=20
> file default)
> Jul 26 10:56:09 | sde: uid =3D 360001ff02002110102a8fe24220f0500 (callo=
ut)
> ...
>=20
Have you tested the 'tur' checker?
I'd generally prefer that one as it doesn't require a disk read ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
