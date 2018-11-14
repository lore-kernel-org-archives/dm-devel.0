From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 00/10] various multipath-tools patches
Date: Wed, 14 Nov 2018 08:38:10 +0100
Message-ID: <CABr-Gnf0cvY9xPSeC5BSMe6zaqCohvoGHRcp77dUC0CB2F=Jiw@mail.gmail.com>
References: <20181023134348.17915-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4935376702895582781=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181023134348.17915-1-mwilck@suse.com>
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

--===============4935376702895582781==
Content-Type: multipart/alternative; boundary="000000000000be0f04057a9b0409"

--000000000000be0f04057a9b0409
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Tue, Oct 23, 2018 at 3:44 PM Martin Wilck <mwilck@suse.com> wrote:

> This is v2 of my series from Oct. 10; starting from 7 as the
> other patches have already been merged.
>
> Changes wrt v2:
>   7/10: handle failure of libcheck_init() (Ben). I decided not to
>         return PATH_TIMEOUT in this case, rationale in my reply to
>         Ben's review.
>   9/10: new, add the suggestions from Ben's review of 8/8 of v1.
>  10/10: new, see Ben's comment on patch 5/8 of v1.
>
> Martin Wilck (4):
>   libmultipath: handle TUR threads that can't be cancelled
>   multipathd: handle repeated udev retrigger failure
>   multipathd: improve "add missing path" handling
>   multipath.8: fix description of "device" argument
>
>  libmultipath/checkers/tur.c | 24 ++++++++++++++--
>  multipath/multipath.8       | 32 +++++++++++----------
>  multipathd/main.c           | 55 +++++++++++++++++++++++++------------
>  3 files changed, 76 insertions(+), 35 deletions(-)
>
> --
> 2.19.1
>
>

--000000000000be0f04057a9b0409
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><br><div class=3D"gmail_quo=
te"><div dir=3D"ltr">On Tue, Oct 23, 2018 at 3:44 PM Martin Wilck &lt;<a hr=
ef=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>&gt; wrote:<br></div><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex">This is v2 of my series from Oct. 10; starting fr=
om 7 as the<br>
other patches have already been merged.<br>
<br>
Changes wrt v2:<br>
=C2=A0 7/10: handle failure of libcheck_init() (Ben). I decided not to<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return PATH_TIMEOUT in this case, rationale in =
my reply to<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Ben&#39;s review.<br>
=C2=A0 9/10: new, add the suggestions from Ben&#39;s review of 8/8 of v1.<b=
r>
=C2=A010/10: new, see Ben&#39;s comment on patch 5/8 of v1.<br>
<br>
Martin Wilck (4):<br>
=C2=A0 libmultipath: handle TUR threads that can&#39;t be cancelled<br>
=C2=A0 multipathd: handle repeated udev retrigger failure<br>
=C2=A0 multipathd: improve &quot;add missing path&quot; handling<br>
=C2=A0 multipath.8: fix description of &quot;device&quot; argument<br>
<br>
=C2=A0libmultipath/checkers/tur.c | 24 ++++++++++++++--<br>
=C2=A0multipath/multipath.8=C2=A0 =C2=A0 =C2=A0 =C2=A0| 32 +++++++++++-----=
-----<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 55 ++++++=
+++++++++++++++++++------------<br>
=C2=A03 files changed, 76 insertions(+), 35 deletions(-)<br>
<br>
-- <br>
2.19.1<br>
<br>
</blockquote></div>

--000000000000be0f04057a9b0409--


--===============4935376702895582781==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4935376702895582781==--
