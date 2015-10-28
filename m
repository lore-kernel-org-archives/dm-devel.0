From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: Re: [PATCH 6/6] dm-stripe: Fix error message
Date: Thu, 29 Oct 2015 05:40:27 +0900
Message-ID: <CAHndrBn06ih=6atGBcC7TjoFEWd0y=9WPu6GBygFE06y6Q=j7w@mail.gmail.com>
References: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
	<1445974740-8362-6-git-send-email-kusumi.tomohiro@gmail.com>
	<20151028195128.GA22241@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4140585676354945726=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151028195128.GA22241@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

--===============4140585676354945726==
Content-Type: multipart/alternative; boundary=001a1143907e5d8cc7052330346b

--001a1143907e5d8cc7052330346b
Content-Type: text/plain; charset=UTF-8

hi, thanks for your reply.

I understand what you mean, but that's the reason.
I happened to use something like below via dmsetup

--table '0 100 striped 2 4 /dev/xxx 0 /dev/yyy 0'

and hit this message which is not obvious as long as it says "Target
length".
Users have no idea 50/4 was what was really done in kernel space.


2015-10-29 4:51 GMT+09:00 Mike Snitzer <snitzer@redhat.com>:

> On Tue, Oct 27 2015 at  3:39pm -0400,
> Tomohiro Kusumi <kusumi.tomohiro@gmail.com> wrote:
>
> > The meaning of "not divisible by chunk size" has changed after
> > d793e684, so the error message here should probably be using
> > "Stripe length" since tmp_len is result of width/stripes, but
> > not the whole target device size.
> >
> > Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
> > ---
> >  drivers/md/dm-stripe.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> > index 797ddb9..85cb09f 100644
> > --- a/drivers/md/dm-stripe.c
> > +++ b/drivers/md/dm-stripe.c
> > @@ -127,7 +127,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned
> int argc, char **argv)
> >
> >       tmp_len = width;
> >       if (sector_div(tmp_len, chunk_size)) {
> > -             ti->error = "Target length not divisible by "
> > +             ti->error = "Stripe length not divisible by "
> >                   "chunk size";
> >               return -EINVAL;
> >       }
>
> There is no need for this change.  The user-facing error is more
> meaningful.  The only input that is being checked here is the specified
> target length.
>
> Dropping this patch.
>

--001a1143907e5d8cc7052330346b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>hi, thanks for your reply.</div><div><br></div><div>I=
 understand what you mean, but that&#39;s the reason.</div><div>I happened =
to use something like below via dmsetup</div><div><br></div><div>--table &#=
39;0 100 striped 2 4 /dev/xxx 0 /dev/yyy 0&#39;</div><div><br></div><div>an=
d hit this message which is not obvious as long as it says &quot;Target len=
gth&quot;.</div><div>Users have no idea 50/4 was what was really done in ke=
rnel space.</div><div><br></div></div><div class=3D"gmail_extra"><br><div c=
lass=3D"gmail_quote">2015-10-29 4:51 GMT+09:00 Mike Snitzer <span dir=3D"lt=
r">&lt;<a href=3D"mailto:snitzer@redhat.com" target=3D"_blank">snitzer@redh=
at.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">O=
n Tue, Oct 27 2015 at=C2=A0 3:39pm -0400,<br>
Tomohiro Kusumi &lt;<a href=3D"mailto:kusumi.tomohiro@gmail.com">kusumi.tom=
ohiro@gmail.com</a>&gt; wrote:<br>
<br>
&gt; The meaning of &quot;not divisible by chunk size&quot; has changed aft=
er<br>
&gt; d793e684, so the error message here should probably be using<br>
&gt; &quot;Stripe length&quot; since tmp_len is result of width/stripes, bu=
t<br>
&gt; not the whole target device size.<br>
&gt;<br>
&gt; Signed-off-by: Tomohiro Kusumi &lt;<a href=3D"mailto:kusumi.tomohiro@g=
mail.com">kusumi.tomohiro@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 drivers/md/dm-stripe.c |=C2=A0 =C2=A0 2 +-<br>
&gt;=C2=A0 1 files changed, 1 insertions(+), 1 deletions(-)<br>
&gt;<br>
&gt; diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c<br>
&gt; index 797ddb9..85cb09f 100644<br>
&gt; --- a/drivers/md/dm-stripe.c<br>
&gt; +++ b/drivers/md/dm-stripe.c<br>
&gt; @@ -127,7 +127,7 @@ static int stripe_ctr(struct dm_target *ti, unsign=
ed int argc, char **argv)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0tmp_len =3D width;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (sector_div(tmp_len, chunk_size)) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ti-&gt;error =3D &quo=
t;Target length not divisible by &quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ti-&gt;error =3D &quo=
t;Stripe length not divisible by &quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&q=
uot;chunk size&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
</span>There is no need for this change.=C2=A0 The user-facing error is mor=
e<br>
meaningful.=C2=A0 The only input that is being checked here is the specifie=
d<br>
target length.<br>
<br>
Dropping this patch.<br>
</blockquote></div><br></div>

--001a1143907e5d8cc7052330346b--


--===============4140585676354945726==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4140585676354945726==--
