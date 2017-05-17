From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 0/2] Small multipath fixes
Date: Thu, 18 May 2017 00:26:39 +0200
Message-ID: <CABr-GnfnawnMcxDjJEQ-uvjvWnk7LSJ4xG0fNZeJd-Wk43cUkg@mail.gmail.com>
References: <20170517152446.2526-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3309938924487667870=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170517152446.2526-1-mwilck@suse.com>
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
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3309938924487667870==
Content-Type: multipart/alternative; boundary="001a1137c2863624e3054fbfc8ef"

--001a1137c2863624e3054fbfc8ef
Content-Type: text/plain; charset="UTF-8"

v2 of this set is merged.
Thanks.

On Wed, May 17, 2017 at 5:24 PM, Martin Wilck <mwilck@suse.com> wrote:

> Two minor fixes that I found necessary recently.
>
> Both touch potentially bigger issues - the first one print.c, which
> might need some general overhaul at some time in the future, and the
> second one the build process of multipath tools, which is currently
> lacking an "autobuild" mechanism.
>
> My intention at was to keep the patches small and non-controversial,
> therefore I didn't delve into the big issues just yet.
>
> Changes wrt v1 (suggestions by Bart Van Assche):
> - patch 1/2: replaced ENDLINE by a function
> - patch 2/2: Removed nonstandard <<< construct, and made sure STACKPROT is
> only
>   set once per makefile.
>
> Martin Wilck (2):
>   libmultipath: print.c: make sure lines are 0-terminated
>   multipath-tools: fix compilation with gcc < 4.9
>
>  Makefile.inc         | 15 ++++++++++++++-
>  libmultipath/print.c | 25 +++++++++++++++++--------
>  2 files changed, 31 insertions(+), 9 deletions(-)
>
> --
> 2.12.2
>
>

--001a1137c2863624e3054fbfc8ef
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">v2 of this set is merged.<div>Thanks.</div></div><div clas=
s=3D"gmail_extra"><br><div class=3D"gmail_quote">On Wed, May 17, 2017 at 5:=
24 PM, Martin Wilck <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com=
" target=3D"_blank">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex"><span class=3D"">Two minor fixes that I found necessary re=
cently.<br>
<br>
Both touch potentially bigger issues - the first one print.c, which<br>
might need some general overhaul at some time in the future, and the<br>
second one the build process of multipath tools, which is currently<br>
lacking an &quot;autobuild&quot; mechanism.<br>
<br>
My intention at was to keep the patches small and non-controversial,<br>
therefore I didn&#39;t delve into the big issues just yet.<br>
<br>
</span>Changes wrt v1 (suggestions by Bart Van Assche):<br>
- patch 1/2: replaced ENDLINE by a function<br>
- patch 2/2: Removed nonstandard &lt;&lt;&lt; construct, and made sure STAC=
KPROT is only<br>
=C2=A0 set once per makefile.<br>
<span class=3D""><br>
Martin Wilck (2):<br>
=C2=A0 libmultipath: print.c: make sure lines are 0-terminated<br>
=C2=A0 multipath-tools: fix compilation with gcc &lt; 4.9<br>
<br>
=C2=A0Makefile.inc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 15 ++++++++++++++-<br=
>
</span>=C2=A0libmultipath/print.c | 25 +++++++++++++++++--------<br>
=C2=A02 files changed, 31 insertions(+), 9 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.12.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a1137c2863624e3054fbfc8ef--


--===============3309938924487667870==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3309938924487667870==--
