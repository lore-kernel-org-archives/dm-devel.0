From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [RFC PATCH 00/16] multipath path classification
Date: Wed, 7 Mar 2018 09:53:23 +0100
Message-ID: <CABr-Gnfw0Trvcr06UCzUC4suQLr1EGi5o5sUnUMJrdRgk8WD2Q@mail.gmail.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6392780862885470190=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============6392780862885470190==
Content-Type: multipart/alternative; boundary="94eb2c05e4b41c7d530566ceb1f5"

--94eb2c05e4b41c7d530566ceb1f5
Content-Type: text/plain; charset="UTF-8"

Martin, Ben,

can you update me on the status of this patchset ?
Is it ready for inclusion ?

Thanks,
Christophe

On Fri, Jan 19, 2018 at 1:29 AM, Martin Wilck <mwilck@suse.com> wrote:

> This patch series implements the recommendation in my recent posting
> "Multipath path classification revisited". My testing has been surprisingly
> successful so far; more testing is of course needed.
> Anyway, I think it's in a shape that I can ask for review.
>
> I've seen Ben's detailed reply to my posting, but his comments haven't been
> taken into account in this series yet.
>
> Benjamin Marzinski (1):
>   libmultipath: trigger change uevent on new device creation
>
> Martin Wilck (15):
>   Revert "multipath: ignore -i if find_multipaths is set"
>   Revert "multipathd: imply -n if find_multipaths is set"
>   libmultipath: add mpvec param to should_multipath()
>   libmultipath: should_multipath: keep existing maps
>   multipath -u -i: change logic for find_multipaths
>   libmultipath: let ignore_wwids be set in config file
>   multipathd: replace -n with !ignore_wwids
>   multipath.conf.5: document "ignore_wwids"
>   multipath.8: adapt documentation of '-i'
>   multipathd.8: document that '-n' is now ignored
>   multipath: common code path for CMD_VALID_PATH
>   multipath -u/-c: change output to environment/key format
>   multipath -u/-c: add "$DEV is maybe a valid path"
>   multipath.rules: find_multipaths+ignore_wwids logic
>   libmultipath: trigger path uevent only when necessary
>
>  libmultipath/config.c      |  1 +
>  libmultipath/config.h      |  1 -
>  libmultipath/configure.c   | 48 ++++++++++++++++++++++++++++++++---
>  libmultipath/configure.h   |  1 +
>  libmultipath/defaults.h    |  1 +
>  libmultipath/dict.c        |  4 +++
>  libmultipath/wwids.c       | 13 +++++++---
>  libmultipath/wwids.h       |  2 +-
>  multipath/main.c           | 58 ++++++++++++++++++++++--------
> ------------
>  multipath/multipath.8      |  3 ++-
>  multipath/multipath.conf.5 | 31 +++++++++++++++++++++++
>  multipath/multipath.rules  | 63 ++++++++++++++++++++++++++++++
> +++++++++++++---
>  multipathd/main.c          | 16 +++---------
>  multipathd/multipathd.8    |  5 ++--
>  14 files changed, 192 insertions(+), 55 deletions(-)
>
> --
> 2.15.1
>
>

--94eb2c05e4b41c7d530566ceb1f5
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Martin, Ben,<div><br></div><div>can you update me on the s=
tatus of this patchset ?</div><div>Is it ready for inclusion ?</div><div><b=
r></div><div>Thanks,</div><div>Christophe</div></div><div class=3D"gmail_ex=
tra"><br><div class=3D"gmail_quote">On Fri, Jan 19, 2018 at 1:29 AM, Martin=
 Wilck <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_=
blank">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">This patch series implements the recommendation in my recent posting<br=
>
&quot;Multipath path classification revisited&quot;. My testing has been su=
rprisingly<br>
successful so far; more testing is of course needed.<br>
Anyway, I think it&#39;s in a shape that I can ask for review.<br>
<br>
I&#39;ve seen Ben&#39;s detailed reply to my posting, but his comments have=
n&#39;t been<br>
taken into account in this series yet.<br>
<br>
Benjamin Marzinski (1):<br>
=C2=A0 libmultipath: trigger change uevent on new device creation<br>
<br>
Martin Wilck (15):<br>
=C2=A0 Revert &quot;multipath: ignore -i if find_multipaths is set&quot;<br=
>
=C2=A0 Revert &quot;multipathd: imply -n if find_multipaths is set&quot;<br=
>
=C2=A0 libmultipath: add mpvec param to should_multipath()<br>
=C2=A0 libmultipath: should_multipath: keep existing maps<br>
=C2=A0 multipath -u -i: change logic for find_multipaths<br>
=C2=A0 libmultipath: let ignore_wwids be set in config file<br>
=C2=A0 multipathd: replace -n with !ignore_wwids<br>
=C2=A0 multipath.conf.5: document &quot;ignore_wwids&quot;<br>
=C2=A0 multipath.8: adapt documentation of &#39;-i&#39;<br>
=C2=A0 multipathd.8: document that &#39;-n&#39; is now ignored<br>
=C2=A0 multipath: common code path for CMD_VALID_PATH<br>
=C2=A0 multipath -u/-c: change output to environment/key format<br>
=C2=A0 multipath -u/-c: add &quot;$DEV is maybe a valid path&quot;<br>
=C2=A0 multipath.rules: find_multipaths+ignore_wwids logic<br>
=C2=A0 libmultipath: trigger path uevent only when necessary<br>
<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 -<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0| 48 +++++++++++++++++++++++++++=
+++<wbr>++---<br>
=C2=A0libmultipath/configure.h=C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 4 +++<br>
=C2=A0libmultipath/wwids.c=C2=A0 =C2=A0 =C2=A0 =C2=A0| 13 +++++++---<br>
=C2=A0libmultipath/wwids.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 2 +-<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 58 +++++++=
+++++++++++++++--------<wbr>------------<br>
=C2=A0multipath/multipath.8=C2=A0 =C2=A0 =C2=A0 |=C2=A0 3 ++-<br>
=C2=A0multipath/multipath.conf.5 | 31 +++++++++++++++++++++++<br>
=C2=A0multipath/multipath.rules=C2=A0 | 63 ++++++++++++++++++++++++++++++<w=
br>+++++++++++++---<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 16 +++---------=
<br>
=C2=A0multipathd/multipathd.8=C2=A0 =C2=A0 |=C2=A0 5 ++--<br>
=C2=A014 files changed, 192 insertions(+), 55 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.15.1<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c05e4b41c7d530566ceb1f5--


--===============6392780862885470190==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6392780862885470190==--
