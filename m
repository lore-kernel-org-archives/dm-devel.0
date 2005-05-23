From: "Manu Tayal" <manut@mindtree.com>
Subject: Error writing to linear mapped device...
Date: Mon, 23 May 2005 10:51:08 +0530
Message-ID: <5959EA4638D8734599AB75EAAFBB6FEF03B35717@mtv01ex04.mindtree.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_25FF_01C55F85.5367D550"
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------=_NextPart_000_25FF_01C55F85.5367D550
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi All,
I tried the following steps:
1) Set up a loopback device
	# dd if=3D/dev/zero of=3D/tmp/store1 bs=3D1024 seek=3D2047 count=3D1
	# losetup /dev/loop1 /tmp/store1
	# mke2fs /dev/loop1
	# mount /dev/loop1 /mnt/loopdev

2) Create a linearly mapped device for the loopback device
	# echo 0 $(blockdev --getsize /dev/loop1) linear /dev/loop1 0 |
dmsetup create new
	# mount /dev/mapper/new /mnt/new

Both the devices created and mounted now refer to the same physical =
device.

3) Write to both the devices separately:
      # touch /mnt/loopdev/a.txt
      # touch /mnt/new/b.txt

OBSERVATION:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1) The file created in /mnt/loopdev is not visible under /mnt/new and
vice-versa. Thought, it might be due to the buffers maintained by =
devices.
"sync" did not help in flushing.
2) On unmounting the devices and mounting it again gives unpredictable
results:
	a. Sometimes, a.txt is visible at both the places, with b.txt missing
at both places.
	b. Sometimes, b.txt is visible at both the places, with a.txt missing
at both places.
	c. Sometimes, I get "Input/output" error in one of the mount points.

Questions:
=3D=3D=3D=3D=3D=3D=3D=3D=3D
1) Can somebody explain the behavior?
2) Once a linear mapping is created for /dev/loop1 as /dev/mapper/new, =
how
can I prevent the user from using /dev/loop1 and always use =
/dev/mapper/new
for all the reads and writes?=20
3) What happens to all the open connections to files being used for
/dev/loop1 after I have mapped it to /dev/mapper/new?


Thanks and Regards,
Manu.


------=_NextPart_000_25FF_01C55F85.5367D550
Content-Type: text/plain;
	name="disclaimer.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="disclaimer.txt"

-------------------------------------------------------------------------=
----------------------------------------------------
Disclaimer
-------------------------------------------------------------------------=
----------------------------------------------------

"This message(including attachment if any)is confidential and may be =
privileged.Before opening attachments please check them
for viruses and defects.MindTree Consulting Private Limited =
(MindTree)will not be responsible for any viruses or defects or
any forwarded attachments emanating either from within MindTree or =
outside.If you have received this message by mistake please notify the =
sender by return  e-mail and delete this message from your system. Any =
unauthorized use or dissemination of this message in whole or in part is =
strictly prohibited.  Please note that e-mails are susceptible to change =
and MindTree shall not be liable for any improper, untimely or =
incomplete transmission."

-------------------------------------------------------------------------=
----------------------------------------------------
------=_NextPart_000_25FF_01C55F85.5367D550
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_NextPart_000_25FF_01C55F85.5367D550--
