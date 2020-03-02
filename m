From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/4] multipath-tools unit test fixups
Date: Tue, 3 Mar 2020 00:38:36 +0100
Message-ID: <CABr-GncoE2_XKUUTD3GPQfeGKAVnZdavpA2_W++tMz7L=1sHow@mail.gmail.com>
References: <20200302222025.21022-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3308716080341448728=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200302222025.21022-1-mwilck@suse.com>
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

--===============3308716080341448728==
Content-Type: multipart/alternative; boundary="0000000000004d6fdf059fe7b022"

--0000000000004d6fdf059fe7b022
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ben,

take the time you need for review,
I'll wait for this patchset before tagging the next version.

Best,
Christophe.

On Mon, Mar 2, 2020 at 11:20 PM <mwilck@suse.com> wrote:

> From: Martin Wilck <mwilck@suse.com>
>
> Hi Christophe, hi Ben,
>
> as announced in my previous post, here's a set of minor fixups for the
> unit tests. The README.md should have been created long ago. My main
> issue is that I'd prefer not to have a file under git control that is
> likely to be customized in every developer's environment and needs
> to be stashed away before every serious git work.
>
> Martin Wilck (4):
>   Remove tests/directio_test_dev
>   tests/Makefile: allow setting DIO_TEST_DEV in the environment
>   tests/Makefile: add test_clean target
>   tests: add README.md
>
>  tests/Makefile          | 13 +++++---
>  tests/README.md         | 72 +++++++++++++++++++++++++++++++++++++++++
>  tests/directio_test_dev |  4 ---
>  3 files changed, 81 insertions(+), 8 deletions(-)
>  create mode 100644 tests/README.md
>  delete mode 100644 tests/directio_test_dev
>
> --
> 2.25.0
>
>

--0000000000004d6fdf059fe7b022
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Ben,<div><br></div><div>take the time you=C2=A0need for re=
view,</div><div>I&#39;ll wait for this patchset before tagging the next ver=
sion.</div><div><br></div><div>Best,</div><div>Christophe.</div></div><br><=
div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Mar=
 2, 2020 at 11:20 PM &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@suse.com=
</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:=
0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">=
From: Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank"=
>mwilck@suse.com</a>&gt;<br>
<br>
Hi Christophe, hi Ben,<br>
<br>
as announced in my previous post, here&#39;s a set of minor fixups for the<=
br>
unit tests. The README.md should have been created long ago. My main<br>
issue is that I&#39;d prefer not to have a file under git control that is<b=
r>
likely to be customized in every developer&#39;s environment and needs<br>
to be stashed away before every serious git work.<br>
<br>
Martin Wilck (4):<br>
=C2=A0 Remove tests/directio_test_dev<br>
=C2=A0 tests/Makefile: allow setting DIO_TEST_DEV in the environment<br>
=C2=A0 tests/Makefile: add test_clean target<br>
=C2=A0 tests: add README.md<br>
<br>
=C2=A0tests/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 13 +++++---<br>
=C2=A0tests/README.md=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 72 +++++++++++++++=
++++++++++++++++++++++++++<br>
=C2=A0tests/directio_test_dev |=C2=A0 4 ---<br>
=C2=A03 files changed, 81 insertions(+), 8 deletions(-)<br>
=C2=A0create mode 100644 tests/README.md<br>
=C2=A0delete mode 100644 tests/directio_test_dev<br>
<br>
-- <br>
2.25.0<br>
<br>
</blockquote></div>

--0000000000004d6fdf059fe7b022--

--===============3308716080341448728==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3308716080341448728==--
