From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: Re: [PATCH 6/6] dm-stripe: Fix error message
Date: Thu, 29 Oct 2015 20:36:52 +0900
Message-ID: <CAHndrBnufL0Z79yx0gdoEaLbBrZX1QF5ZBFzGJddgGGXTC8Dmg@mail.gmail.com>
References: <1445974740-8362-1-git-send-email-kusumi.tomohiro@gmail.com>
	<1445974740-8362-6-git-send-email-kusumi.tomohiro@gmail.com>
	<20151028195128.GA22241@redhat.com>
	<CAHndrBn06ih=6atGBcC7TjoFEWd0y=9WPu6GBygFE06y6Q=j7w@mail.gmail.com>
	<20151028220055.GA22827@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6498330370390563162=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20151028220055.GA22827@redhat.com>
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

--===============6498330370390563162==
Content-Type: multipart/alternative; boundary=001a1143907e31648c05233cba4d

--001a1143907e31648c05233cba4d
Content-Type: text/plain; charset=UTF-8

i respect what you say.
anyhow thanks for applying the rest of the patches :)

2015-10-29 7:00 GMT+09:00 Mike Snitzer <snitzer@redhat.com>:

> On Wed, Oct 28 2015 at  4:40pm -0400,
> Tomohiro Kusumi <kusumi.tomohiro@gmail.com> wrote:
>
> > hi, thanks for your reply.
> >
> > I understand what you mean, but that's the reason.
> > I happened to use something like below via dmsetup
> >
> > --table '0 100 striped 2 4 /dev/xxx 0 /dev/yyy 0'
> >
> > and hit this message which is not obvious as long as it says "Target
> > length".
> > Users have no idea 50/4 was what was really done in kernel space.
>
> You're allowing a very literal look at the code to cloud your perception
> of the error and concluding that it is misleading/incorrect.
>
> Just because the code does math in a certain order doesn't change the
> fact that the error message is still correct (if/when it is reported).
>

--001a1143907e31648c05233cba4d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>i respect what you say.</div><div>anyhow thanks for a=
pplying the rest of the patches :)</div></div><div class=3D"gmail_extra"><b=
r><div class=3D"gmail_quote">2015-10-29 7:00 GMT+09:00 Mike Snitzer <span d=
ir=3D"ltr">&lt;<a href=3D"mailto:snitzer@redhat.com" target=3D"_blank">snit=
zer@redhat.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">On Wed, Oct 28 2015 at=C2=A0 4:40pm -0400,<br>
Tomohiro Kusumi &lt;<a href=3D"mailto:kusumi.tomohiro@gmail.com">kusumi.tom=
ohiro@gmail.com</a>&gt; wrote:<br>
<br>
&gt; hi, thanks for your reply.<br>
&gt;<br>
&gt; I understand what you mean, but that&#39;s the reason.<br>
&gt; I happened to use something like below via dmsetup<br>
&gt;<br>
&gt; --table &#39;0 100 striped 2 4 /dev/xxx 0 /dev/yyy 0&#39;<br>
&gt;<br>
&gt; and hit this message which is not obvious as long as it says &quot;Tar=
get<br>
&gt; length&quot;.<br>
&gt; Users have no idea 50/4 was what was really done in kernel space.<br>
<br>
</span>You&#39;re allowing a very literal look at the code to cloud your pe=
rception<br>
of the error and concluding that it is misleading/incorrect.<br>
<br>
Just because the code does math in a certain order doesn&#39;t change the<b=
r>
fact that the error message is still correct (if/when it is reported).<br>
</blockquote></div><br></div>

--001a1143907e31648c05233cba4d--


--===============6498330370390563162==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6498330370390563162==--
