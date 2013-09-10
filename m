From: Amitai Alkalay <amitai.alkalay.work@gmail.com>
Subject: multipath errors
Date: Tue, 10 Sep 2013 14:29:52 +0300
Message-ID: <CAFtbanG05NuiQCiZd0v+TEVW+5dUnn=-LZzoewrY0roFq0L7HQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7467346147983095443=="
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

--===============7467346147983095443==
Content-Type: multipart/alternative; boundary=089e0158aa9ad1051d04e605d2fa

--089e0158aa9ad1051d04e605d2fa
Content-Type: text/plain; charset=ISO-8859-1

hi,

I sometimes see cases where io failed after some path failover, although
there are other valid paths.

I seem to get a lot of the following errors during a path removal
(failover):

Aug  1 08:59:37 lg641 multipathd: 3514f0c532d80000a: failed in domap
for removal of path sdcy
Aug  1 08:59:37 lg641 multipathd: uevent trigger error
Aug  1 08:59:37 lg641 multipathd: sdt: remove path (uevent)
Aug  1 08:59:37 lg641 kernel: device-mapper: table: 253:5: multipath:
error getting device
Aug  1 08:59:37 lg641 kernel: device-mapper: ioctl: error adding target to table
Aug  1 08:59:37 lg641 multipathd: 3514f0c532d800001: load table [0
21474836480 multipath 0 0 1 1 queue-length 0 12 1 66:240 1 66:80 1
70:192 1 71:96 1 67:176 1 67:112 1 71:224 1 128:128 1 8:
16 1 69:16 1 69:32 1 8:32 1]
Aug  1 08:59:37 lg641 multipathd: sdt: path removed from map 3514f0c532d800001f

All the other paths are there, and still multipath decided to fail the io
with no apparent reason.

I would appreciate any comment about:

1. How can this happen.
2. How can I increase the log level to understand multipath decisions.
3. Why do I always see the errors regarding adding target to table.
The only thing I can think think about, that multipath temporarily bypassed
the other paths (maybe it got busy several times and gave up).

I'm using device-mapper-multipath-0.4.9-64.el6.x86_64.

Thanks a lot,
Amitai

--089e0158aa9ad1051d04e605d2fa
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><font face=3D"verdana, sans-serif">hi,</font><div><font fa=
ce=3D"verdana, sans-serif"><br></font></div><div><font face=3D"verdana, san=
s-serif">I sometimes see cases where io failed after some path failover, al=
though there are other valid paths.</font></div>
<div><font face=3D"verdana, sans-serif"><br></font></div><div><font face=3D=
"verdana, sans-serif">I seem to get a lot of the following errors during a =
path removal (failover):</font></div><div><pre class=3D"" style=3D"backgrou=
nd-color:rgb(247,247,247);border:1px solid rgb(215,215,215);margin-right:1.=
75em;margin-left:1.75em;padding:0.25em;overflow:auto;color:rgb(0,0,0);font-=
size:13px">
Aug  1 08:59:37 lg641 multipathd: 3514f0c532d80000a: failed in domap for re=
moval of path sdcy
Aug  1 08:59:37 lg641 multipathd: uevent trigger error
Aug  1 08:59:37 lg641 multipathd: sdt: remove path (uevent)
Aug  1 08:59:37 lg641 kernel: device-mapper: table: 253:5: multipath: error=
 getting device
Aug  1 08:59:37 lg641 kernel: device-mapper: ioctl: error adding target to =
table
Aug  1 08:59:37 lg641 multipathd: 3514f0c532d800001: load table [0 21474836=
480 multipath 0 0 1 1 queue-length 0 12 1 66:240 1 66:80 1 70:192 1 71:96 1=
 67:176 1 67:112 1 71:224 1 128:128 1 8:
16 1 69:16 1 69:32 1 8:32 1]
Aug  1 08:59:37 lg641 multipathd: sdt: path removed from map 3514f0c532d800=
001f
</pre></div><div><font face=3D"verdana, sans-serif"><span style=3D"color:rg=
b(0,0,0)">All the other paths are there, and still multipath decided to fai=
l the io with no apparent reason.=A0</span><br style=3D"color:rgb(0,0,0)"><=
br>
I would appreciate any comment about:<br><br style=3D"color:rgb(0,0,0)"><sp=
an style=3D"color:rgb(0,0,0)">1. How can this happen.</span><br style=3D"co=
lor:rgb(0,0,0)"><span style=3D"color:rgb(0,0,0)">2. How can I increase the =
log level to understand multipath decisions.</span><br style=3D"color:rgb(0=
,0,0)">
<span style=3D"color:rgb(0,0,0)">3. Why do I always see the errors regardin=
g adding target to table.</span><br style=3D"color:rgb(0,0,0)"><span style=
=3D"color:rgb(0,0,0)">The only thing I can think think about, that multipat=
h temporarily bypassed the other paths (maybe it got busy several times and=
 gave up).</span><br>
</font></div><div><span style=3D"color:rgb(0,0,0);font-family:Verdana,Arial=
,&#39;Bitstream Vera Sans&#39;,Helvetica,sans-serif"><br></span></div><div>=
<span style=3D"color:rgb(0,0,0);font-family:Verdana,Arial,&#39;Bitstream Ve=
ra Sans&#39;,Helvetica,sans-serif">I&#39;m using=A0</span><font color=3D"#0=
00000" face=3D"Verdana, Arial, Bitstream Vera Sans, Helvetica, sans-serif">=
device-mapper-multipath-0.4.9-64.el6.x86_64.</font></div>
<div><span style=3D"color:rgb(0,0,0);font-family:Verdana,Arial,&#39;Bitstre=
am Vera Sans&#39;,Helvetica,sans-serif"><br></span></div><div><span style=
=3D"color:rgb(0,0,0);font-family:Verdana,Arial,&#39;Bitstream Vera Sans&#39=
;,Helvetica,sans-serif">Thanks a lot,</span></div>
<div><span style=3D"color:rgb(0,0,0);font-family:Verdana,Arial,&#39;Bitstre=
am Vera Sans&#39;,Helvetica,sans-serif">Amitai</span></div></div>

--089e0158aa9ad1051d04e605d2fa--


--===============7467346147983095443==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7467346147983095443==--
