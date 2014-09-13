From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/6] Misc multipath patches
Date: Sat, 13 Sep 2014 08:57:00 +0200
Message-ID: <CABr-GneJNtvp+CehV2LzaNcjm2gXF3AdLUqvDRPMfPSrNzpkTg@mail.gmail.com>
References: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2811603592538497109=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
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

--===============2811603592538497109==
Content-Type: multipart/alternative; boundary=14dae947387b881b390502ece88e

--14dae947387b881b390502ece88e
Content-Type: text/plain; charset=UTF-8

Hi,

this patchset is now all merged upstream, except the "all_devs device
option" part.
I'd like other's comments on this.
I personnality think the goal is fine, but the configuration plug is not so
intuitive.
We already have a top-level "default" section, would defining a top-level
"override" section be more intuitive ?

I'll release 0.5.1, once this feature is merged in the current form or
another.

Best regards,
Christophe Varoqui
OpenSVC


On Fri, Sep 12, 2014 at 7:44 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> Here are some various patches I've had waiting to go upstream
>
> Benjamin Marzinski (6):
>   libmultipath: cleanup rlookup_binding
>   Add support for EMC XtremIO
>   libmultipath: Add additional path wildcards
>   Fix missing frees and null terminations
>   multipath.conf: add all_devs device option
>   Always put watchdog in the config structure
>
>  kpartx/devmapper.c                       |  3 +-
>  libmultipath/alias.c                     | 30 +++++-----
>  libmultipath/blacklist.c                 |  7 +++
>  libmultipath/config.c                    | 59 ++++++++++++++++++++
>  libmultipath/config.h                    |  3 +-
>  libmultipath/dict.c                      | 38 +++++++++++++
>  libmultipath/hwtable.c                   | 13 +++++
>  libmultipath/print.c                     | 95
> +++++++++++++++++++++++++++++++-
>  libmultipath/prioritizers/iet.c          |  2 +
>  libmultipath/prioritizers/weightedpath.c |  5 +-
>  libmultipath/propsel.c                   |  2 +-
>  libmultipath/util.c                      |  2 +-
>  12 files changed, 237 insertions(+), 22 deletions(-)
>
> --
> 1.8.3.1
>
>

--14dae947387b881b390502ece88e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div>this patchset is now all merged ups=
tream, except the &quot;<span style=3D"font-family:arial,sans-serif;font-si=
ze:19.4285717010498px">all_devs device option&quot; part.</span></div><div>=
I&#39;d like other&#39;s comments on this.</div><div>I personnality think t=
he goal is fine, but the configuration plug is not so intuitive.</div><div>=
We already have a top-level &quot;default&quot; section, would defining a t=
op-level &quot;override&quot; section be more intuitive ?<br></div><div><br=
></div><div>I&#39;ll release 0.5.1, once this feature is merged in the curr=
ent form or another.</div><div><br></div><div>Best regards,</div><div>Chris=
tophe Varoqui</div><div>OpenSVC</div><div><br></div></div><div class=3D"gma=
il_extra"><br><div class=3D"gmail_quote">On Fri, Sep 12, 2014 at 7:44 PM, B=
enjamin Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.c=
om" target=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex">Here are some various patches I&#39;ve had waiting t=
o go upstream<br>
<br>
Benjamin Marzinski (6):<br>
=C2=A0 libmultipath: cleanup rlookup_binding<br>
=C2=A0 Add support for EMC XtremIO<br>
=C2=A0 libmultipath: Add additional path wildcards<br>
=C2=A0 Fix missing frees and null terminations<br>
=C2=A0 multipath.conf: add all_devs device option<br>
=C2=A0 Always put watchdog in the config structure<br>
<br>
=C2=A0kpartx/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 3 +-<br>
=C2=A0libmultipath/alias.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0| 30 +++++-----<br>
=C2=A0libmultipath/blacklist.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 7 +++<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 | 59 ++++++++++++++++++++<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 3 +-<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 38 +++++++++++++<br>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0| 13 +++++<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0| 95 +++++++++++++++++++++++++++++++-<br>
=C2=A0libmultipath/prioritizers/iet.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 2 +<br>
=C2=A0libmultipath/prioritizers/weightedpath.c |=C2=A0 5 +-<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 2 +-<br>
=C2=A0libmultipath/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 +-<br>
=C2=A012 files changed, 237 insertions(+), 22 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--14dae947387b881b390502ece88e--


--===============2811603592538497109==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2811603592538497109==--
