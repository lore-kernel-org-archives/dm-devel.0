From: "Paul Riddle" <Paul.Riddle@superchoice.com.au>
Subject: Issue with dmsetup
Date: Fri, 31 Oct 2008 12:18:01 +1100
Message-ID: <490AF779.7CED.004D.0@superchoice.com.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1380659978=="
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

--===============1380659978==
Content-Type: multipart/alternative; boundary="=__PartAE86E0D9.0__="

--=__PartAE86E0D9.0__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,=20

I'm in the process of testing and documenting a procedure for a device =
failure on our SAN.=20

We a running with two RHEL 5 nodes talking to a HP MSA2012fc  =20

When I remove a device from the SAN, I'm having a issue with dmsetup =
refusing to remove the old map.=20

Notice mpath8 is in error below.=20


[root@scrac2 ( mailto:[root@scrac2 ) dev]# dmsetup table=20
mpath2: 0 286715904 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
8:16 100 8:176 100=20
mpath1: 0 286713856 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
8:112 100 65:16 100=20
mpath0p10: 0 276671367 linear 253:0 10040688=20
mpath0: 0 286715904 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
8:0 100 8:160 100=20
mpath0p9: 0 2008062 linear 253:0 8032563=20
mpath0p8: 0 2008062 linear 253:0 6024438=20
mpath0p7: 0 2008062 linear 253:0 4016313=20
mpath0p6: 0 2008062 linear 253:0 2008188=20
mpath9: 0 286713856 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
8:144 100 65:48 100=20
mpath0p5: 0 2007999 linear 253:0 126=20
mpath8: 0 286713856 error=20
mpath7: 0 286715904 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
65:64 100 65:80 100=20
mpath6: 0 286713856 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
8:64 100 8:224 100=20
mpath5: 0 286715904 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
8:96 100 65:0 100=20
mpath4: 0 286713856 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
8:48 100 8:208 100=20
mpath10: 0 286715904 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
8:32 100 8:192 100=20
mpath3: 0 286713856 multipath 1 queue_if_no_path 0 1 1 round-robin 0 2 1 =
8:128 100 65:32 100=20


[root@scrac2 ( mailto:[root@scrac2 ) dev]# dmsetup -v remove -f mpath8=20
device-mapper: remove ioctl failed: Device or resource busy=20
Command failed=20


Can anyone offer any help???=20


Regards,=20
Paul.=20





Please consider the environment before you print this email
For email conditions, please see our website  http://www.cps.com.au/email_c=
onditions.htm

--=__PartAE86E0D9.0__=
Content-Type: text/html; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Description: HTML

<html>
  <head>
    <style type=3D"text/css">
      <!--
        body { line-height: normal; margin-top: 4px; font-variant: normal; =
margin-left: 4px; margin-bottom: 1px; margin-right: 4px }
        p { margin-top: 0; margin-bottom: 0 }
      -->
    </style>
   =20
  </head>
  <body>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">Hi&#44; </font>    </p>
<br>     =20
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">I&#39;m in the process of testing =
and documenting a procedure for a device failure on our SAN.</font>    =
</p>
<br>     =20
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">We a running with two RHEL 5 nodes =
talking to a HP MSA2012fc &nbsp;</font>    </p>
<br>     =20
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">When I remove a device from the =
SAN&#44; I&#39;m having a issue with dmsetup refusing to remove the old =
map.</font>    </p>
<br>     =20
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">Notice mpath8 is in error below.</fo=
nt>    </p>
<br>      <br>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <i><a href=3D"mailto:[root@scrac2"><u><font face=3D"Dialog" =
size=3D"2" color=3D"#0000ff">&#91;root@scrac2</font></u></a></i><font =
size=3D"2" face=3D"Dialog">&nbsp;dev&#93;&#35; dmsetup table</font>    =
</p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath2: 0 286715904 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 8:16 100 8:176 100</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath1: 0 286713856 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 8:112 100 65:16 100</font>    =
</p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath0p10: 0 276671367 linear 253:0 =
10040688</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath0: 0 286715904 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 8:0 100 8:160 100</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath0p9: 0 2008062 linear 253:0 =
8032563</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath0p8: 0 2008062 linear 253:0 =
6024438</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath0p7: 0 2008062 linear 253:0 =
4016313</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath0p6: 0 2008062 linear 253:0 =
2008188</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath9: 0 286713856 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 8:144 100 65:48 100</font>    =
</p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath0p5: 0 2007999 linear 253:0 =
126</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath8: 0 286713856 error</font>    =
</p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath7: 0 286715904 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 65:64 100 65:80 100</font>    =
</p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath6: 0 286713856 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 8:64 100 8:224 100</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath5: 0 286715904 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 8:96 100 65:0 100</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath4: 0 286713856 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 8:48 100 8:208 100</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath10: 0 286715904 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 8:32 100 8:192 100</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">mpath3: 0 286713856 multipath 1 =
queue_if_no_path 0 1 1 round-robin 0 2 1 8:128 100 65:32 100</font>    =
</p>
<br>      <br>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <i><a href=3D"mailto:[root@scrac2"><u><font face=3D"Dialog" =
size=3D"2" color=3D"#0000ff">&#91;root@scrac2</font></u></a></i><font =
size=3D"2" face=3D"Dialog">&nbsp;dev&#93;&#35; dmsetup -v remove -f =
mpath8</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">device-mapper: remove ioctl failed: =
Device or resource busy</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">Command failed</font>    </p>
<br>      <br>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">Can anyone offer any help&#63;&#63;&=
#63;</font>    </p>
<br>      <br>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">Regards&#44;</font>    </p>
    <p style=3D"margin-top: 0; margin-bottom: 0">
      <font size=3D"2" face=3D"Dialog">Paul.</font>    </p>
<br>     =20
  <BR>

    <p>
     =20
    </p>
    <p>
     =20
    </p>
    <p>
     =20
    </p>
    <p>
     =20
    </p>
    <p>
     =20
    </p>
    <p>
      <font size=3D"2" face=3D"Verdana">Please consider the environment =
before you=20
      print this email</font>
    </p>
    <p>
      <font size=3D"2" face=3D"Verdana">For email conditions, please see =
our=20
      website </font><a href=3D"http://www.cps.com.au/email_conditions.htm"=
><u><font color=3D"#0000ff" face=3D"Verdana" size=3D"2">
http://www.cps.com.au/email_conditions.htm</font></u></a>
    </p>
  </BODY></HTML>

--=__PartAE86E0D9.0__=--


--===============1380659978==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1380659978==--
