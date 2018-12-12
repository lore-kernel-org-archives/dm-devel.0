From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/1] update to v2 Fix false removes
Date: Wed, 12 Dec 2018 01:11:47 +0100
Message-ID: <CABr-Gnd1yr7z_0OPjvZ3j+P1UiTMsDfqkgQo0sRddPQv0rVS8g@mail.gmail.com>
References: <1544563384-9721-1-git-send-email-bmarzins@redhat.com>
	<20181211234748.GB11315@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5176953801161019503=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181211234748.GB11315@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5176953801161019503==
Content-Type: multipart/alternative; boundary="000000000000edba66057cc80ba7"

--000000000000edba66057cc80ba7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

FYI, I did receive the v2 patch and wrapping message.

Thanks


Le mer. 12 d=C3=A9c. 2018 =C3=A0 00:47, Benjamin Marzinski <bmarzins@redhat=
.com> a
=C3=A9crit :

> On Tue, Dec 11, 2018 at 03:23:03PM -0600, Benjamin Marzinski wrote:
> > I accidentally didn't include Christophe in my
> >
> > [PATCH v2 0/1] Fix false removes
>
> Clearly, something is wrong with my git send-mail setup, since you got
> ignored again.  Sorry. I'll figure out what's going on.
>
> -Ben
>
> > patchset, so v1 of "libmultipath: fix false removes in dmevents polling
>
> > code" went in.  This commit just patches the code to my v2 version.
> > Sorry for the confusion. I've included Martin's Reviewed-by as the end
> > result is the same as what he reviewed, and no intervening commits have
> > touched libmultipath/devmapper.c or multipathd/dmevents.c
> >
> > Benjamin Marzinski (1):
> >   libmultipath: dm_is_mpath cleanup
> >
> >  libmultipath/devmapper.c | 21 ++++++++++++---------
> >  multipathd/dmevents.c    |  4 +++-
> >  2 files changed, 15 insertions(+), 10 deletions(-)
> >
> > --
> > 2.7.4
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>

--000000000000edba66057cc80ba7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">FYI, I did receive the v2 patch and wrapping message.<div=
 dir=3D"auto"><br></div><div dir=3D"auto">Thanks</div><div dir=3D"auto"><br=
></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr">Le mer. 12 d=
=C3=A9c. 2018 =C3=A0 00:47, Benjamin Marzinski &lt;<a href=3D"mailto:bmarzi=
ns@redhat.com">bmarzins@redhat.com</a>&gt; a =C3=A9crit=C2=A0:<br></div><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #=
ccc solid;padding-left:1ex">On Tue, Dec 11, 2018 at 03:23:03PM -0600, Benja=
min Marzinski wrote:<br>
&gt; I accidentally didn&#39;t include Christophe in my<br>
&gt; <br>
&gt; [PATCH v2 0/1] Fix false removes<br>
<br>
Clearly, something is wrong with my git send-mail setup, since you got<br>
ignored again.=C2=A0 Sorry. I&#39;ll figure out what&#39;s going on.<br>
<br>
-Ben<br>
<br>
&gt; patchset, so v1 of &quot;libmultipath: fix false removes in dmevents p=
olling=C2=A0 =C2=A0<br>
&gt; code&quot; went in.=C2=A0 This commit just patches the code to my v2 v=
ersion.<br>
&gt; Sorry for the confusion. I&#39;ve included Martin&#39;s Reviewed-by as=
 the end<br>
&gt; result is the same as what he reviewed, and no intervening commits hav=
e<br>
&gt; touched libmultipath/devmapper.c or multipathd/dmevents.c<br>
&gt; <br>
&gt; Benjamin Marzinski (1):<br>
&gt;=C2=A0 =C2=A0libmultipath: dm_is_mpath cleanup<br>
&gt; <br>
&gt;=C2=A0 libmultipath/devmapper.c | 21 ++++++++++++---------<br>
&gt;=C2=A0 multipathd/dmevents.c=C2=A0 =C2=A0 |=C2=A0 4 +++-<br>
&gt;=C2=A0 2 files changed, 15 insertions(+), 10 deletions(-)<br>
&gt; <br>
&gt; -- <br>
&gt; 2.7.4<br>
&gt; <br>
&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank" rel=3D"norefe=
rrer">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer noreferrer" target=3D"_blank">https://www.redhat.com/mailman/listi=
nfo/dm-devel</a><br>
</blockquote></div>

--000000000000edba66057cc80ba7--


--===============5176953801161019503==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5176953801161019503==--
