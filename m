From: "Manu Tayal" <manut@mindtree.com>
Subject: RE: Error while creating mapped device...
Date: Wed, 1 Jun 2005 13:58:42 +0530
Message-ID: <5959EA4638D8734599AB75EAAFBB6FEF03C401D0@mtv01ex04.mindtree.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_21B51_01C566B2.0564C870"
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
To: Manu Tayal <manut@mindtree.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

------=_NextPart_000_21B51_01C566B2.0564C870
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The version of Linux I am using is 2.4.26 and the version of =
device-mapper is
1.00.18.

Do let me know if any more information is required.

Thanks
Manu

-----Original Message-----
From: Manu Tayal=20
Sent: Wednesday, June 01, 2005 1:54 PM
To: 'dm-devel@redhat.com'
Subject: RE: Error while creating mapped device...

Another piece of information:

I found the logs as:

	Device-mapper: device /dev/hda1 too small for target
	Device-mapper: dm-linear: Device lookup failed
	Device-mapper: error adding target to table

	Device-mapper: device /dev/hda5 too small for target
	Device-mapper: dm-linear: Device lookup failed
	Device-mapper: error adding target to table

So there seems to be some size problem.

	blockdev --getsize /dev/hda1		=3D 2041137
	blockdev --getsize /dev/hda5		=3D 1043217

Is there a limitation on the size of the device or is this a bug?

Regards,
Manu.


-----Original Message-----
From: Manu Tayal=20
Sent: Wednesday, June 01, 2005 9:51 AM
To: 'dm-devel@redhat.com'
Subject: Error while creating mapped device...



Hi,
I wanted to create a mapped device for all the physical partitions on my
disk. Following is the partition information:

	/dev/hda1		/boot
	/dev/hda2		/
	/dev/hda3		/home
	/dev/hda5		swap

I am using device-mapper to create the mapped device. I execute the =
following
command:

	#echo 0 $(blockdev --getsize /dev/hda1) linear /dev/hda1 0=20
					| dmsetup create hda1

I am doing the same thing for all the devices. I am able to create =
mapped
devices for /dev/hda2 and /dev/hda3. But /dev/hda1 and /dev/hda5 give me =
the
following error:

		device-mapper ioctl cmd 9 failed: Invalid argument

I am unable to understand as to why should hda1 and hda5 behave =
differently.
Any help is appreciated.

Regards,
Manu


------=_NextPart_000_21B51_01C566B2.0564C870
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
------=_NextPart_000_21B51_01C566B2.0564C870
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_NextPart_000_21B51_01C566B2.0564C870--
