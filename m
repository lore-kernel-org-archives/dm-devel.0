From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: New -udm?
Date: Sun, 10 Apr 2005 16:36:53 -0700
Message-ID: <4259B895.4070600@us.ibm.com>
References: <20050410192934.GP12752@marowsky-bree.de>
	<1113164717.8372.2.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1113164717.8372.2.camel@zezette>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

christophe varoqui wrote:
> On dim, 2005-04-10 at 21:29 +0200, Lars Marowsky-Bree wrote:
>=20
>>Hi Alasdair,
>>
>>I'm resync'ing against -udm and would like to pull all recent fixes if
>>possible. Do you have anything more recent than the 2.6.11-rc3-udm2?
>>
>>
>>Sincerely,
>>    Lars Marowsky-Br=C3=A9e <lmb@suse.de>
>>
> There is this hwhandler from Dave Olien, that needs auditing, but is a
> must-have for StorageWorks and FSC FibreCat users.
>=20
> http://christophe.varoqui.free.fr/multipath-tools/dm-scsi-start.patch
>=20
> Would be good to have in an enterprise distro ...
>=20
> Regards,



+static void sstart_pg_init(struct hw_handler *hwh, unsigned bypassed,
+			struct path *path)
+{
+	struct block_device *bdev =3D path->dev->bdev;
+	struct gendisk *disk =3D bdev->bd_disk;
+	struct scsi_device *sdev =3D scsi_disk(disk)->device;
+	int result;
+
+	result =3D scsi_ioctl(sdev, SCSI_IOCTL_START_UNIT, NULL);



is scsi_ioctl depreciated for this use? Besides that I think it=20
allocates memory with GFP_KERNEL which I do not think you want here, and=20
you will want some way to gaurantee you can make forward progress.


+	dm_pg_init_complete(path, result?MP_FAIL_PATH:0);
+}
+
