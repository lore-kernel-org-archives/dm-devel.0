From: Hannes Reinecke <hare@suse.de>
Subject: Re: Failed path will not be recovered when
	disabling/enabling remote port
Date: Thu, 02 Jul 2009 13:44:18 +0200
Message-ID: <4A4C9D92.1020808@suse.de>
References: <4A4C998F.7010602@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A4C998F.7010602@linux.vnet.ibm.com>
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

Christian May wrote:
> Hi,
>=20
> I've setup an IBM z10 LPAR (mainframe server) with 2.6.30-kernel.
> Attached to the System z10 was an IBM DS8000 storage server. 10x SCSI
> LUNs were assigned to LPAR via two pathes:
>=20
> Example:
> 36005076303ffc1040000000000001269 dm-9 IBM,2107900
> size=3D1.0G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
> `-+- policy=3D'round-robin 0' prio=3D-2 status=3Dactive
>  |- 0:0:0:1080639506 sdw   65:96  active undef running
>  `- 1:0:1:1080639506 sdt   65:48  active undef running
>=20
> Special parameter setting: dev_loss_tmo=3D90sec; fast_io_fail_tmo=3D5se=
c
>=20
> multipath tools: multipath-tools v0.4.9 (04/04, 2009)
> device-mapper: device-mapper-1.02.27-7.fc10.s390x,
> device-mapper-libs-1.02.27-7.fc10.s390x
>=20
> When removing a remote port (disabling a port on the BROCADE FC switch)
> one path failed.
>=20
> root@h42lp26/ESAME:~]
>> multipath -l
> 36005076303ffc1040000000000001268 dm-8 ,
> size=3D1.0G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
> `-+- policy=3D'round-robin 0' prio=3D-2 status=3Dactive
>  |- #:#:#:#          -     #:#   failed undef running
>  `- 1:0:1:1080573970 sdr   65:16 active undef running
>=20
> After a while (>90sec) SCSI LUNs were removed from system:
>=20
[ .. ]
>=20
> When re-enabling the path, SCSI LUNS were reassigned to system but path
> didn't recover:
>=20
[ .. ]

>=20
>=20
> [root@h42lp26/ESAME:~]
>> multipath -l
> 36005076303ffc1040000000000001268 dm-8 ,
> size=3D1.0G features=3D'1 queue_if_no_path' hwhandler=3D'0' wp=3Drw
> `-+- policy=3D'round-robin 0' prio=3D-2 status=3Dactive
>  |- #:#:#:#          -     #:#    failed undef running
>  `- 1:0:1:1080573970 sdr   65:16  active undef running
>=20
>=20
> Running "multipath" command will recover the failed path but that's not
> way it should be...can somebody help to fix this? Why is the path not
> recovered automatically?
>=20
It should, really.

The problem is that the paths have _not_ been reconnected;
the hashes indicates that the in-kernel multipath code references
a device for which no information is available.
And the new device has _not_ been reconnected, as otherwise
you'd end up with _three_ paths here.

Probably missing udev integration.

I really have to push my patches upstream ... sigh.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
