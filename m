From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Subject: bdev lost its queue
Date: Mon, 01 Sep 2008 15:48:18 +0200
Message-ID: <48BBF2A2.6040104@linux.vnet.ibm.com>
Reply-To: raspl@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
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

We conducted a bunch tests where we used various ways to forcefully=20
disconnect or temporarily disable DASD disks from an IBM System z=20
machine. In the course we ran into a kernel panic in=20
dm_table_unplug_all() (dm-table.c), specifically at

     struct request_queue *q =3D bdev_get_queue(dd->bdev);
     blk_unplug(q);

since the queue of the bdev was NULL.
Did anyone see a crash in this place before? And are there other disk=20
drivers to can set their queue to NULL due to unplugging/outages or simil=
ar?

Best regards,
Stefan

--=20
Linux on System z
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrer: Erich Baier
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
