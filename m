From: Frederick Grose <fgrose@gmail.com>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Sun, 27 Nov 2011 17:31:25 -0500
Message-ID: <CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>
References: <4EABE131.8010706@googlemail.com>
	<20111029204947.GU23336@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1733866075087026068=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111029204947.GU23336@agk-dp.fab.redhat.com>
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

--===============1733866075087026068==
Content-Type: multipart/alternative; boundary=000e0ce0d998bae9cb04b2bef48a

--000e0ce0d998bae9cb04b2bef48a
Content-Type: text/plain; charset=ISO-8859-1

On Sat, Oct 29, 2011 at 4:49 PM, Alasdair G Kergon <agk@redhat.com> wrote:

> markmc did some code that shows how to read the format a few years ago
> here:
> http://people.gnome.org/~markmc/code/merge-dm-snapshot.c
>
> Otherwise look at dm-snap-persistent.c in the kernel tree.
>
> Alasdair


Users can easily exhaust a LiveUSB snapshot overlay by writing
too many changes to the OS filesystem, such as by performing
a yum update.

Would such an 'exhausted' overlay be amenable to some sort of
data recovery or forensics?

If so, how so; if not, why not?

(or suitable references)

Thanks,         --Fred

--000e0ce0d998bae9cb04b2bef48a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<font color=3D"#000099"><font size=3D"2"><font face=3D"trebuchet ms,sans-se=
rif"></font></font></font>On Sat, Oct 29, 2011 at 4:49 PM, Alasdair G Kergo=
n <span dir=3D"ltr">&lt;<a href=3D"mailto:agk@redhat.com">agk@redhat.com</a=
>&gt;</span> wrote:<br>

<div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">markmc did some =
code that shows how to read the format a few years ago here:<br>
<a href=3D"http://people.gnome.org/%7Emarkmc/code/merge-dm-snapshot.c" targ=
et=3D"_blank">http://people.gnome.org/~markmc/code/merge-dm-snapshot.c</a><=
br>
<br>
Otherwise look at dm-snap-persistent.c in the kernel tree.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Alasdair</font></span></blockquote><div><br><font color=3D"#000099"><font s=
ize=3D"2"><font face=3D"trebuchet ms,sans-serif"><span style=3D"font-family=
: courier new,monospace; color: rgb(0, 0, 0);"><font face=3D"courier new,mo=
nospace">Users can easily exhaust a LiveUSB snapshot overlay by writing<br>

too many changes to the OS filesystem, such as by performing<br>a yum updat=
e.<br><br>Would such an &#39;exhausted&#39; overlay be amenable to some sor=
t of<br>data recovery or forensics?<br><br>If so, how so; if not, why not?<=
br>

<br>(or suitable references)<br><br>Thanks,=A0=A0=A0=A0=A0=A0=A0=A0 --Fred<=
br>
        </font></span></font></font></font></div></div>

--000e0ce0d998bae9cb04b2bef48a--


--===============1733866075087026068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1733866075087026068==--
