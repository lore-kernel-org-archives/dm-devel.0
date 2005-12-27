From: natasha patil <natasha182_pune@yahoo.com>
Subject: "device mapper" patch problem
Date: Tue, 27 Dec 2005 10:00:42 -0800 (PST)
Message-ID: <20051227180042.24402.qmail@web32508.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1158051179=="
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

--===============1158051179==
Content-Type: multipart/alternative; boundary="0-7259836-1135706442=:23893"
Content-Transfer-Encoding: 7bit

--0-7259836-1135706442=:23893
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

 Sir,
              I am using mandrake 10.2 (kernel : 2.6.11-6mdk ),
    which device mapper patch i should download
    because on  website
     there are only 2 patches available :
   =20
    1)   2.4.26-rc1
    2)   2.6.12-rc2-udm1
   =20
    i have tried with 2nd option n followed  commands given on website
   =20
    http://sources.redhat.com/dm/patches.html:
   =20
    > cd /tmp
    > tar jxvf 2.6.12-rc2-udm1.tar.bz2
    > cd /usr/src/2.6.12-rc2-udm1
    > cat /tmp/2.6.12-rc2-udm1/*.patch | patch -p1
   =20
   =20
    i didnt understand 3rd command "cd /usr/src/2.6.12-rc2-udm1"
    my question is :  i untar that file in /tmp folder then how this
    folder is created in /usr/src ?
   =20
    I followed following path :
   =20
    1) i kept that "  2.6.12-rc2-udm1"  in /tmp
    2) cd /tmp
    3)tar jxvf 2.6.12-rc2-udm1.tar.bz2
    4) copy that directory (2.6.12-rc2-udm1) to directory /usr/src
    5) cat  /tmp/2.6.12-rc2-udm1/*.patch | patch -p1
   =20
   =20
    Then it gives me error as :
    cannot find file to patch at input line 6
   =20
    where i am wrong ?
   =20
    So, basically i want to know  which patch i should use ?
    please help me .

	=09
---------------------------------
 Yahoo! DSL Something to write home about. Just $16.99/mo. or less
--0-7259836-1135706442=:23893
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

<div id=3D"RTEContent">&nbsp;Sir,<br>   &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; I am using mandrake 10.2 (kernel : 2.6.11-6mdk ),<=
br>    which device mapper patch i should download<br>    because on&nbsp=
; website<br>     there are only 2 patches available :<br>    <br>    1)&=
nbsp;&nbsp; 2.4.26-rc1<br>    2)&nbsp;&nbsp; 2.6.12-rc2-udm1<br>    <br> =
   i have tried with 2nd option n followed&nbsp; commands given on websit=
e<br>    <br>    http://sources.redhat.com/dm/patches.html:<br>    <br>  =
  &gt; cd /tmp<br>    &gt; tar jxvf 2.6.12-rc2-udm1.tar.bz2<br>    &gt; c=
d /usr/src/2.6.12-rc2-udm1<br>    &gt; cat /tmp/2.6.12-rc2-udm1/*.patch |=
 patch -p1<br>    <br>    <br>    i didnt understand 3rd command "cd /usr=
/src/2.6.12-rc2-udm1"<br>    my question is :&nbsp; i untar that file in =
/tmp folder then how this<br>    folder is created in /usr/src ?<br>    <=
br>    I followed following path :<br>    <br>    1) i kept that "  2.6.1=
2-rc2-udm1"  in /tmp<br>    2) cd /tmp<br>!
    3)tar
 jxvf 2.6.12-rc2-udm1.tar.bz2<br>    4) copy that directory (2.6.12-rc2-u=
dm1) to directory /usr/src<br>    5) cat  /tmp/2.6.12-rc2-udm1/*.patch | =
patch -p1<br>    <br>    <br>    Then it gives me error as :<br>    canno=
t find file to patch at input line 6<br>    <br>    where i am wrong ?<br=
>    <br>    So, basically i want to know  which patch i should use ?<br>=
    please help me .</div><p>
		<hr size=3D1> <a href=3D"http://pa.yahoo.com/*http://us.rd.yahoo.com/ev=
t=3D37474/*http://promo.yahoo.com/broadband/=20
">Yahoo! DSL</a> Something to write home about. Just $16.99/mo. or less
--0-7259836-1135706442=:23893--


--===============1158051179==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1158051179==--
