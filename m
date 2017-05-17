From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/6] small multipath fixes
Date: Thu, 18 May 2017 00:32:34 +0200
Message-ID: <CABr-GnfUBTM_JJTAp7ZGbeKy27LfYcqLuJ75bxOPyYx=G4rQxA@mail.gmail.com>
References: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3126137680137650357=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1494349025-6561-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3126137680137650357==
Content-Type: multipart/alternative; boundary="001a113ce6c25acedf054fbfdd24"

--001a113ce6c25acedf054fbfdd24
Content-Type: text/plain; charset="UTF-8"

This set is merged.
Thanks.

On Tue, May 9, 2017 at 6:56 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> Here are a number of small multipath fixes. These patches are based on
> top of my and Martin's previous patch sets.
>
> Benjamin Marzinski (6):
>   libmultipath: print alias with no_path_retry message
>   multipathd: force reload device on all resizes
>   libmultipath: refactor calls to get dm device info
>   libmultipath: fix suspended devs from failed reloads
>   kpartx: fix device checks
>   mpath_persist: Don't join threads that don't exist
>
>  kpartx/kpartx.c                 |  23 +++--
>  libmpathpersist/mpath_persist.c |  34 +++++---
>  libmpathpersist/mpath_persist.h |   3 +-
>  libmultipath/devmapper.c        | 184 +++++++++++-------------------
> ----------
>  libmultipath/devmapper.h        |   4 +-
>  libmultipath/propsel.c          |   2 +-
>  multipathd/cli_handlers.c       |  25 ++----
>  7 files changed, 100 insertions(+), 175 deletions(-)
>
> --
> 1.8.3.1
>
>

--001a113ce6c25acedf054fbfdd24
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This set is merged.<div>Thanks.</div></div><div class=3D"g=
mail_extra"><br><div class=3D"gmail_quote">On Tue, May 9, 2017 at 6:56 PM, =
Benjamin Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.=
com" target=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex">Here are a number of small multipath fixes. These p=
atches are based on<br>
top of my and Martin&#39;s previous patch sets.<br>
<br>
Benjamin Marzinski (6):<br>
=C2=A0 libmultipath: print alias with no_path_retry message<br>
=C2=A0 multipathd: force reload device on all resizes<br>
=C2=A0 libmultipath: refactor calls to get dm device info<br>
=C2=A0 libmultipath: fix suspended devs from failed reloads<br>
=C2=A0 kpartx: fix device checks<br>
=C2=A0 mpath_persist: Don&#39;t join threads that don&#39;t exist<br>
<br>
=C2=A0kpartx/kpartx.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 23 +++--<br>
=C2=A0libmpathpersist/mpath_persist.<wbr>c |=C2=A0 34 +++++---<br>
=C2=A0libmpathpersist/mpath_persist.<wbr>h |=C2=A0 =C2=A03 +-<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 184 +++++++++++=
-------------------<wbr>----------<br>
=C2=A0libmultipath/devmapper.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A04 +=
-<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=
=A02 +-<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 25 ++----=
<br>
=C2=A07 files changed, 100 insertions(+), 175 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a113ce6c25acedf054fbfdd24--


--===============3126137680137650357==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3126137680137650357==--
