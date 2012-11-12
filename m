From: Hiro Lalwani <lalwanihiro@gmail.com>
Subject: info : Multipathing
Date: Mon, 12 Nov 2012 16:58:35 +0530
Message-ID: <CAMgMJNKsdnNmyGNSgWo1t3=rhnjKc9GxWX1HodVHk+pscYYc6g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5255768608729957297=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============5255768608729957297==
Content-Type: multipart/alternative; boundary=14dae947308b1dced904ce4a9a27

--14dae947308b1dced904ce4a9a27
Content-Type: text/plain; charset=ISO-8859-1

Hi,

My system have multipath configuration but I have not enable the Multipath
but just load the DM module.

I need some info,  consider

/dev/sdc

/dev/sdf

both are targeting to same disk, but I have not enable the Multipathing
only the configuration is there,. when I run the command /dev/disk/by-id/,
it will show either of one disk "/dev/sdc/ or /dev/sdf...

so, what I will need to do, so that /dev/disk/by-id.. will show that both
path...

regards

--14dae947308b1dced904ce4a9a27
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<span style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:1=
3px;background-color:rgb(255,255,255)">Hi,</span><div style=3D"color:rgb(34=
,34,34);font-family:arial,sans-serif;font-size:13px;background-color:rgb(25=
5,255,255)">
<br></div><div style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;fo=
nt-size:13px;background-color:rgb(255,255,255)">My system have multipath co=
nfiguration but I have not enable the Multipath but just load the DM module=
.</div>
<div style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:13=
px;background-color:rgb(255,255,255)"><br></div><div style=3D"color:rgb(34,=
34,34);font-family:arial,sans-serif;font-size:13px;background-color:rgb(255=
,255,255)">
I need some info, =A0consider=A0</div><div style=3D"color:rgb(34,34,34);fon=
t-family:arial,sans-serif;font-size:13px;background-color:rgb(255,255,255)"=
><br></div><div style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;f=
ont-size:13px;background-color:rgb(255,255,255)">
/dev/sdc</div><div style=3D"color:rgb(34,34,34);font-family:arial,sans-seri=
f;font-size:13px;background-color:rgb(255,255,255)"><br></div><div style=3D=
"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:13px;background=
-color:rgb(255,255,255)">
/dev/sdf</div><div style=3D"color:rgb(34,34,34);font-family:arial,sans-seri=
f;font-size:13px;background-color:rgb(255,255,255)"><br></div><div style=3D=
"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:13px;background=
-color:rgb(255,255,255)">
both are targeting to same disk, but I have not enable the Multipathing onl=
y the configuration is there,. when I run the command /dev/disk/by-id/, it =
will show either of one disk &quot;/dev/sdc/ or /dev/sdf...=A0</div><div st=
yle=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:13px;back=
ground-color:rgb(255,255,255)">
<br></div><div style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;fo=
nt-size:13px;background-color:rgb(255,255,255)">so, what I will need to do,=
 so that /dev/disk/by-id.. will show that both path... =A0</div><div style=
=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:13px;backgro=
und-color:rgb(255,255,255)">
<br></div><div style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;fo=
nt-size:13px;background-color:rgb(255,255,255)">regards</div>

--14dae947308b1dced904ce4a9a27--


--===============5255768608729957297==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5255768608729957297==--
