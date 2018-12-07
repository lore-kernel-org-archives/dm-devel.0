From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 00/24] multipath-tools: improve logging at
	-v3
Date: Fri, 7 Dec 2018 17:02:03 +0100
Message-ID: <CABr-GndvtxY4JD1bWXKtL80QA4YxrCiPfkjMbLxiEDXXQ0eDZA@mail.gmail.com>
References: <20181203193624.21870-1-mwilck@suse.com>
	<20181203235035.GC13270@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2495732468772412148=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181203235035.GC13270@octiron.msp.redhat.com>
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

--===============2495732468772412148==
Content-Type: multipart/alternative; boundary="00000000000025a8f3057c70bdc0"

--00000000000025a8f3057c70bdc0
Content-Type: text/plain; charset="UTF-8"

Hi Martin,

pending patches, except the logging refactoring patchset, are merged.
When you'll be ready to send the v3 of this patchset, please send the full
set : some of the reviewed v1 patches are missing in my mailbox.

Thanks,
Christophe

On Tue, Dec 4, 2018 at 12:50 AM Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Mon, Dec 03, 2018 at 08:36:18PM +0100, Martin Wilck wrote:
> > Hi Christophe,
> >
> > most of the patches in this series reduce log levels of frequently
> > printed messages at verbosity level 3. My goal was to limit the
> > output of multipathd to one line per path per checker invocation,
> > which is sufficient to track multipathd's view of path health in
> > the logs.
> >
> > The standard setting of -v2 is not enough for post-mortem analysis of
> many
> > failures. With this series, running multipathd with verbosity 3 becomes a
> > realistic option even in production environments. So far the amount of
> output
> > from multipathd with -v3 pretty much made this impossible, at least over
> > longer time periods, and also made reading these logs very cumbersome
> due to
> > the amount of redundant partly superfluos verbosity. I've taken care not
> > to loose important information in the logs.
> >
> > Apart from that, the series fixes errors in the unit tests introduced by
> my
> > last "checker overhaul" patch series (proving that I forgot to run the
> > tests before submitting :-( ), and fixes a problem that I found while
> testing
> > handling of a bad configuration (paths with size mismatch).
> >
> > Regards,
> > Martin
> >
> > Changes in v2:
> >
> > The first 19 patches are identical to v1 as ACK'd by Ben, except 16/24
> > "libmultipath: coalesce_paths: fix size mismatch handling".
> > No. 8/24 "libmultipath: decrease log level of word splitting"
> > (not yet ACKd by Ben) also stays the same; the issue Ben raised
> > in his review is addressed in a separate patch, 20/24.
> > 21/24 addresses implements Ben's suggestion to use named constants
> > as return values in coalesce_paths(). 22, 23, 24 do the same for
> > other important, related functions, as I found it strange to make
> > this change just for coalesce_paths() alone.
>
> Thanks
>
> ACK for everything except 23/24
>
> -Ben
>
> >
> > Martin Wilck (24):
> >   tests/hwtable: set multipath_dir in local configuration
> >   tests/hwtable: adjust to new checker API
> >   multipath-tools: decrease verbosity of state messages
> >   libmultipath: decrease verbosity of pathinfo messages
> >   libmultipath: decrease verbosity of TUR checker messages
> >   libmultipath: avoid frequent messages from filter_property()
> >   libmultipath: decrease log level of "disassembled" messages
> >   libmultipath: decrease log level of word splitting
> >   libmultipath: increase log level of map removal
> >   multipathd: decrease log level of checker timing
> >   libmultipath: decrease log level of "prioritizer refcount" message
> >   libmpathpersist/update_map_pr: decrease log level for nop
> >   libmultipath: simplify devt2devname()
> >   libmultipath: decrease log level for failed VPD c9
> >   libmultipath: adopt_paths: check for size match
> >   libmultipath: coalesce_paths: fix size mismatch handling
> >   tests: add unit tests for bitmask functions
> >   multipathd: uev_remove_path: remove redundant orphan_paths call
> >   libmultipath: improve logging from orphan_paths
> >   libmultipath: avoid syslog loglevel > LOG_DEBUG
> >   coalesce_paths(): use symbolic return value
> >   domap(): use symbolic return value
> >   domap(): never return DOMAP_RETRY in daemon mode
> >   multipath: use symbolic return value and exit code
> >
> >  libmpathpersist/mpath_persist.c |   3 +-
> >  libmultipath/blacklist.c        |  54 +++++++-------
> >  libmultipath/blacklist.h        |   2 +-
> >  libmultipath/checkers/tur.c     |   6 +-
> >  libmultipath/configure.c        |  68 +++++++++---------
> >  libmultipath/configure.h        |  23 ++++++
> >  libmultipath/discovery.c        |  20 +++---
> >  libmultipath/dmparser.c         |   6 +-
> >  libmultipath/log_pthread.c      |   3 +
> >  libmultipath/prio.c             |   2 +-
> >  libmultipath/structs_vec.c      |  18 +++--
> >  libmultipath/structs_vec.h      |   3 +-
> >  libmultipath/util.c             |   7 +-
> >  libmultipath/util.h             |  16 +++++
> >  multipath/main.c                | 121 ++++++++++++++++++--------------
> >  multipathd/cli_handlers.c       |   5 +-
> >  multipathd/main.c               |  39 +++++-----
> >  tests/Makefile                  |   7 +-
> >  tests/blacklist.c               |   7 +-
> >  tests/hwtable.c                 |  89 ++++++++++++-----------
> >  tests/util.c                    |  98 ++++++++++++++++++++++++++
> >  21 files changed, 386 insertions(+), 211 deletions(-)
> >
> > --
> > 2.19.1
>

--00000000000025a8f3057c70bdc0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Martin,<div><br></div><div>pending patches, except the =
logging refactoring patchset, are merged.</div><div>When you&#39;ll be read=
y to send the v3 of this patchset, please send the full set : some of the r=
eviewed v1 patches are missing in my mailbox.</div><div><br></div><div>Than=
ks,</div><div>Christophe</div></div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr">On Tue, Dec 4, 2018 at 12:50 AM Benjamin Marzinski &lt;<a href=3D"=
mailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt; wrote:<br></div><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #=
ccc solid;padding-left:1ex">On Mon, Dec 03, 2018 at 08:36:18PM +0100, Marti=
n Wilck wrote:<br>
&gt; Hi Christophe,<br>
&gt; <br>
&gt; most of the patches in this series reduce log levels of frequently<br>
&gt; printed messages at verbosity level 3. My goal was to limit the<br>
&gt; output of multipathd to one line per path per checker invocation,<br>
&gt; which is sufficient to track multipathd&#39;s view of path health in<b=
r>
&gt; the logs.<br>
&gt; <br>
&gt; The standard setting of -v2 is not enough for post-mortem analysis of =
many<br>
&gt; failures. With this series, running multipathd with verbosity 3 become=
s a<br>
&gt; realistic option even in production environments. So far the amount of=
 output<br>
&gt; from multipathd with -v3 pretty much made this impossible, at least ov=
er<br>
&gt; longer time periods, and also made reading these logs very cumbersome =
due to<br>
&gt; the amount of redundant partly superfluos verbosity. I&#39;ve taken ca=
re not<br>
&gt; to loose important information in the logs.<br>
&gt; <br>
&gt; Apart from that, the series fixes errors in the unit tests introduced =
by my<br>
&gt; last &quot;checker overhaul&quot; patch series (proving that I forgot =
to run the<br>
&gt; tests before submitting :-( ), and fixes a problem that I found while =
testing<br>
&gt; handling of a bad configuration (paths with size mismatch).<br>
&gt; <br>
&gt; Regards,<br>
&gt; Martin<br>
&gt; <br>
&gt; Changes in v2:<br>
&gt; <br>
&gt; The first 19 patches are identical to v1 as ACK&#39;d by Ben, except 1=
6/24<br>
&gt; &quot;libmultipath: coalesce_paths: fix size mismatch handling&quot;.<=
br>
&gt; No. 8/24 &quot;libmultipath: decrease log level of word splitting&quot=
;<br>
&gt; (not yet ACKd by Ben) also stays the same; the issue Ben raised<br>
&gt; in his review is addressed in a separate patch, 20/24.<br>
&gt; 21/24 addresses implements Ben&#39;s suggestion to use named constants=
<br>
&gt; as return values in coalesce_paths(). 22, 23, 24 do the same for<br>
&gt; other important, related functions, as I found it strange to make<br>
&gt; this change just for coalesce_paths() alone.=C2=A0 <br>
<br>
Thanks<br>
<br>
ACK for everything except 23/24<br>
<br>
-Ben<br>
<br>
&gt; <br>
&gt; Martin Wilck (24):<br>
&gt;=C2=A0 =C2=A0tests/hwtable: set multipath_dir in local configuration<br=
>
&gt;=C2=A0 =C2=A0tests/hwtable: adjust to new checker API<br>
&gt;=C2=A0 =C2=A0multipath-tools: decrease verbosity of state messages<br>
&gt;=C2=A0 =C2=A0libmultipath: decrease verbosity of pathinfo messages<br>
&gt;=C2=A0 =C2=A0libmultipath: decrease verbosity of TUR checker messages<b=
r>
&gt;=C2=A0 =C2=A0libmultipath: avoid frequent messages from filter_property=
()<br>
&gt;=C2=A0 =C2=A0libmultipath: decrease log level of &quot;disassembled&quo=
t; messages<br>
&gt;=C2=A0 =C2=A0libmultipath: decrease log level of word splitting<br>
&gt;=C2=A0 =C2=A0libmultipath: increase log level of map removal<br>
&gt;=C2=A0 =C2=A0multipathd: decrease log level of checker timing<br>
&gt;=C2=A0 =C2=A0libmultipath: decrease log level of &quot;prioritizer refc=
ount&quot; message<br>
&gt;=C2=A0 =C2=A0libmpathpersist/update_map_pr: decrease log level for nop<=
br>
&gt;=C2=A0 =C2=A0libmultipath: simplify devt2devname()<br>
&gt;=C2=A0 =C2=A0libmultipath: decrease log level for failed VPD c9<br>
&gt;=C2=A0 =C2=A0libmultipath: adopt_paths: check for size match<br>
&gt;=C2=A0 =C2=A0libmultipath: coalesce_paths: fix size mismatch handling<b=
r>
&gt;=C2=A0 =C2=A0tests: add unit tests for bitmask functions<br>
&gt;=C2=A0 =C2=A0multipathd: uev_remove_path: remove redundant orphan_paths=
 call<br>
&gt;=C2=A0 =C2=A0libmultipath: improve logging from orphan_paths<br>
&gt;=C2=A0 =C2=A0libmultipath: avoid syslog loglevel &gt; LOG_DEBUG<br>
&gt;=C2=A0 =C2=A0coalesce_paths(): use symbolic return value<br>
&gt;=C2=A0 =C2=A0domap(): use symbolic return value<br>
&gt;=C2=A0 =C2=A0domap(): never return DOMAP_RETRY in daemon mode<br>
&gt;=C2=A0 =C2=A0multipath: use symbolic return value and exit code<br>
&gt; <br>
&gt;=C2=A0 libmpathpersist/mpath_persist.c |=C2=A0 =C2=A03 +-<br>
&gt;=C2=A0 libmultipath/blacklist.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 54 +=
++++++-------<br>
&gt;=C2=A0 libmultipath/blacklist.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=
=A02 +-<br>
&gt;=C2=A0 libmultipath/checkers/tur.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A06 +=
-<br>
&gt;=C2=A0 libmultipath/configure.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 68 +=
++++++++---------<br>
&gt;=C2=A0 libmultipath/configure.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 23 +=
+++++<br>
&gt;=C2=A0 libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 20 +=
++---<br>
&gt;=C2=A0 libmultipath/dmparser.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0=
 =C2=A06 +-<br>
&gt;=C2=A0 libmultipath/log_pthread.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A03 +=
<br>
&gt;=C2=A0 libmultipath/prio.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 =C2=A02 +-<br>
&gt;=C2=A0 libmultipath/structs_vec.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 18 +++--<=
br>
&gt;=C2=A0 libmultipath/structs_vec.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A03 +=
-<br>
&gt;=C2=A0 libmultipath/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 =C2=A07 +-<br>
&gt;=C2=A0 libmultipath/util.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 16 +++++<br>
&gt;=C2=A0 multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 | 121 ++++++++++++++++++--------------<br>
&gt;=C2=A0 multipathd/cli_handlers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A05 +-<br>
&gt;=C2=A0 multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 39 +++++-----<br>
&gt;=C2=A0 tests/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A07 +-<br>
&gt;=C2=A0 tests/blacklist.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 =C2=A07 +-<br>
&gt;=C2=A0 tests/hwtable.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|=C2=A0 89 ++++++++++++-----------<br>
&gt;=C2=A0 tests/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 |=C2=A0 98 ++++++++++++++++++++++++++<br>
&gt;=C2=A0 21 files changed, 386 insertions(+), 211 deletions(-)<br>
&gt; <br>
&gt; -- <br>
&gt; 2.19.1<br>
</blockquote></div>

--00000000000025a8f3057c70bdc0--


--===============2495732468772412148==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2495732468772412148==--
