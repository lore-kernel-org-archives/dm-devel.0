From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 5/5] libmultipath: Accept "*" as a valid
 regular expression
Date: Fri, 25 Jul 2014 11:10:17 +0200
Message-ID: <CABr-Gnd+nFM_R1-mkzZ3CROPjsEOFvN6fxsSQpq8ngs6znS6-w@mail.gmail.com>
References: <53C91871.9070402@acm.org> <53C9191C.4070705@acm.org>
	<20140724165559.000076e3@localhost>
	<20140724163407.GD16321@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4969667549062474581=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140724163407.GD16321@localhost.localdomain>
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
Cc: Bart Van Assche <bvanassche@acm.org>
List-Id: dm-devel.ids

--===============4969667549062474581==
Content-Type: multipart/alternative; boundary=001a11333df626322a04ff00f15b

--001a11333df626322a04ff00f15b
Content-Type: text/plain; charset=UTF-8

Right, I agree with your comments.
The patch is reverted.

Thanks.


On Thu, Jul 24, 2014 at 6:34 PM, Bryn M. Reeves <bmr@redhat.com> wrote:

> On Thu, Jul 24, 2014 at 04:55:59PM +0200, Sebastian Herbszt wrote:
> > Bart Van Assche wrote:
> > > Inside libmultipath regcomp() is used to compile regular expressions
> > > specified in /etc/multipath.conf. Many multipath.conf examples contain
> > > 'product_type "*"'. However, "*" is not a valid POSIX regular
> expression.
> > > Hence this patch that changes the regular expression "*" into ".*".
> > >
> > Is this change really required? With patch 4 we now get a proper error:
> > multipath.conf +14 parsing failed:            vendor "*"
> > multipath.conf +15 parsing failed:            product "*"
> > error parsing config file
> >
> > I think it should be enough to modify the man page to mention
> vendor/product
> > are both regular expressions. This change might also confuse users since
> this
> > automagic "*" to ".*" only applies to the blacklist exceptions.
>
> Agreed; the examples are broken here so let's fix them rather than add
> magic
> parsing that will only come back to confuse people in the future.
>
> Regards,
> Bryn.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11333df626322a04ff00f15b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Right, I agree with your comments.<div>The patch is revert=
ed.</div><div><br></div><div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><br><div class=3D"gmail_quote">On Thu, Jul 24, 2014 at 6:34 PM, Bryn M.=
 Reeves <span dir=3D"ltr">&lt;<a href=3D"mailto:bmr@redhat.com" target=3D"_=
blank">bmr@redhat.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On Thu, Jul 24, 2014 at 04:5=
5:59PM +0200, Sebastian Herbszt wrote:<br>
&gt; Bart Van Assche wrote:<br>
&gt; &gt; Inside libmultipath regcomp() is used to compile regular expressi=
ons<br>
&gt; &gt; specified in /etc/multipath.conf. Many multipath.conf examples co=
ntain<br>
&gt; &gt; &#39;product_type &quot;*&quot;&#39;. However, &quot;*&quot; is n=
ot a valid POSIX regular expression.<br>
&gt; &gt; Hence this patch that changes the regular expression &quot;*&quot=
; into &quot;.*&quot;.<br>
&gt; &gt;<br>
</div><div class=3D"">&gt; Is this change really required? With patch 4 we =
now get a proper error:<br>
&gt; multipath.conf +14 parsing failed: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0vendor &quot;*&quot;<br>
&gt; multipath.conf +15 parsing failed: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0product &quot;*&quot;<br>
&gt; error parsing config file<br>
&gt;<br>
&gt; I think it should be enough to modify the man page to mention vendor/p=
roduct<br>
&gt; are both regular expressions. This change might also confuse users sin=
ce this<br>
&gt; automagic &quot;*&quot; to &quot;.*&quot; only applies to the blacklis=
t exceptions.<br>
<br>
</div>Agreed; the examples are broken here so let&#39;s fix them rather tha=
n add magic<br>
parsing that will only come back to confuse people in the future.<br>
<br>
Regards,<br>
Bryn.<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br>
</blockquote></div><br></div>

--001a11333df626322a04ff00f15b--


--===============4969667549062474581==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4969667549062474581==--
