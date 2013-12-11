From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 00/16] miscellaneous dm-multipath patches
Date: Wed, 11 Dec 2013 23:52:23 +0100
Message-ID: <CABr-Gne9_7v1wiQGKqZEpAsAjb44vBrWpQk9rX=5WquS55ptxQ@mail.gmail.com>
References: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5203620734779773820=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1386744190-1295-1-git-send-email-bmarzins@redhat.com>
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

--===============5203620734779773820==
Content-Type: multipart/alternative; boundary=001a1134bbf2129fae04ed4a15ac

--001a1134bbf2129fae04ed4a15ac
Content-Type: text/plain; charset=ISO-8859-1

Nice collection of fixes.
Merged, with many thanks.

Christophe Varoqui
www.opensvc.com


On Wed, Dec 11, 2013 at 7:42 AM, Benjamin Marzinski <bmarzins@redhat.com>wrote:

> Here are a number of bugfixes and minor features. The first 8 are a
> resubmit of the patches I sent on Jun 28th.  I didn't see any objection to
> any of them, so
> I just rebased them.
>
> Benjamin Marzinski (16):
>   Add multipath path format wildcard
>   Fix multipath rename from user_friendly_name to wwid
>   Turn off user_friendly_names for netapp devices
>   Don't detect prioritizers that don't work
>   Only load a multipath device RO if RW load fails with EROFS
>   signal waiter thread to stop waiting on dm events
>   fix mutipath -W on empty wwids file
>   multipathd: Add envp variable
>   libmultipath: try to deal with bindings file hand editting
>   kpartx: Make kpartx able to create read-only loop devices
>   libmultipath: show default configurations
>   multipathd: Don't touch the multipath device after setup_multipath
>     fails
>   kpartx: fix strict aliasing warning
>   libmultipath: blacklist blktap devices
>   multipathd: allow /dev/<devnode> to be used for multipathd commands
>   kpartx: autoload loop module on loop partition creation
>
>  kpartx/dasd.c             |  4 +-
>  kpartx/kpartx.c           |  3 +-
>  kpartx/lopart.c           | 19 +++++++--
>  libmultipath/alias.c      | 39 ++++++++++++++-----
>  libmultipath/blacklist.c  |  2 +-
>  libmultipath/configure.c  |  7 ----
>  libmultipath/devmapper.c  | 98
> ++++++++++++-----------------------------------
>  libmultipath/devmapper.h  |  3 --
>  libmultipath/dict.c       |  4 --
>  libmultipath/hwtable.c    |  1 +
>  libmultipath/print.c      | 11 ++++++
>  libmultipath/propsel.c    | 13 +++++--
>  libmultipath/util.c       | 22 +++++++++++
>  libmultipath/util.h       |  1 +
>  libmultipath/waiter.c     |  9 +++++
>  libmultipath/wwids.c      |  6 +++
>  multipath/main.c          | 23 +----------
>  multipathd/cli_handlers.c | 21 +++++++++-
>  multipathd/main.c         | 21 +++++++---
>  19 files changed, 171 insertions(+), 136 deletions(-)
>
> --
> 1.8.4.2
>
>

--001a1134bbf2129fae04ed4a15ac
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Nice collection of fixes.<div>Merged, with many thanks.</d=
iv><div><br></div><div>Christophe Varoqui</div><div><a href=3D"http://www.o=
pensvc.com">www.opensvc.com</a></div></div><div class=3D"gmail_extra"><br><=
br>
<div class=3D"gmail_quote">On Wed, Dec 11, 2013 at 7:42 AM, Benjamin Marzin=
ski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"=
_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">
Here are a number of bugfixes and minor features. The first 8 are a resubmi=
t of the patches I sent on Jun 28th. =A0I didn&#39;t see any objection to a=
ny of them, so<br>
I just rebased them.<br>
<br>
Benjamin Marzinski (16):<br>
=A0 Add multipath path format wildcard<br>
=A0 Fix multipath rename from user_friendly_name to wwid<br>
=A0 Turn off user_friendly_names for netapp devices<br>
=A0 Don&#39;t detect prioritizers that don&#39;t work<br>
=A0 Only load a multipath device RO if RW load fails with EROFS<br>
=A0 signal waiter thread to stop waiting on dm events<br>
=A0 fix mutipath -W on empty wwids file<br>
=A0 multipathd: Add envp variable<br>
=A0 libmultipath: try to deal with bindings file hand editting<br>
=A0 kpartx: Make kpartx able to create read-only loop devices<br>
=A0 libmultipath: show default configurations<br>
=A0 multipathd: Don&#39;t touch the multipath device after setup_multipath<=
br>
=A0 =A0 fails<br>
=A0 kpartx: fix strict aliasing warning<br>
=A0 libmultipath: blacklist blktap devices<br>
=A0 multipathd: allow /dev/&lt;devnode&gt; to be used for multipathd comman=
ds<br>
=A0 kpartx: autoload loop module on loop partition creation<br>
<br>
=A0kpartx/dasd.c =A0 =A0 =A0 =A0 =A0 =A0 | =A04 +-<br>
=A0kpartx/kpartx.c =A0 =A0 =A0 =A0 =A0 | =A03 +-<br>
=A0kpartx/lopart.c =A0 =A0 =A0 =A0 =A0 | 19 +++++++--<br>
=A0libmultipath/alias.c =A0 =A0 =A0| 39 ++++++++++++++-----<br>
=A0libmultipath/blacklist.c =A0| =A02 +-<br>
=A0libmultipath/configure.c =A0| =A07 ----<br>
=A0libmultipath/devmapper.c =A0| 98 ++++++++++++---------------------------=
--------<br>
=A0libmultipath/devmapper.h =A0| =A03 --<br>
=A0libmultipath/dict.c =A0 =A0 =A0 | =A04 --<br>
=A0libmultipath/hwtable.c =A0 =A0| =A01 +<br>
=A0libmultipath/print.c =A0 =A0 =A0| 11 ++++++<br>
=A0libmultipath/propsel.c =A0 =A0| 13 +++++--<br>
=A0libmultipath/util.c =A0 =A0 =A0 | 22 +++++++++++<br>
=A0libmultipath/util.h =A0 =A0 =A0 | =A01 +<br>
=A0libmultipath/waiter.c =A0 =A0 | =A09 +++++<br>
=A0libmultipath/wwids.c =A0 =A0 =A0| =A06 +++<br>
=A0multipath/main.c =A0 =A0 =A0 =A0 =A0| 23 +----------<br>
=A0multipathd/cli_handlers.c | 21 +++++++++-<br>
=A0multipathd/main.c =A0 =A0 =A0 =A0 | 21 +++++++---<br>
=A019 files changed, 171 insertions(+), 136 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.4.2<br>
<br>
</font></span></blockquote></div><br></div>

--001a1134bbf2129fae04ed4a15ac--


--===============5203620734779773820==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5203620734779773820==--
