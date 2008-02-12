From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: How to Resize Partition
Date: Tue, 12 Feb 2008 11:08:41 -0500
Message-ID: <1D80D4F6D179BD4D869FE807A5BF8336018C6C00@EXCNYSM0A1AN.nysemail.nyenet>
References: <342d47870802120730h324dff50ic68f58a2fc20a98@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
In-Reply-To: <342d47870802120730h324dff50ic68f58a2fc20a98@mail.gmail.com>
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

Maybe you're confusing the /san filesystem size with its partition's new
size?
Assuming the /san fs is ext2 or ext3, make the old /san fs aware of its
partition's enlarged size by doing these:
umount /san
e2fsck -f  /dev/mapper/mpath0p1
resize2fs /dev/mapper/mpath0p1
mount /dev/mapper/mpath0p1 /san
df -h /san


--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.


-----Original Message-----

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Scott Moseman
Sent: Tuesday, February 12, 2008 10:31 AM
To: device-mapper development
Subject: [dm-devel] How to Resize Partition

This is the original size of my partition, 50GB...

# df -h | grep mpath
/dev/mapper/mpath0p1   50G  2.1G   45G   5% /san

I increased it to 60GB and am trying to resize.  Through my
troubleshooting and various attempts, I've increased /dev/sdb1 (NIC),
/dev/sdc1 (HBA) and /dev/mapper/mpath0p1 (MPIO).

Disk /dev/sdb: 64.4 GB, 64424509440 bytes
/dev/sdb1               1       61440    62914544   83  Linux

Disk /dev/sdc: 64.4 GB, 64424509440 bytes
/dev/sdc1               1       61440    62914544   83  Linux

Disk /dev/mapper/mpath0: 64.4 GB, 64424509440 bytes
/dev/mapper/mpath0p1               1       61440    62914544   83  Linux

I unmount/mount, reboot, etc and the mounted partition keeps showing
up as 50GB.  How do I get my additional 10GB?  This is on a CentOS 4.5
server.

Thanks,
Scott

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
