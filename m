From: "Mallikarjuna C" <Mallikarjuna_C@mindtree.com>
Subject: How to mount initrd file?
Date: Mon, 22 Aug 2005 19:02:24 +0530
Message-ID: <5959EA4638D8734599AB75EAAFBB6FEF04AFA858@mtv01ex04.mindtree.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_2E5E7_01C5A74C.07EF3F00"
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

------=_NextPart_000_2E5E7_01C5A74C.07EF3F00
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

		Hello,
		=09
			I am trying to mount /boot/initrd-2.6X file using a
loop back device. I am facing the following problem.

		Steps which I have executed:

1.	cp /boot/initrd-2.6.11-1.1369_FC4.img /tmp
2.	mkdir /tmp/init
3.	cd /tmp
4.	mv /boot/initrd-2.6.11-1.1369_FC4.img
/boot/initrd-2.6.11-1.1369_FC4.img.gz
5.	gunzip /boot/initrd-2.6.11-1.1369_FC4.img.gz
6.	mount /boot/initrd-2.6.11-1.1369_FC4.img /tmp/init -o loop

		For this mount I am getting error saying
			ioctl: LOOP_CLR_FD: Device or resource busy
			mount: you must specify the filesystem type

		I am using Fedora Core 4.

		What may be the problem?

		Thanks and regards,=20
		Mallikarjuna C
	=09

------=_NextPart_000_2E5E7_01C5A74C.07EF3F00
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
------=_NextPart_000_2E5E7_01C5A74C.07EF3F00
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


------=_NextPart_000_2E5E7_01C5A74C.07EF3F00--
