From: Hannes Reinecke <hare@suse.de>
Subject: Re: Multipathd not starting up properly
Date: Wed, 30 Aug 2006 09:42:44 +0200
Message-ID: <44F54174.6050803@suse.de>
References: <608c44bf0608291112h1b62eef2hec5ceeb491e9b5b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <608c44bf0608291112h1b62eef2hec5ceeb491e9b5b@mail.gmail.com>
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

Adam Huffman wrote:
> I'm seeing the following messages when I start multipathd:
>=20
> Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s=20
> /block/sda
> Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s=20
> /block/sdb
>=20
> Here is the output of multipath -v 3:
>=20
>=20
[ .. ]
> path checker =3D readsector0 (internal default)
> state =3D 2
> getprio =3D (null) (internal default)
> prio =3D 1
> getuid =3D /sbin/scsi_id -g -u -s /block/%n (internal default)
> error calling out /sbin/scsi_id -g -u -s /block/sda

This is your problem. Somehow 'scsi_id' cannot talk to the drive.
Try 'sg_inq /dev/sda' to find out where the problem is.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
