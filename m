From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/4] multipath-tools: libdmmp improvements.
Date: Sat, 13 Jan 2018 10:02:41 +0100
Message-ID: <CABr-Gnc=9=06ZeNCYjLM_NMv3NKfPcg+Snx3irigczywJN_CiA@mail.gmail.com>
References: <20171121140917.18298-1-fge@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1023901946676342164=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171121140917.18298-1-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1023901946676342164==
Content-Type: multipart/alternative; boundary="94eb2c1969a6c38ab20562a4a40b"

--94eb2c1969a6c38ab20562a4a40b
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Tue, Nov 21, 2017 at 3:09 PM, Gris Ge <fge@redhat.com> wrote:

>  * Patch 1/4 is a resend.
>  * Patch 2/4, 3/4, and 4/4 add new functions to libdmmp library.
>
> Gris Ge (4):
>   multipathd daemon: Fix incorrect use of CLOCK_MONOTONIC in pthread
>   multipath-tools: libdmmp: Allow log function as NULL.
>   multipath-tools: libdmmp: Add new function dmmp_last_error_msg()
>   multipath-tools: libdmmp: Add new error DMMP_ERR_PERMISSION_DENY
>
>  libdmmp/Makefile            |  2 +-
>  libdmmp/libdmmp.c           | 20 ++++++++++++++++++++
>  libdmmp/libdmmp/libdmmp.h   | 23 ++++++++++++++++++++++-
>  libdmmp/libdmmp_misc.c      |  1 +
>  libdmmp/test/libdmmp_test.c | 12 ++++++++----
>  multipathd/cli.c            |  2 +-
>  6 files changed, 53 insertions(+), 7 deletions(-)
>
> --
> 2.15.0
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--94eb2c1969a6c38ab20562a4a40b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Tue, Nov 21, 2017 at 3:09 PM, Gris Ge <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:fge@redhat.com" target=3D"_blank">fge@=
redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=C2=A0* =
Patch 1/4 is a resend.<br>
=C2=A0* Patch 2/4, 3/4, and 4/4 add new functions to libdmmp library.<br>
<br>
Gris Ge (4):<br>
=C2=A0 multipathd daemon: Fix incorrect use of CLOCK_MONOTONIC in pthread<b=
r>
=C2=A0 multipath-tools: libdmmp: Allow log function as NULL.<br>
=C2=A0 multipath-tools: libdmmp: Add new function dmmp_last_error_msg()<br>
=C2=A0 multipath-tools: libdmmp: Add new error DMMP_ERR_PERMISSION_DENY<br>
<br>
=C2=A0libdmmp/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 +=
-<br>
=C2=A0libdmmp/libdmmp.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 20 ++++++=
++++++++++++++<br>
=C2=A0libdmmp/libdmmp/libdmmp.h=C2=A0 =C2=A0| 23 ++++++++++++++++++++++-<br=
>
=C2=A0libdmmp/libdmmp_misc.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libdmmp/test/libdmmp_test.c | 12 ++++++++----<br>
=C2=A0multipathd/cli.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 +=
-<br>
=C2=A06 files changed, 53 insertions(+), 7 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.15.0<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a><br>
</font></span></blockquote></div><br></div>

--94eb2c1969a6c38ab20562a4a40b--


--===============1023901946676342164==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1023901946676342164==--
