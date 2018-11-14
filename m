From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 0/7] multipathd: make uxlsnr errors really
	fatal
Date: Wed, 14 Nov 2018 08:38:35 +0100
Message-ID: <CABr-GncgjV8yRwc6UzP-41Oesw5iLfL5zo3GCCPY_wqxg3R1Sw@mail.gmail.com>
References: <20181102122402.31145-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5509256214420081881=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122402.31145-1-mwilck@suse.com>
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

--===============5509256214420081881==
Content-Type: multipart/alternative; boundary="000000000000356ef9057a9b06b0"

--000000000000356ef9057a9b06b0
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Fri, Nov 2, 2018 at 1:24 PM Martin Wilck <mwilck@suse.com> wrote:

> Hi Christophe,
>
> this series, based on top of the recently submitted
> "various multipath-tools patches (v2)" and "checkers overhaul (v3)"
> series, fixes a problem that I recently observed: despite
> ee01e841 "multipathd: handle errors in uxlsnr as fatal", multipathd
> sometimes doesn't quit when the socket setup fails.
>
> While at that, I stumbled upon init_path_check_interval(), wondered
> about its purpose, and came to the conclusion that can be quite
> easily obsoleted.
>
> ----
> Changes v2->v3:
>   04/07: Fixed cleanup code path (Ben).
>
> Changes v1->v2:
>   04/07: Fixed problem observed by Ben.
>
> Martin Wilck (7):
>   libmultipath: set pp->checkint in store_pathinfo()
>   multipathd: remove init_path_check_interval()
>   multipathd: print error message if checkint is not initialized
>   multipathd: open client socket early
>   multipathd: set DAEMON_CONFIGURE from uxlsnr thread
>   multipathd: make DAEMON_SHUTDOWN a terminal state
>   multipathd: only grab conf once for filter_path()
>
>  libmultipath/defaults.h   |   1 +
>  libmultipath/dict.c       |  14 ++++-
>  libmultipath/discovery.c  |   1 +
>  libmultipath/structs.c    |   1 +
>  multipathd/cli_handlers.c |  10 ++--
>  multipathd/main.c         | 109 +++++++++++++++++++++++++-------------
>  multipathd/uxlsnr.c       |  14 +----
>  multipathd/uxlsnr.h       |   5 +-
>  8 files changed, 98 insertions(+), 57 deletions(-)
>
> --
> 2.19.1
>
>

--000000000000356ef9057a9b06b0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><br><div class=3D"gmail_quo=
te"><div dir=3D"ltr">On Fri, Nov 2, 2018 at 1:24 PM Martin Wilck &lt;<a hre=
f=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>&gt; wrote:<br></div><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">Hi Christophe,<br>
<br>
this series, based on top of the recently submitted<br>
&quot;various multipath-tools patches (v2)&quot; and &quot;checkers overhau=
l (v3)&quot;<br>
series, fixes a problem that I recently observed: despite<br>
ee01e841 &quot;multipathd: handle errors in uxlsnr as fatal&quot;, multipat=
hd<br>
sometimes doesn&#39;t quit when the socket setup fails.<br>
<br>
While at that, I stumbled upon init_path_check_interval(), wondered<br>
about its purpose, and came to the conclusion that can be quite<br>
easily obsoleted.<br>
<br>
----<br>
Changes v2-&gt;v3:<br>
=C2=A0 04/07: Fixed cleanup code path (Ben).<br>
<br>
Changes v1-&gt;v2:<br>
=C2=A0 04/07: Fixed problem observed by Ben.<br>
<br>
Martin Wilck (7):<br>
=C2=A0 libmultipath: set pp-&gt;checkint in store_pathinfo()<br>
=C2=A0 multipathd: remove init_path_check_interval()<br>
=C2=A0 multipathd: print error message if checkint is not initialized<br>
=C2=A0 multipathd: open client socket early<br>
=C2=A0 multipathd: set DAEMON_CONFIGURE from uxlsnr thread<br>
=C2=A0 multipathd: make DAEMON_SHUTDOWN a terminal state<br>
=C2=A0 multipathd: only grab conf once for filter_path()<br>
<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0|=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 14 ++++-<br>
=C2=A0libmultipath/discovery.c=C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0libmultipath/structs.c=C2=A0 =C2=A0 |=C2=A0 =C2=A01 +<br>
=C2=A0multipathd/cli_handlers.c |=C2=A0 10 ++--<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 109 ++++++++++++=
+++++++++++++-------------<br>
=C2=A0multipathd/uxlsnr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 14 +----<br>
=C2=A0multipathd/uxlsnr.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A05 +-<br>
=C2=A08 files changed, 98 insertions(+), 57 deletions(-)<br>
<br>
-- <br>
2.19.1<br>
<br>
</blockquote></div>

--000000000000356ef9057a9b06b0--


--===============5509256214420081881==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5509256214420081881==--
