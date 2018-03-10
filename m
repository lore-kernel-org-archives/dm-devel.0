From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/4] multipath-tools: important fixes for
	0.7.5
Date: Sat, 10 Mar 2018 08:43:20 +0100
Message-ID: <CABr-GncGK5GUoiCV=u5YCGs5E7d4bH3OBE1+LXNkZFByT2NLmA@mail.gmail.com>
References: <20180307230859.14926-1-mwilck@suse.com>
	<b0869201-06de-4d84-10fb-7d395adcba2b@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0727649548248283622=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b0869201-06de-4d84-10fb-7d395adcba2b@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============0727649548248283622==
Content-Type: multipart/alternative; boundary="001a114450341dc7d305670a102a"

--001a114450341dc7d305670a102a
Content-Type: text/plain; charset="UTF-8"

The fixes and missing patches series are now merged.
The version is bumped to 0.7.6.

Thanks,
Christophe.

On Thu, Mar 8, 2018 at 5:04 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 03/08/2018 12:08 AM, Martin Wilck wrote:
> > Hi Christophe,
> >
> > thanks for catching up. This series fixes immediate problems with
> > 0.7.5. The first one corresponds to my previously posted
> > "[PATCH v3 2/2] multipathd: start marginal path checker thread lazily",
> > and fixes a crash. The others fix the problens reported by Xose.
> >
> > Regards
> > Martin
> >
> > Martin Wilck (4):
> >   libmultipath: fix crash on shutdown if io_err thread isn't running
>
> These three:
>
> >   multipathd: fix -Wpointer-to-int-cast warning in uxlsnr
> >   multipath: fix clang warning in delegate_to_multipathd
> >   multipath-tools: build: prevent intermediate file deletion
>
>
> Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>
>
> >  Makefile.inc                       | 1 +
> >  libmultipath/checkers/Makefile     | 2 ++
> >  libmultipath/foreign/Makefile      | 2 ++
> >  libmultipath/io_err_stat.c         | 3 +++
> >  libmultipath/prioritizers/Makefile | 2 ++
> >  multipath/main.c                   | 2 +-
> >  multipathd/uxlsnr.c                | 4 ++--
> >  tests/Makefile                     | 5 ++---
> >  8 files changed, 15 insertions(+), 6 deletions(-)
> >
>
> Merge them ASAP, thanks.
>

--001a114450341dc7d305670a102a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The fixes and missing patches series are now merged.<div>T=
he version is bumped to 0.7.6.</div><div><br></div><div>Thanks,</div><div>C=
hristophe.</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_qu=
ote">On Thu, Mar 8, 2018 at 5:04 PM, Xose Vazquez Perez <span dir=3D"ltr">&=
lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez=
@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">On 03/08/2018 12:08 AM, Martin Wilck wrote:<br>
&gt; Hi Christophe,<br>
&gt;<br>
&gt; thanks for catching up. This series fixes immediate problems with<br>
&gt; 0.7.5. The first one corresponds to my previously posted<br>
&gt; &quot;[PATCH v3 2/2] multipathd: start marginal path checker thread la=
zily&quot;,<br>
&gt; and fixes a crash. The others fix the problens reported by Xose.<br>
&gt;<br>
&gt; Regards<br>
&gt; Martin<br>
&gt;<br>
&gt; Martin Wilck (4):<br>
&gt;=C2=A0 =C2=A0libmultipath: fix crash on shutdown if io_err thread isn&#=
39;t running<br>
<br>
</span>These three:<br>
<span class=3D""><br>
&gt;=C2=A0 =C2=A0multipathd: fix -Wpointer-to-int-cast warning in uxlsnr<br=
>
&gt;=C2=A0 =C2=A0multipath: fix clang warning in delegate_to_multipathd<br>
&gt;=C2=A0 =C2=A0multipath-tools: build: prevent intermediate file deletion=
<br>
<br>
<br>
</span>Tested-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gma=
il.com">xose.vazquez@gmail.com</a>&gt;<br>
<span class=3D""><br>
<br>
&gt;=C2=A0 Makefile.inc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 1 +<br>
&gt;=C2=A0 libmultipath/checkers/Makefile=C2=A0 =C2=A0 =C2=A0| 2 ++<br>
&gt;=C2=A0 libmultipath/foreign/Makefile=C2=A0 =C2=A0 =C2=A0 | 2 ++<br>
&gt;=C2=A0 libmultipath/io_err_stat.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 3 =
+++<br>
&gt;=C2=A0 libmultipath/prioritizers/<wbr>Makefile | 2 ++<br>
&gt;=C2=A0 multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0| 2 +-<br>
&gt;=C2=A0 multipathd/uxlsnr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 | 4 ++--<br>
&gt;=C2=A0 tests/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0| 5 ++---<br>
&gt;=C2=A0 8 files changed, 15 insertions(+), 6 deletions(-)<br>
&gt;<br>
<br>
</span>Merge them ASAP, thanks.<br>
</blockquote></div><br></div>

--001a114450341dc7d305670a102a--


--===============0727649548248283622==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0727649548248283622==--
