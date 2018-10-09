From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/1] Fix kpart -d regression where matching
	devices not found
Date: Tue, 9 Oct 2018 15:35:44 +0200
Message-ID: <CABr-GndkEebenFWx7NSurpuKO0qp+N6QZdDySPXdAPOix1e4xg@mail.gmail.com>
References: <e3447c24-a42c-0abd-ea8f-963ae25749f2@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8775178876093967900=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e3447c24-a42c-0abd-ea8f-963ae25749f2@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: stefw@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8775178876093967900==
Content-Type: multipart/alternative; boundary="0000000000003f38a60577cbd161"

--0000000000003f38a60577cbd161
Content-Type: text/plain; charset="UTF-8"

Hi Steph, Xose,

I have this patch in the queue, no worry.
pending a "reviewed-by" though.

Best regards,
Christophe.

On Tue, Oct 9, 2018 at 2:38 PM Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Stef Walter wrote:
>
> You should send(CC:) it also to Christophe.
>
> > The Lorax project found a regression in kpartx -d behavior introduced
> > by the following commit: 9bdfa3eb8e24b668e6c2bb882cddb0ccfe23ed5b
> >
> > This patch should fix the problem. It's easy to reproduce this problem
> > (I did it on Fedora 28) with the following commands:
> >
> >         # kpartx -av disk.img
> >         ...
> >         # kpartx -dv disk.img
> >
> > Notice that the loop devices and partition mappings created by the first
> > command are not cleaned up by the second command.
> >
> > Stef Walter (1):
> >   kpartx: Use absolute paths to create mappings
> >
> >  kpartx/kpartx.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
>

--0000000000003f38a60577cbd161
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Steph, Xose,<div><br></div><div>I have this patch in th=
e queue, no worry.</div><div>pending a &quot;reviewed-by&quot; though.</div=
><div><br></div><div>Best regards,</div><div>Christophe.</div></div><br><di=
v class=3D"gmail_quote"><div dir=3D"ltr">On Tue, Oct 9, 2018 at 2:38 PM Xos=
e Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.com">xose.vazquez@=
gmail.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Stef Wal=
ter wrote:<br>
<br>
You should send(CC:) it also to Christophe.<br>
<br>
&gt; The Lorax project found a regression in kpartx -d behavior introduced<=
br>
&gt; by the following commit: 9bdfa3eb8e24b668e6c2bb882cddb0ccfe23ed5b<br>
&gt; <br>
&gt; This patch should fix the problem. It&#39;s easy to reproduce this pro=
blem<br>
&gt; (I did it on Fedora 28) with the following commands:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# kpartx -av disk.img<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0...<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0# kpartx -dv disk.img<br>
&gt; <br>
&gt; Notice that the loop devices and partition mappings created by the fir=
st<br>
&gt; command are not cleaned up by the second command.<br>
&gt; <br>
&gt; Stef Walter (1):<br>
&gt;=C2=A0 =C2=A0kpartx: Use absolute paths to create mappings<br>
&gt; <br>
&gt;=C2=A0 kpartx/kpartx.c | 2 +-<br>
&gt;=C2=A0 1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
</blockquote></div>

--0000000000003f38a60577cbd161--


--===============8775178876093967900==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8775178876093967900==--
