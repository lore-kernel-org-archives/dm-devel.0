From: Amitai Alkalay <amitai.alkalay.work@gmail.com>
Subject: Fwd: multipath errors
Date: Mon, 23 Sep 2013 11:09:18 +0300
Message-ID: <CAFtbanFoqNoSayniWmV=1k7nB+uk8wcyFek32OXDMN+RJTbsxg@mail.gmail.com>
References: <CAFtbanG05NuiQCiZd0v+TEVW+5dUnn=-LZzoewrY0roFq0L7HQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5333746599726960707=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAFtbanG05NuiQCiZd0v+TEVW+5dUnn=-LZzoewrY0roFq0L7HQ@mail.gmail.com>
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

--===============5333746599726960707==
Content-Type: multipart/alternative; boundary=047d7b2e4d7c6bdc4204e708898a

--047d7b2e4d7c6bdc4204e708898a
Content-Type: text/plain; charset=ISO-8859-1

Hi,
Sorry for bumping, but I will appreciate any help on this matter..

Thanks,
Amitai

---------- Forwarded message ----------
From: Amitai Alkalay <amitai.alkalay.work@gmail.com>
Date: Tue, Sep 10, 2013 at 2:29 PM
Subject: multipath errors
To: dm-devel@redhat.com


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

--047d7b2e4d7c6bdc4204e708898a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div>Sorry for bumping, but I will appreciate any help =
on this matter..</div><div><br></div><div>Thanks,</div><div>Amitai<br><br><=
div class=3D"gmail_quote">---------- Forwarded message ----------<br>From: =
<b class=3D"gmail_sendername">Amitai Alkalay</b> <span dir=3D"ltr">&lt;<a h=
ref=3D"mailto:amitai.alkalay.work@gmail.com">amitai.alkalay.work@gmail.com<=
/a>&gt;</span><br>
Date: Tue, Sep 10, 2013 at 2:29 PM<br>Subject: multipath errors<br>To: <a h=
ref=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><br><br><div =
dir=3D"ltr"><font face=3D"verdana, sans-serif">hi,</font><div><font face=3D=
"verdana, sans-serif"><br>
</font></div><div><font face=3D"verdana, sans-serif">I sometimes see cases =
where io failed after some path failover, although there are other valid pa=
ths.</font></div>
<div><font face=3D"verdana, sans-serif"><br></font></div><div><font face=3D=
"verdana, sans-serif">I seem to get a lot of the following errors during a =
path removal (failover):</font></div><div><pre style=3D"margin-right:1.75em=
;font-size:13px;overflow:auto;margin-left:1.75em;background-color:rgb(247,2=
47,247);padding:0.25em;border:1px solid rgb(215,215,215)">
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
</pre></div><div><font face=3D"verdana, sans-serif"><span style>All the oth=
er paths are there, and still multipath decided to fail the io with no appa=
rent reason.=A0</span><br style><br>
I would appreciate any comment about:<br><br style><span style>1. How can t=
his happen.</span><br style><span style>2. How can I increase the log level=
 to understand multipath decisions.</span><br style>
<span style>3. Why do I always see the errors regarding adding target to ta=
ble.</span><br style><span style>The only thing I can think think about, th=
at multipath temporarily bypassed the other paths (maybe it got busy severa=
l times and gave up).</span><br>

</font></div><div><span style=3D"font-family:Verdana,Arial,&#39;Bitstream V=
era Sans&#39;,Helvetica,sans-serif"><br></span></div><div><span style=3D"fo=
nt-family:Verdana,Arial,&#39;Bitstream Vera Sans&#39;,Helvetica,sans-serif"=
>I&#39;m using=A0</span><font color=3D"#000000" face=3D"Verdana, Arial, Bit=
stream Vera Sans, Helvetica, sans-serif">device-mapper-multipath-0.4.9-64.e=
l6.x86_64.</font></div>

<div><span style=3D"font-family:Verdana,Arial,&#39;Bitstream Vera Sans&#39;=
,Helvetica,sans-serif"><br></span></div><div><span style=3D"font-family:Ver=
dana,Arial,&#39;Bitstream Vera Sans&#39;,Helvetica,sans-serif">Thanks a lot=
,</span></div>

<div><span style=3D"font-family:Verdana,Arial,&#39;Bitstream Vera Sans&#39;=
,Helvetica,sans-serif">Amitai</span></div></div>
</div><br></div></div>

--047d7b2e4d7c6bdc4204e708898a--


--===============5333746599726960707==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5333746599726960707==--
