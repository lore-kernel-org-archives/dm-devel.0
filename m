From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RFC] Emulate BLKRRPART on device-mapper
Date: Wed, 22 Jul 2009 10:19:33 +0200
Message-ID: <4A66CB95.7060806@suse.de>
References: <200907081414.50698.knikanth@suse.de>
	<20090720182324.GD32330@agk-dp.fab.redhat.com>
	<4A65E912.6020706@redhat.com> <4A66BA60.2020500@suse.de>
	<4A66CA08.9080509@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A66CA08.9080509@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Milan Broz wrote:
> Hannes Reinecke wrote:
>>> +	/* partitions handled in userspace, just send change event */
>>> +	if (disk_userspace_partitions(disk)) {
>>> +		kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
>>> +		return 0;
>>> +	}
>>> +
>> Wrong. If you do it here, you'll never be able to catch any size chang=
es
>> of the disk. You'll have to move it to after the 'bdev->bd_invalidated=
 =3D 0'
>> line.
>=20
> Yes, for non-DM devices which want to use that flag.
>=20
> For device-mapper device, size can change only by mapping table change
> which always generate change uevent.
>=20
Okay. But the whole point of my objections is to make the flag useable
for the general populace, so that my second patch can take advantage
of it.

>> I would suggest renaming it to GENHD_FL_USERSPACE_PARTITIONS, as this =
is
>> more in line with the function of the flag.
>=20
> no problem here:-)
Hmm. I've send an updated patch, but it seems to be stuck in the mailqueu=
e
somewhere.
The second patch went through, though ... curious.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
