From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] hwe_regmatch: match error
Date: Thu, 3 Nov 2016 14:44:24 +0100
Message-ID: <CABr-GnfrTEujfXi6AnQHuujgu=PaqaSH=yMEaDX=cpdZHX6QUw@mail.gmail.com>
References: <OF7CB3362D.2C97E5BB-ON4825805E.00108B17-4825805E.0010903E@LocalDomain>
	<OF9054AD97.BF5E1EA4-ON4825805E.0010B7C3-4825805E.0011A078@zte.com.cn>
	<20161101160557.GB1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7534508663415927274=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161101160557.GB1972@octiron.msp.redhat.com>
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
Cc: zhang.kai16@zte.com.cn, device-mapper development <dm-devel@redhat.com>, huang.wei56@zte.com.cn, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

--===============7534508663415927274==
Content-Type: multipart/alternative; boundary=001a114080466eb1e1054065c1fc

--001a114080466eb1e1054065c1fc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Merged.
Thanks.

On Tue, Nov 1, 2016 at 5:05 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Tue, Nov 01, 2016 at 11:12:46AM +0800, tang.junhui@zte.com.cn wrote:
> >    Hello Christophe,
>
> ACK
>
> -Ben
>
> >
> >    This issue affects the accuracy of regular matching,
> >    and the patch bellow had been reviewed by Hannes,
> >    Can you merge it to Opensvc?
> >
> >    Thanks
> >    Tang
> >
> >    On 10/14/2016 04:03 AM, huang.wei56@zte.com.cn wrote:
> >    > From: "wei.huang" <huang.wei56@zte.com.cn>
> >    >
> >    > Problem:
> >    > when we configure a device like vendor, product, revision all null
> in
> >    multipath.conf, hwe_regmatch always return 0.
> >    >
> >    > Reasons:
> >    > \!hwe2->vendor, \!hwe2->product and \!hwe2->revision are all true.
> >    >
> >    > Signed-off-by: wei.huang <huang.wei56@zte.com.cn>
> >    > ---
> >    >  libmultipath/config.c | 3 ++-
> >    >  1 file changed, 2 insertions(+), 1 deletion(-)
> >    >
> >    > diff --git a/libmultipath/config.c b/libmultipath/config.c
> >    > index a48b8af..d99cd75 100644
> >    > --- a/libmultipath/config.c
> >    > +++ b/libmultipath/config.c
> >    > @@ -80,7 +80,8 @@ hwe_regmatch (struct hwentry *hwe1, struct hwent=
ry
> >    *hwe2)
> >    >                       regcomp(&rre, hwe1->revision,
> >    REG_EXTENDED|REG_NOSUB))
> >    >                                    goto out_pre;
> >    >
> >    > -                 if ((!hwe1->vendor || !hwe2->vendor ||
> >    > +                 if ((hwe2->vendor || hwe2->product ||
> hwe2->revision)
> >    &&
> >    > +                     (!hwe1->vendor || !hwe2->vendor ||
> >    >                        !regexec(&vre, hwe2->vendor, 0, NULL, 0)) &=
&
> >    >                       (!hwe1->product || !hwe2->product ||
> >    >                        !regexec(&pre, hwe2->product, 0, NULL, 0)) =
&&
> >    >
> >    Good point.
> >
> >    Reviewed-by: Hannes Reinecke <hare@suse.com>
> >
> >    Cheers,
> >
> >    Hannes
> >    --
> >    Dr. Hannes Reinecke                                     Teamlead
> Storage &
> >    Networking
> >    hare@suse.de
>
> >       +49 911 74053 688
> >    SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=EF=BF=BD=EF=BF=BDrnberg
> >    GF: F. Imend?rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> >    HRB 21284 (AG N=EF=BF=BD=EF=BF=BDrnberg)
>

--001a114080466eb1e1054065c1fc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Nov 1, 2016 at 5:05 PM, Benjamin Mar=
zinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=
=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On Tue, Nov 01, 2016 at 11:12:46AM +0800, <a href=3D"mailto:t=
ang.junhui@zte.com.cn">tang.junhui@zte.com.cn</a> wrote:<br>
&gt;=C2=A0 =C2=A0 Hello Christophe,<br>
<br>
ACK<br>
<br>
-Ben<br>
<div><div class=3D"h5"><br>
&gt;<br>
&gt;=C2=A0 =C2=A0 This issue affects the accuracy of regular matching,<br>
&gt;=C2=A0 =C2=A0 and the patch bellow had been reviewed by Hannes,<br>
&gt;=C2=A0 =C2=A0 Can you merge it to Opensvc?<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Thanks<br>
&gt;=C2=A0 =C2=A0 Tang<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 On 10/14/2016 04:03 AM, <a href=3D"mailto:huang.wei56@zte=
.com.cn">huang.wei56@zte.com.cn</a> wrote:<br>
&gt;=C2=A0 =C2=A0 &gt; From: &quot;wei.huang&quot; &lt;<a href=3D"mailto:hu=
ang.wei56@zte.com.cn">huang.wei56@zte.com.cn</a>&gt;<br>
&gt;=C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 &gt; Problem:<br>
&gt;=C2=A0 =C2=A0 &gt; when we configure a device like vendor, product, rev=
ision all null in<br>
&gt;=C2=A0 =C2=A0 multipath.conf, hwe_regmatch always return 0.<br>
&gt;=C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 &gt; Reasons:<br>
&gt;=C2=A0 =C2=A0 &gt; \!hwe2-&gt;vendor, \!hwe2-&gt;product and \!hwe2-&gt=
;revision are all true.<br>
&gt;=C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 &gt; Signed-off-by: wei.huang &lt;<a href=3D"mailto:huang=
.wei56@zte.com.cn">huang.wei56@zte.com.cn</a>&gt;<br>
&gt;=C2=A0 =C2=A0 &gt; ---<br>
&gt;=C2=A0 =C2=A0 &gt; =C2=A0libmultipath/config.c | 3 ++-<br>
&gt;=C2=A0 =C2=A0 &gt; =C2=A01 file changed, 2 insertions(+), 1 deletion(-)=
<br>
&gt;=C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 &gt; diff --git a/libmultipath/config.c b/libmultipath/co=
nfig.c<br>
&gt;=C2=A0 =C2=A0 &gt; index a48b8af..d99cd75 100644<br>
&gt;=C2=A0 =C2=A0 &gt; --- a/libmultipath/config.c<br>
&gt;=C2=A0 =C2=A0 &gt; +++ b/libmultipath/config.c<br>
&gt;=C2=A0 =C2=A0 &gt; @@ -80,7 +80,8 @@ hwe_regmatch (struct hwentry *hwe1=
, struct hwentry<br>
&gt;=C2=A0 =C2=A0 *hwe2)<br>
&gt;=C2=A0 =C2=A0 &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 regcomp(&amp;rre, hwe1-&gt;revision,<br>
&gt;=C2=A0 =C2=A0 REG_EXTENDED|REG_NOSUB))<br>
&gt;=C2=A0 =C2=A0 &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0go=
to out_pre;<br>
&gt;=C2=A0 =C2=A0 &gt; =C2=A0<br>
&gt;=C2=A0 =C2=A0 &gt; - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if ((!hwe1-&gt;vendor || !hwe2-&gt;vendor ||<br>
&gt;=C2=A0 =C2=A0 &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if ((hwe2-&gt;vendor || hwe2-&gt;product || hwe2-&gt;revision)<br>
&gt;=C2=A0 =C2=A0 &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 &gt; + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 (!hwe1-&gt;vendor || !hwe2-&gt;vendor ||<br>
&gt;=C2=A0 =C2=A0 &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!regexec(&amp;vre, hwe2-&gt;vendor, 0, NULL,=
 0)) &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 (!hwe1-&gt;product || !hwe2-&gt;product ||<br>
&gt;=C2=A0 =C2=A0 &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0!regexec(&amp;pre, hwe2-&gt;product, 0, NULL=
, 0)) &amp;&amp;<br>
&gt;=C2=A0 =C2=A0 &gt;<br>
&gt;=C2=A0 =C2=A0 Good point.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Reviewed-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@s=
use.com">hare@suse.com</a>&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Cheers,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 Hannes<br>
&gt;=C2=A0 =C2=A0 --<br>
&gt;=C2=A0 =C2=A0 Dr. Hannes Reinecke =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 Teamlead Storage &amp;<br>
&gt;=C2=A0 =C2=A0 Networking<br>
&gt;=C2=A0 =C2=A0 <a href=3D"mailto:hare@suse.de">hare@suse.de</a> =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"tel:%2B49%20911%2074053%20688" va=
lue=3D"+4991174053688">+49 911 74053 688</a><br>
</div></div>&gt;=C2=A0 =C2=A0 SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=EF=BF=
=BD=EF=BF=BDrnberg<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 GF: F. Imend?rffer, J. Smithard, J. Guil=
d, D. Upmanyu, G. Norton<br>
</span>&gt;=C2=A0 =C2=A0 HRB 21284 (AG N=EF=BF=BD=EF=BF=BDrnberg)<br>
</blockquote></div><br></div>

--001a114080466eb1e1054065c1fc--


--===============7534508663415927274==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7534508663415927274==--
