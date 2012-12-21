From: Frederick Grose <fgrose@gmail.com>
Subject: Re: How to force a snapshot status to valid when I know
 very well it's valid?
Date: Fri, 21 Dec 2012 10:46:18 -0800
Message-ID: <CAEcBt+UtiFrBw778r85JfZi7FegEgO6nXxkyoAUPRGXnvFXhmQ@mail.gmail.com>
References: <CAM-w4HM0-Cov_KtRE410etrh+v795tsPX1UM9WkV-o4MXaQBAQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1011562882097801844=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAM-w4HM0-Cov_KtRE410etrh+v795tsPX1UM9WkV-o4MXaQBAQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1011562882097801844==
Content-Type: multipart/alternative; boundary=20cf307f32b0b55bc104d1614575

--20cf307f32b0b55bc104d1614575
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Dec 21, 2012 at 10:31 AM, Greg Stark <stark@mit.edu> wrote:

> I have a snapshot whose cow table became full. I understand full well
> why snapshots become invalid at this point but the source volume was
> not mounted anywhere and hasn't been written to. I can add more space
> to the cow table now but is there any way to force the status to be
> valid again?
>
> --
> greg


See
https://fedoraproject.org/wiki/LiveOS_image#Overlay_recovery

    --Fred

--20cf307f32b0b55bc104d1614575
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 21, 2012 at 10:31 AM, Greg Stark <span dir=3D"ltr">&lt;<a href=
=3D"mailto:stark@mit.edu" target=3D"_blank">stark@mit.edu</a>&gt;</span> wr=
ote:<br><div class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

I have a snapshot whose cow table became full. I understand full well<br>
why snapshots become invalid at this point but the source volume was<br>
not mounted anywhere and hasn&#39;t been written to. I can add more space<b=
r>
to the cow table now but is there any way to force the status to be<br>
valid again?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
greg</font></span></blockquote><div><br></div><div>See</div><div><a href=3D=
"https://fedoraproject.org/wiki/LiveOS_image#Overlay_recovery">https://fedo=
raproject.org/wiki/LiveOS_image#Overlay_recovery</a></div><div><br></div>

<div>=A0 =A0 --Fred=A0</div></div>

--20cf307f32b0b55bc104d1614575--


--===============1011562882097801844==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1011562882097801844==--
