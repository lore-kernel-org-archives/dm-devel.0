From: Rajeh kuri <rajeshkuri@gmail.com>
Subject: Compilation error for dm-ioctl.h
Date: Sat, 21 Jan 2006 17:34:33 +0530
Message-ID: <c26b6f110601210404y5f5921ddycb06458f20a9f1c1@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0343984648=="
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

--===============0343984648==
Content-Type: multipart/alternative;
	boundary="----=_Part_7652_4398662.1137845073411"

------=_Part_7652_4398662.1137845073411
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi All,

 I am trying to do iotcl's on the '/dev/device-mapper' , and written small
program to accomplish this.

But the compiler is throwing the below error message :

/usr/include/linux/dm-ioctl.h:106: error: expected specifier-qualifier-list
before uint32_t
/usr/include/linux/dm-ioctl.h:131: error: expected specifier-qualifier-list
before uint64_t
/usr/include/linux/dm-ioctl.h:160: error: expected specifier-qualifier-list
before uint32_t
/usr/include/linux/dm-ioctl.h:169: error: expected specifier-qualifier-list
before uint64_t
/usr/include/linux/dm-ioctl.h:179: error: expected specifier-qualifier-list
before uint32_t
/usr/include/linux/dm-ioctl.h:189: error: expected specifier-qualifier-list
before uint64_t

The gcc compiler version :  gcc version 4.1.0 20051110 (experimental) (SUSE
Linux)
Linux kernel version        : 2.6.14-2.2

Any pointers/suggetions are greatly appreciated.

-- Regards
rajesh

------=_Part_7652_4398662.1137845073411
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi All,<br>
<br>
&nbsp;I am trying to do iotcl's on the '<span style=3D"font-weight: bold;">=
/dev/device-mapper' , </span>and written small program to accomplish this.<=
br>
<br>
But the compiler is throwing the below error message :<br>
<br>
/usr/include/linux/dm-ioctl.h:106: error: expected specifier-qualifier-list=
 before uint32_t<br>
/usr/include/linux/dm-ioctl.h:131: error: expected specifier-qualifier-list=
 before uint64_t<br>
/usr/include/linux/dm-ioctl.h:160: error: expected specifier-qualifier-list=
 before uint32_t<br>
/usr/include/linux/dm-ioctl.h:169: error: expected specifier-qualifier-list=
 before uint64_t<br>
/usr/include/linux/dm-ioctl.h:179: error: expected specifier-qualifier-list=
 before uint32_t<br>
/usr/include/linux/dm-ioctl.h:189: error: expected specifier-qualifier-list=
 before uint64_t<br>
<br>
The gcc compiler version :&nbsp; gcc version 4.1.0 20051110 (experimental) =
(SUSE Linux)<br>
Linux kernel version&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : 2.6.14-2.2=
<br>
<br>
Any pointers/suggetions are greatly appreciated.<br>
<br>
-- Regards<br>
rajesh<br>
<span style=3D"font-weight: bold;"><span style=3D"font-weight: bold;"></spa=
n><br>
</span><br>
<br>

------=_Part_7652_4398662.1137845073411--


--===============0343984648==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0343984648==--
