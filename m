From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v5 00/21] libmultipath: checkers overhaul
Date: Wed, 14 Nov 2018 08:39:05 +0100
Message-ID: <CABr-Gnc9P44PHV7rB74gMR4SrM77ssHtH-_yTchL-1advz1ybw@mail.gmail.com>
References: <20181102122125.30906-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7149700803341368395=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122125.30906-1-mwilck@suse.com>
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

--===============7149700803341368395==
Content-Type: multipart/alternative; boundary="000000000000036794057a9b08ac"

--000000000000036794057a9b08ac
Content-Type: text/plain; charset="UTF-8"

Merged.
Thanks.

On Fri, Nov 2, 2018 at 1:23 PM Martin Wilck <mwilck@suse.com> wrote:

> Hi Christophe,
>
> This is v5 of my "checkers overhaul" series. Changed wrt v4
> are 03/22, 11/22, and 21/22. I re-post the whole series to
> avoid confusion.
>
> This series starts with a few minor fixes and then attempts
> an overhaul of the checker code.
>
> First, there's a block of patches to get rid of the "message"
> char array in struct checker, replacing it with an integer.
> This topic had been touched in recent discussion between Ben
> and myself. You may want to collaps the patches in this block
> (03/21-11/21) into one when commiting; compilation errors will
> arise if only part of them is a applied.
>
> The next larger block fixes problems with checkers that try
> to check unsupported devices. It's an interesting experience
> to configure wrong checkers for the existing devices and see
> what happens. With these patches, paths won't be falsely
> teared down any more in such situations.
>
> The last patch cleans up the checker data structure by splitting
> it into a "checker class" and the path "checker instance".
>
> There's more work to do in this area, but this is a start.
>
> ----
> changes v4->v5
>  - 03/21: made checker_message() const again, as 22/22 is gone.
>    Got rid of the static buffer in checker_message() by simply returning
>    the constant message strings, as suggested by Ben in his review of v4.
>    This implies printf format changes in callers; changed format in
> get_state().
>  - 11/21: Changed printf format in check_path() (see above).
>  - 21/22: rebased, no actual changes (kept Ben's Reviewed-by).
>  - 22/22: dropped, obsolete.
>
> Changes v3->v4:
>  - 03/22: renamed CHECKER_LAST_GENERIC_MSGID ->
> CHECKER_GENERIC_MSGTABLE_SIZE
>           (Ben).
>  - 12/22: rebased on top of changed 03/22.
>
> Changes v2->v3:
>  - 03/22: fixed one minor issue mentioned by Ben;
>           reverted the const-ification of checker_message(),
>           as it will be reverted in 22/22 anyway.
>  - 13/22: fix clariion checker semantics (Ben).
>  - 21/22: rebased on top of updated 03/22.
>  - 22/22: fix thread-safety issue from 03/22 (Ben).
>
> Changes v1->v2:
>  - 11/22: rebased on top of "various multipath-tools patches" series
>
> Martin Wilck (21):
>   libmultipath: fix use of uninitialized memory in write()
>   libmultipath: fix memory leaks from scandir() use
>   libmultipath/checkers: replace message by msgid
>   libmultipath/checkers: cciss_tur: use message id
>   libmultipath/checkers: directio: use message id
>   libmultipath/checkers: emc_clariion: use message id
>   libmultipath/checkers: hp_sw: use message id
>   libmultipath/checkers: rdac: use message id
>   libmultipath/checkers: readsector0: use message id
>   libmultipath/checkers: tur: use message id
>   multipathd: improve checker message logging
>   libmultipath/checkers: support unsupported paths
>   libmultipath: clariion checker: leave unsupported paths alone
>   libmultipath: hp_sw checker: leave unsupported paths alone
>   libmultipath: rdac checker: leave unsupported paths alone
>   libmultipath: tur checker: leave unsupported paths alone
>   libmultipath: pathinfo: don't blank wwid if checker fails
>   multipathd: check_path: improve logging for "unusable path" case
>   libmultipath: coalesce_paths: improve logging of orphaned paths
>   libmultipath: sync_map_state: log failing paths
>   libmultipath/checkers: cleanup class/instance model
>
>  libmultipath/checkers.c              | 187 +++++++++++++++++----------
>  libmultipath/checkers.h              |  69 ++++++----
>  libmultipath/checkers/cciss_tur.c    |  13 +-
>  libmultipath/checkers/directio.c     |  29 +++--
>  libmultipath/checkers/emc_clariion.c | 114 +++++++++++++---
>  libmultipath/checkers/hp_sw.c        |  39 +++---
>  libmultipath/checkers/rdac.c         |  92 +++++++++----
>  libmultipath/checkers/readsector0.c  |   7 +-
>  libmultipath/checkers/tur.c          |  60 +++++----
>  libmultipath/config.c                |  10 +-
>  libmultipath/configure.c             |  10 +-
>  libmultipath/discovery.c             |  11 +-
>  libmultipath/foreign.c               |   5 +-
>  libmultipath/foreign/nvme.c          |   6 +-
>  libmultipath/print.c                 |   2 +-
>  libmultipath/propsel.c               |  19 +--
>  libmultipath/structs_vec.c           |   5 +-
>  libmultipath/sysfs.c                 |   5 +-
>  libmultipath/util.c                  |   9 ++
>  libmultipath/util.h                  |   9 ++
>  multipathd/main.c                    |  38 ++++--
>  21 files changed, 497 insertions(+), 242 deletions(-)
>
> --
> 2.19.1
>
>

--000000000000036794057a9b08ac
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><br><div class=3D"gmail_quo=
te"><div dir=3D"ltr">On Fri, Nov 2, 2018 at 1:23 PM Martin Wilck &lt;<a hre=
f=3D"mailto:mwilck@suse.com">mwilck@suse.com</a>&gt; wrote:<br></div><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">Hi Christophe,<br>
<br>
This is v5 of my &quot;checkers overhaul&quot; series. Changed wrt v4<br>
are 03/22, 11/22, and 21/22. I re-post the whole series to<br>
avoid confusion.<br>
<br>
This series starts with a few minor fixes and then attempts<br>
an overhaul of the checker code.<br>
<br>
First, there&#39;s a block of patches to get rid of the &quot;message&quot;=
<br>
char array in struct checker, replacing it with an integer.<br>
This topic had been touched in recent discussion between Ben<br>
and myself. You may want to collaps the patches in this block<br>
(03/21-11/21) into one when commiting; compilation errors will<br>
arise if only part of them is a applied.<br>
<br>
The next larger block fixes problems with checkers that try<br>
to check unsupported devices. It&#39;s an interesting experience<br>
to configure wrong checkers for the existing devices and see<br>
what happens. With these patches, paths won&#39;t be falsely<br>
teared down any more in such situations.<br>
<br>
The last patch cleans up the checker data structure by splitting<br>
it into a &quot;checker class&quot; and the path &quot;checker instance&quo=
t;.<br>
<br>
There&#39;s more work to do in this area, but this is a start.<br>
<br>
----<br>
changes v4-&gt;v5<br>
=C2=A0- 03/21: made checker_message() const again, as 22/22 is gone.<br>
=C2=A0 =C2=A0Got rid of the static buffer in checker_message() by simply re=
turning<br>
=C2=A0 =C2=A0the constant message strings, as suggested by Ben in his revie=
w of v4.<br>
=C2=A0 =C2=A0This implies printf format changes in callers; changed format =
in get_state().<br>
=C2=A0- 11/21: Changed printf format in check_path() (see above).<br>
=C2=A0- 21/22: rebased, no actual changes (kept Ben&#39;s Reviewed-by).<br>
=C2=A0- 22/22: dropped, obsolete.<br>
<br>
Changes v3-&gt;v4:<br>
=C2=A0- 03/22: renamed CHECKER_LAST_GENERIC_MSGID -&gt; CHECKER_GENERIC_MSG=
TABLE_SIZE<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (Ben).<br>
=C2=A0- 12/22: rebased on top of changed 03/22.<br>
<br>
Changes v2-&gt;v3:<br>
=C2=A0- 03/22: fixed one minor issue mentioned by Ben;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 reverted the const-ification of checker_=
message(),<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 as it will be reverted in 22/22 anyway.<=
br>
=C2=A0- 13/22: fix clariion checker semantics (Ben).<br>
=C2=A0- 21/22: rebased on top of updated 03/22.<br>
=C2=A0- 22/22: fix thread-safety issue from 03/22 (Ben).<br>
<br>
Changes v1-&gt;v2:<br>
=C2=A0- 11/22: rebased on top of &quot;various multipath-tools patches&quot=
; series<br>
<br>
Martin Wilck (21):<br>
=C2=A0 libmultipath: fix use of uninitialized memory in write()<br>
=C2=A0 libmultipath: fix memory leaks from scandir() use<br>
=C2=A0 libmultipath/checkers: replace message by msgid<br>
=C2=A0 libmultipath/checkers: cciss_tur: use message id<br>
=C2=A0 libmultipath/checkers: directio: use message id<br>
=C2=A0 libmultipath/checkers: emc_clariion: use message id<br>
=C2=A0 libmultipath/checkers: hp_sw: use message id<br>
=C2=A0 libmultipath/checkers: rdac: use message id<br>
=C2=A0 libmultipath/checkers: readsector0: use message id<br>
=C2=A0 libmultipath/checkers: tur: use message id<br>
=C2=A0 multipathd: improve checker message logging<br>
=C2=A0 libmultipath/checkers: support unsupported paths<br>
=C2=A0 libmultipath: clariion checker: leave unsupported paths alone<br>
=C2=A0 libmultipath: hp_sw checker: leave unsupported paths alone<br>
=C2=A0 libmultipath: rdac checker: leave unsupported paths alone<br>
=C2=A0 libmultipath: tur checker: leave unsupported paths alone<br>
=C2=A0 libmultipath: pathinfo: don&#39;t blank wwid if checker fails<br>
=C2=A0 multipathd: check_path: improve logging for &quot;unusable path&quot=
; case<br>
=C2=A0 libmultipath: coalesce_paths: improve logging of orphaned paths<br>
=C2=A0 libmultipath: sync_map_state: log failing paths<br>
=C2=A0 libmultipath/checkers: cleanup class/instance model<br>
<br>
=C2=A0libmultipath/checkers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | 187 +++++++++++++++++----------<br>
=C2=A0libmultipath/checkers.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 69 ++++++----<br>
=C2=A0libmultipath/checkers/cciss_tur.c=C2=A0 =C2=A0 |=C2=A0 13 +-<br>
=C2=A0libmultipath/checkers/directio.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 29 +++--<=
br>
=C2=A0libmultipath/checkers/emc_clariion.c | 114 +++++++++++++---<br>
=C2=A0libmultipath/checkers/hp_sw.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 39 +=
++---<br>
=C2=A0libmultipath/checkers/rdac.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0=
 92 +++++++++----<br>
=C2=A0libmultipath/checkers/readsector0.c=C2=A0 |=C2=A0 =C2=A07 +-<br>
=C2=A0libmultipath/checkers/tur.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0=
 60 +++++----<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 |=C2=A0 10 +-<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 10 +-<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 11 +-<br>
=C2=A0libmultipath/foreign.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 =C2=A05 +-<br>
=C2=A0libmultipath/foreign/nvme.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0=
 =C2=A06 +-<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 19 +--<br>
=C2=A0libmultipath/structs_vec.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 =C2=A05 +-<br>
=C2=A0libmultipath/sysfs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 =C2=A05 +-<br>
=C2=A0libmultipath/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A09 ++<br>
=C2=A0libmultipath/util.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A09 ++<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 38 ++++--<br>
=C2=A021 files changed, 497 insertions(+), 242 deletions(-)<br>
<br>
-- <br>
2.19.1<br>
<br>
</blockquote></div>

--000000000000036794057a9b08ac--


--===============7149700803341368395==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7149700803341368395==--
