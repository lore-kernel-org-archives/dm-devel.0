From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/4] multipath-tools unit test fixups
Date: Wed, 29 Apr 2020 09:03:28 +0200
Message-ID: <CABr-GnewZXFi2-EMyFPoz7mN_Sqr=QPNzus2p957Fve+sUUR-g@mail.gmail.com>
References: <20200302222025.21022-1-mwilck@suse.com>
	<CABr-GncoE2_XKUUTD3GPQfeGKAVnZdavpA2_W++tMz7L=1sHow@mail.gmail.com>
	<131c09dab92b10fa261b215ca94bd41655ad330d.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9179637576807814293=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <131c09dab92b10fa261b215ca94bd41655ad330d.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============9179637576807814293==
Content-Type: multipart/alternative; boundary="00000000000034f78305a4688c35"

--00000000000034f78305a4688c35
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Yes I did notice.
I got sidetracked by other projects, but I intent to merge this patch and
tag the release this week.

Thank you for the notice,
Christophe.

On Tue, Apr 28, 2020 at 11:54 PM Martin Wilck <mwilck@suse.com> wrote:

> Hello Christophe,
>
> On Tue, 2020-03-03 at 00:38 +0100, Christophe Varoqui wrote:
> > Ben,
> >
> > take the time you need for review,
> > I'll wait for this patchset before tagging the next version.
>
> did you notice that Ben acked this set on Mar 13th?
>
> https://www.redhat.com/archives/dm-devel/2020-March/msg00044.html
>
> Regards,
> Martin
>
> >
> > Best,
> > Christophe.
> >
> > On Mon, Mar 2, 2020 at 11:20 PM <mwilck@suse.com> wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >
> > > Hi Christophe, hi Ben,
> > >
> > > as announced in my previous post, here's a set of minor fixups for
> > > the
> > > unit tests. The README.md should have been created long ago. My
> > > main
> > > issue is that I'd prefer not to have a file under git control that
> > > is
> > > likely to be customized in every developer's environment and needs
> > > to be stashed away before every serious git work.
> > >
> > > Martin Wilck (4):
> > >   Remove tests/directio_test_dev
> > >   tests/Makefile: allow setting DIO_TEST_DEV in the environment
> > >   tests/Makefile: add test_clean target
> > >   tests: add README.md
> > >
> > >  tests/Makefile          | 13 +++++---
> > >  tests/README.md         | 72
> > > +++++++++++++++++++++++++++++++++++++++++
> > >  tests/directio_test_dev |  4 ---
> > >  3 files changed, 81 insertions(+), 8 deletions(-)
> > >  create mode 100644 tests/README.md
> > >  delete mode 100644 tests/directio_test_dev
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>

--00000000000034f78305a4688c35
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi=C2=A0Martin,</div><div><br></div>Yes I did notice.=
<div>I got sidetracked by other projects, but I intent to merge this patch =
and tag the release this week.</div><div><br></div><div>Thank you for the n=
otice,</div><div>Christophe.</div></div><br><div class=3D"gmail_quote"><div=
 dir=3D"ltr" class=3D"gmail_attr">On Tue, Apr 28, 2020 at 11:54 PM Martin W=
ilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>&gt; wrote:<=
br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hello Christophe=
,<br>
<br>
On Tue, 2020-03-03 at 00:38 +0100, Christophe Varoqui wrote:<br>
&gt; Ben,<br>
&gt; <br>
&gt; take the time you need for review,<br>
&gt; I&#39;ll wait for this patchset before tagging the next version.<br>
<br>
did you notice that Ben acked this set on Mar 13th?<br>
<br>
<a href=3D"https://www.redhat.com/archives/dm-devel/2020-March/msg00044.htm=
l" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/archives/dm-=
devel/2020-March/msg00044.html</a><br>
<br>
Regards,<br>
Martin<br>
<br>
&gt; <br>
&gt; Best,<br>
&gt; Christophe.<br>
&gt; <br>
&gt; On Mon, Mar 2, 2020 at 11:20 PM &lt;<a href=3D"mailto:mwilck@suse.com"=
 target=3D"_blank">mwilck@suse.com</a>&gt; wrote:<br>
&gt; &gt; From: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" target=
=3D"_blank">mwilck@suse.com</a>&gt;<br>
&gt; &gt; <br>
&gt; &gt; Hi Christophe, hi Ben,<br>
&gt; &gt; <br>
&gt; &gt; as announced in my previous post, here&#39;s a set of minor fixup=
s for<br>
&gt; &gt; the<br>
&gt; &gt; unit tests. The README.md should have been created long ago. My<b=
r>
&gt; &gt; main<br>
&gt; &gt; issue is that I&#39;d prefer not to have a file under git control=
 that<br>
&gt; &gt; is<br>
&gt; &gt; likely to be customized in every developer&#39;s environment and =
needs<br>
&gt; &gt; to be stashed away before every serious git work.<br>
&gt; &gt; <br>
&gt; &gt; Martin Wilck (4):<br>
&gt; &gt;=C2=A0 =C2=A0Remove tests/directio_test_dev<br>
&gt; &gt;=C2=A0 =C2=A0tests/Makefile: allow setting DIO_TEST_DEV in the env=
ironment<br>
&gt; &gt;=C2=A0 =C2=A0tests/Makefile: add test_clean target<br>
&gt; &gt;=C2=A0 =C2=A0tests: add README.md<br>
&gt; &gt; <br>
&gt; &gt;=C2=A0 tests/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 13 +++++=
---<br>
&gt; &gt;=C2=A0 tests/README.md=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 72<br>
&gt; &gt; +++++++++++++++++++++++++++++++++++++++++<br>
&gt; &gt;=C2=A0 tests/directio_test_dev |=C2=A0 4 ---<br>
&gt; &gt;=C2=A0 3 files changed, 81 insertions(+), 8 deletions(-)<br>
&gt; &gt;=C2=A0 create mode 100644 tests/README.md<br>
&gt; &gt;=C2=A0 delete mode 100644 tests/directio_test_dev<br>
&gt; &gt; <br>
&gt; &gt; --<br>
&gt; &gt; dm-devel mailing list<br>
&gt; &gt; <a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel=
@redhat.com</a><br>
&gt; &gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=
=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/d=
m-devel</a><br>
<br>
<br>
</blockquote></div>

--00000000000034f78305a4688c35--

--===============9179637576807814293==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9179637576807814293==--
