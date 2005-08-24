From: Jacob Broido <jacob.broido@gmail.com>
Subject: cow snapshot on cloop device
Date: Wed, 24 Aug 2005 13:35:28 +0200
Message-ID: <6262291505082404352d0a4dc2@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1481936235=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1481936235==
Content-Type: multipart/alternative;
	boundary="----=_Part_399_11238481.1124883328109"

------=_Part_399_11238481.1124883328109
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,
I am trying to set a cow snapshot on a cloop device.
I managed to create a snapshot and mount it as read/write, but it appears=
=20
that the data inside the /cloop appears invalid:

Binary executables appear to be invalid, I perfomed diff between files on=
=20
snapshotted /dev/cloop, and the same files accessed directly through cloop.

The files were diffrent,
anyone has idea as to what can be the reason for this?

Thanks

--=20
Not gonna be king of the world if you're slave to the grind
- Skid Row

------=_Part_399_11238481.1124883328109
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,<br>
I am trying to set a cow snapshot on a cloop device.<br>
I managed to create a snapshot and mount it as read/write, but it appears t=
hat the data inside the /cloop appears invalid:<br>
<br>
Binary executables appear to be invalid, I perfomed diff between files
on snapshotted /dev/cloop, and the same files accessed directly through
cloop.<br>
<br>
The files were diffrent,<br>
anyone has idea as to what can be the reason for this?<br>
<br>
Thanks<br clear=3D"all"><br>-- <br>Not gonna be king of the world if you're=
 slave to the grind<br>- Skid Row

------=_Part_399_11238481.1124883328109--


--===============1481936235==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1481936235==--
