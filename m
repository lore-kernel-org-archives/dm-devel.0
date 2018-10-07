From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v3 00/19] Misc Multipath patches
Date: Sun, 7 Oct 2018 10:36:41 +0200
Message-ID: <CABr-GneyGf+Ks8ZkaFoReYuvSXvpfPwaXgg7eVFNoFCh84RwpA@mail.gmail.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6990001963978117870=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============6990001963978117870==
Content-Type: multipart/alternative; boundary="0000000000000651cd05779f6835"

--0000000000000651cd05779f6835
Content-Type: text/plain; charset="UTF-8"

Hi Ben,

this v3 patchset is ready for merge or do you plan a v4 ?

Thanks,
Christophe

On Sat, Sep 22, 2018 at 1:05 AM Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> This batch of patches is a resend of the non-merged pathes from my last
> set, along with 2 new ones. It would be really great if we could get
> a version bug after the outstanding commits go it.
>
> Patches 0001-0005 are a number of fixes to the tur checker.These are
>         the ones that should get the most attention.
> Patches 0006-0017 are minor issues found by coverity.
>         Not all of them are bugs that could actually occur in practice,
>         but they are simple and hopefully non-controversial changes.
> Patches 0018-0019 are new and related to changing path wwids
>
> Changes in v3
>         added patches 0018-0019
>
> Changes in v2
>         0002-libmultipath-fix-tur-checker-double-locking.patch now sets
>         ct->devt when initially creating the tur_checker_context, while
>         that structure is still only referenced by a local variable.
>         After that, ct->devt is only ever read. This should remove any
>         issues with it needing locking.
>
> Benjamin Marzinski (19):
>   libmultipath: fix tur checker timeout
>   libmultipath: fix tur checker double locking
>   libmultipath: fix tur memory misuse
>   libmultipath: cleanup tur locking
>   libmultipath: fix tur checker timeout issue
>   libmultipath: fix set_int error path
>   libmultipath: fix length issues in get_vpd_sgio
>   libmultipath: _install_keyword cleanup
>   libmultipath: remove unused code
>   libmultipath: fix memory issue in path_latency prio
>   libmultipath: fix null dereference int alloc_path_group
>   libmutipath: don't use malformed uevents
>   multipath: fix max array size in print_cmd_valid
>   multipathd: function return value tweaks
>   multipathd: minor fixes
>   multipathd: remove useless check and fix format
>   multipathd: fix memory leak on error in configure
>   libmultipath: Don't blank intialized paths
>   libmultipath: Fixup updating paths
>
>  libmultipath/checkers/tur.c              | 168
> +++++++++++--------------------
>  libmultipath/dict.c                      |   5 +-
>  libmultipath/discovery.c                 |  18 ++--
>  libmultipath/parser.c                    |  12 ++-
>  libmultipath/print.c                     |   8 --
>  libmultipath/prioritizers/path_latency.c |   3 +-
>  libmultipath/structs.c                   |   2 +-
>  libmultipath/uevent.c                    |   6 ++
>  multipath/main.c                         |   2 +-
>  multipathd/cli_handlers.c                |  11 +-
>  multipathd/main.c                        |  50 +++++----
>  11 files changed, 131 insertions(+), 154 deletions(-)
>
> --
> 2.7.4
>
>

--0000000000000651cd05779f6835
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Ben,<div><br></div><div>this v3 patchset is ready for m=
erge or do you plan a v4 ?</div><div><br></div><div>Thanks,</div><div>Chris=
tophe</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Sat, Se=
p 22, 2018 at 1:05 AM Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@red=
hat.com">bmarzins@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">This batch of patches is a resend of the non-merged pathes from my=
 last<br>
set, along with 2 new ones. It would be really great if we could get<br>
a version bug after the outstanding commits go it.<br>
<br>
Patches 0001-0005 are a number of fixes to the tur checker.These are<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 the ones that should get the most attention.<br=
>
Patches 0006-0017 are minor issues found by coverity.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Not all of them are bugs that could actually oc=
cur in practice,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 but they are simple and hopefully non-controver=
sial changes.<br>
Patches 0018-0019 are new and related to changing path wwids<br>
<br>
Changes in v3<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 added patches 0018-0019<br>
<br>
Changes in v2<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 0002-libmultipath-fix-tur-checker-double-lockin=
g.patch now sets<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ct-&gt;devt when initially creating the tur_che=
cker_context, while<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 that structure is still only referenced by a lo=
cal variable.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 After that, ct-&gt;devt is only ever read. This=
 should remove any<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 issues with it needing locking.<br>
<br>
Benjamin Marzinski (19):<br>
=C2=A0 libmultipath: fix tur checker timeout<br>
=C2=A0 libmultipath: fix tur checker double locking<br>
=C2=A0 libmultipath: fix tur memory misuse<br>
=C2=A0 libmultipath: cleanup tur locking<br>
=C2=A0 libmultipath: fix tur checker timeout issue<br>
=C2=A0 libmultipath: fix set_int error path<br>
=C2=A0 libmultipath: fix length issues in get_vpd_sgio<br>
=C2=A0 libmultipath: _install_keyword cleanup<br>
=C2=A0 libmultipath: remove unused code<br>
=C2=A0 libmultipath: fix memory issue in path_latency prio<br>
=C2=A0 libmultipath: fix null dereference int alloc_path_group<br>
=C2=A0 libmutipath: don&#39;t use malformed uevents<br>
=C2=A0 multipath: fix max array size in print_cmd_valid<br>
=C2=A0 multipathd: function return value tweaks<br>
=C2=A0 multipathd: minor fixes<br>
=C2=A0 multipathd: remove useless check and fix format<br>
=C2=A0 multipathd: fix memory leak on error in configure<br>
=C2=A0 libmultipath: Don&#39;t blank intialized paths<br>
=C2=A0 libmultipath: Fixup updating paths<br>
<br>
=C2=A0libmultipath/checkers/tur.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 | 168 +++++++++++--------------------<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A05 +-<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0|=C2=A0 18 ++--<br>
=C2=A0libmultipath/parser.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 12 ++-<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A08 --<br>
=C2=A0libmultipath/prioritizers/path_latency.c |=C2=A0 =C2=A03 +-<br>
=C2=A0libmultipath/structs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/uevent.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A06 ++<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 11 +-<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 50 +++++----<br>
=C2=A011 files changed, 131 insertions(+), 154 deletions(-)<br>
<br>
-- <br>
2.7.4<br>
<br>
</blockquote></div>

--0000000000000651cd05779f6835--


--===============6990001963978117870==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6990001963978117870==--
