From: "Manu Tayal" <manut@mindtree.com>
Subject: Error while creating mapped device...
Date: Wed, 1 Jun 2005 09:50:59 +0530
Message-ID: <5959EA4638D8734599AB75EAAFBB6FEF03C40073@mtv01ex04.mindtree.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_1D50D_01C5668F.6A1F4D80"
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

------=_NextPart_000_1D50D_01C5668F.6A1F4D80
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



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


------=_NextPart_000_1D50D_01C5668F.6A1F4D80
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
------=_NextPart_000_1D50D_01C5668F.6A1F4D80
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_NextPart_000_1D50D_01C5668F.6A1F4D80--
