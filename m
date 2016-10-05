From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 00/15] Fifteen multipath-tools patches
Date: Wed, 5 Oct 2016 08:49:00 +0200
Message-ID: <CABr-GncKS=ocwyAZs5gS12OBAyWuzoKG7dSRGfpGFmV7s5s2uw@mail.gmail.com>
References: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2456877103110938835=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <157defac-6527-ab23-92f2-9c1926042885@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2456877103110938835==
Content-Type: multipart/alternative; boundary=001a11401be87ce118053e1892c0

--001a11401be87ce118053e1892c0
Content-Type: text/plain; charset=UTF-8

The set is merged.
I just added a patch to fix the drd include in debug.c

Thanks,
Christophe

On Tue, Oct 4, 2016 at 7:36 PM, Bart Van Assche <bart.vanassche@sandisk.com>
wrote:

> Hello Christophe,
>
> As promised I am sending you the multipath-tools patches from my local
> repository. The names of these patches are:
>
> 0001-libmultipath-prioritizers-ontap-Remove-an-unused-inc.patch
> 0002-libmultipath-memory-Move-an-include-directive.patch
> 0003-libmultipath-checkers-tur-Declare-local-functions-st.patch
> 0004-libmultipath-checkers-rbd-Declare-local-functions-st.patch
> 0005-multipathd-libmultipathd-Make-delays-independent-of-.patch
> 0006-multipathd-Suppress-uninteresting-data-race-reports.patch
> 0007-multipathd-Fix-a-data-race.patch
> 0008-libmultipath-checkers-tur-Introduce-strlcpy.patch
> 0009-libmultipath-checkers-tur-Terminate-a-statement-with.patch
> 0010-libmultipath-checkers-tur-Move-pthread_attr_destroy-.patch
> 0011-libmultipath-checkers-tur-Protect-tur_checker_contex.patch
> 0012-libmultipath-checkers-tur-Serialize-tur_checker_cont.patch
> 0013-libmultipath-checkers-tur-Fix-races-on-tur_checker_c.patch
> 0014-libmultipath-Micro-optimize-snprint_size.patch
> 0015-Makefile.inc-Enable-Wextra-and-Wformat-nonliteral.patch
>
> Thanks,
>
> Bart.
>

--001a11401be87ce118053e1892c0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The set is merged.<div>I just added a patch to fix the drd=
 include in debug.c</div><div><br></div><div>Thanks,</div><div>Christophe</=
div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue,=
 Oct 4, 2016 at 7:36 PM, Bart Van Assche <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:bart.vanassche@sandisk.com" target=3D"_blank">bart.vanassche@sandisk.=
com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hello Christoph=
e,<br>
<br>
As promised I am sending you the multipath-tools patches from my local repo=
sitory. The names of these patches are:<br>
<br>
0001-libmultipath-prioritizers<wbr>-ontap-Remove-an-unused-inc.<wbr>patch<b=
r>
0002-libmultipath-memory-Move-<wbr>an-include-directive.patch<br>
0003-libmultipath-checkers-tur<wbr>-Declare-local-functions-st.<wbr>patch<b=
r>
0004-libmultipath-checkers-rbd<wbr>-Declare-local-functions-st.<wbr>patch<b=
r>
0005-multipathd-libmultipathd-<wbr>Make-delays-independent-of-.pa<wbr>tch<b=
r>
0006-multipathd-Suppress-unint<wbr>eresting-data-race-reports.<wbr>patch<br=
>
0007-multipathd-Fix-a-data-rac<wbr>e.patch<br>
0008-libmultipath-checkers-tur<wbr>-Introduce-strlcpy.patch<br>
0009-libmultipath-checkers-tur<wbr>-Terminate-a-statement-with.<wbr>patch<b=
r>
0010-libmultipath-checkers-tur<wbr>-Move-pthread_attr_destroy-.<wbr>patch<b=
r>
0011-libmultipath-checkers-tur<wbr>-Protect-tur_checker_contex.<wbr>patch<b=
r>
0012-libmultipath-checkers-tur<wbr>-Serialize-tur_checker_cont.<wbr>patch<b=
r>
0013-libmultipath-checkers-tur<wbr>-Fix-races-on-tur_checker_c.<wbr>patch<b=
r>
0014-libmultipath-Micro-optimi<wbr>ze-snprint_size.patch<br>
0015-Makefile.inc-Enable-Wextr<wbr>a-and-Wformat-nonliteral.patch<br>
<br>
Thanks,<br>
<br>
Bart.<br>
</blockquote></div><br></div>

--001a11401be87ce118053e1892c0--


--===============2456877103110938835==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2456877103110938835==--
