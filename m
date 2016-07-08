From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCHv2 00/26] Userspace-RCU for config accesses
Date: Fri, 8 Jul 2016 07:53:00 +0200
Message-ID: <CABr-Gnfo8W-uMAhyZb3aYQp_nKHa2fhL9ytP9EUawOB=RY5tUQ@mail.gmail.com>
References: <1467616126-10036-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5743344458867530591=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467616126-10036-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5743344458867530591==
Content-Type: multipart/alternative; boundary=001a1140d2be5348390537196a72

--001a1140d2be5348390537196a72
Content-Type: text/plain; charset=UTF-8

The rcu v2 branch is now merged.

Thanks.

On Mon, Jul 4, 2016 at 9:08 AM, Hannes Reinecke <hare@suse.de> wrote:

> Hi all,
>
> as Benjamin Marzinski pointed out the 'config' structure is
> not protected, but it will be re-allocated whenever we do a
> reconfiguration.
> This leads to inevitable race conditions, which ATM are only
> imperfectly handled.
> With this patchset accesses to the configuration are RCU-protected,
> so we are guaranteed that the pointer to the configuration is always
> valid.
> To facilitate this the patchset moves the 'cmd', 'dev', and 'dev_type'
> entries out of the configuration, and replaces them with local variables
> in multipath.
>
> Changes to the original version:
> - Fixup arguments for get_mpe_wwid() and find_mpe() as
>   found by Ben Marzinski
> - Revert to original handling in get_state() as found
>   by Ben Marzinski
>
> The patchset can be found at
>
> github.com:/hreinecke/multipath-tools.git
> branch rcu.v2
>
> As usual, comments and reviews are welcome.
>
> Hannes Reinecke (26):
>   Revert patch 'move filter_devnode() under vector lock'
>   Use 'mptable' as argument for find_mpe() and get_mpe_wwid()
>   config: set 'deferred_remove' defaults at correct call
>   devmapper: explicit config settings
>   dmparser: use 'is_daemon' as argument for disassemble_map()
>   libmultipath: use 'is_daemon' as argument for domap() etc
>   libmultipath: drop 'daemon' configuration setting
>   libmultipath: Do not access 'conf->cmd' in domap()
>   libmultipath: add 'cmd' as argument for get_refwwid()
>   libmultipath: fallback to checking environment variable in
>     get_udev_uid()
>   multipath: make 'cmd' internal to multipath program
>   multipath: make 'dev_type' internal to the multipath program
>   multipath: make 'dev' internal to the multipath program
>   libmultipath: separate out 'udev' config entry
>   libmultipath: use 'checkint' as argument for sysfs_set_scsi_tmo()
>   discovery: Pass in 'hwtable' for get_state() and
>     scsi_sysfs_discovery()
>   libmultipath: use 'struct config' as argument for pathinfo()
>   checkers: use 'multipath_dir' as argument
>   prio: use 'multipath_dir' as argument
>   libmultipath: use 'timeout' as argument for getprio()
>   libmultipath: use explicit 'config' argument for configuration file
>     parsing
>   libmultipath: use (get,put)_multipath_config() accessors
>   multipathd: Fixup commandline argument handling
>   multipath: make 'struct config' a local variable
>   multipathd: use userspace RCU to access configuration
>   libmultipath: Allocate keywords directly
>
>  libmpathpersist/mpath_persist.c       |  28 +--
>  libmpathpersist/mpath_persist.h       |   6 +-
>  libmultipath/checkers.c               |  22 ++-
>  libmultipath/checkers.h               |   6 +-
>  libmultipath/config.c                 |  43 ++---
>  libmultipath/config.h                 |  18 +-
>  libmultipath/configure.c              | 163 +++++++++++------
>  libmultipath/configure.h              |  10 +-
>  libmultipath/debug.c                  |   3 +
>  libmultipath/devmapper.c              |  21 +--
>  libmultipath/devmapper.h              |   4 +-
>  libmultipath/dict.c                   |  79 ++++----
>  libmultipath/dict.h                   |   2 +-
>  libmultipath/discovery.c              | 108 ++++++-----
>  libmultipath/discovery.h              |  12 +-
>  libmultipath/dmparser.c               |   6 +-
>  libmultipath/dmparser.h               |   2 +-
>  libmultipath/parser.c                 |  61 +++----
>  libmultipath/parser.h                 |  27 +--
>  libmultipath/print.c                  |  72 ++++----
>  libmultipath/print.h                  |  16 +-
>  libmultipath/prio.c                   |  40 +++--
>  libmultipath/prio.h                   |  14 +-
>  libmultipath/prioritizers/alua.c      |  12 +-
>  libmultipath/prioritizers/alua_rtpg.c |  25 +--
>  libmultipath/prioritizers/alua_rtpg.h |   6 +-
>  libmultipath/prioritizers/emc.c       |   8 +-
>  libmultipath/prioritizers/hds.c       |   8 +-
>  libmultipath/prioritizers/hp_sw.c     |  46 ++---
>  libmultipath/prioritizers/ontap.c     |  19 +-
>  libmultipath/prioritizers/rdac.c      |   8 +-
>  libmultipath/propsel.c                |  99 +++++-----
>  libmultipath/propsel.h                |  48 ++---
>  libmultipath/structs_vec.c            |  62 ++++---
>  libmultipath/structs_vec.h            |  13 +-
>  libmultipath/waiter.c                 |   4 +
>  libmultipath/wwids.c                  |  22 ++-
>  mpathpersist/main.c                   |  24 ++-
>  multipath/main.c                      | 199 ++++++++++++---------
>  multipathd/Makefile                   |   2 +-
>  multipathd/cli_handlers.c             |  84 ++++++---
>  multipathd/main.c                     | 327
> +++++++++++++++++++++++-----------
>  multipathd/uxlsnr.c                   |   5 -
>  43 files changed, 1057 insertions(+), 727 deletions(-)
>
> --
> 2.6.6
>
>

--001a1140d2be5348390537196a72
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The rcu v2 branch is now merged.<div><br></div><div>Thanks=
.</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On M=
on, Jul 4, 2016 at 9:08 AM, Hannes Reinecke <span dir=3D"ltr">&lt;<a href=
=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>&gt;</span> wrot=
e:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex">Hi all,<br>
<br>
as Benjamin Marzinski pointed out the &#39;config&#39; structure is<br>
not protected, but it will be re-allocated whenever we do a<br>
reconfiguration.<br>
This leads to inevitable race conditions, which ATM are only<br>
imperfectly handled.<br>
With this patchset accesses to the configuration are RCU-protected,<br>
so we are guaranteed that the pointer to the configuration is always<br>
valid.<br>
To facilitate this the patchset moves the &#39;cmd&#39;, &#39;dev&#39;, and=
 &#39;dev_type&#39;<br>
entries out of the configuration, and replaces them with local variables<br=
>
in multipath.<br>
<br>
Changes to the original version:<br>
- Fixup arguments for get_mpe_wwid() and find_mpe() as<br>
=C2=A0 found by Ben Marzinski<br>
- Revert to original handling in get_state() as found<br>
=C2=A0 by Ben Marzinski<br>
<br>
The patchset can be found at<br>
<br>
github.com:/hreinecke/multipath-tools.git<br>
branch rcu.v2<br>
<br>
As usual, comments and reviews are welcome.<br>
<br>
Hannes Reinecke (26):<br>
=C2=A0 Revert patch &#39;move filter_devnode() under vector lock&#39;<br>
=C2=A0 Use &#39;mptable&#39; as argument for find_mpe() and get_mpe_wwid()<=
br>
=C2=A0 config: set &#39;deferred_remove&#39; defaults at correct call<br>
=C2=A0 devmapper: explicit config settings<br>
=C2=A0 dmparser: use &#39;is_daemon&#39; as argument for disassemble_map()<=
br>
=C2=A0 libmultipath: use &#39;is_daemon&#39; as argument for domap() etc<br=
>
=C2=A0 libmultipath: drop &#39;daemon&#39; configuration setting<br>
=C2=A0 libmultipath: Do not access &#39;conf-&gt;cmd&#39; in domap()<br>
=C2=A0 libmultipath: add &#39;cmd&#39; as argument for get_refwwid()<br>
=C2=A0 libmultipath: fallback to checking environment variable in<br>
=C2=A0 =C2=A0 get_udev_uid()<br>
=C2=A0 multipath: make &#39;cmd&#39; internal to multipath program<br>
=C2=A0 multipath: make &#39;dev_type&#39; internal to the multipath program=
<br>
=C2=A0 multipath: make &#39;dev&#39; internal to the multipath program<br>
=C2=A0 libmultipath: separate out &#39;udev&#39; config entry<br>
=C2=A0 libmultipath: use &#39;checkint&#39; as argument for sysfs_set_scsi_=
tmo()<br>
=C2=A0 discovery: Pass in &#39;hwtable&#39; for get_state() and<br>
=C2=A0 =C2=A0 scsi_sysfs_discovery()<br>
=C2=A0 libmultipath: use &#39;struct config&#39; as argument for pathinfo()=
<br>
=C2=A0 checkers: use &#39;multipath_dir&#39; as argument<br>
=C2=A0 prio: use &#39;multipath_dir&#39; as argument<br>
=C2=A0 libmultipath: use &#39;timeout&#39; as argument for getprio()<br>
=C2=A0 libmultipath: use explicit &#39;config&#39; argument for configurati=
on file<br>
=C2=A0 =C2=A0 parsing<br>
=C2=A0 libmultipath: use (get,put)_multipath_config() accessors<br>
=C2=A0 multipathd: Fixup commandline argument handling<br>
=C2=A0 multipath: make &#39;struct config&#39; a local variable<br>
=C2=A0 multipathd: use userspace RCU to access configuration<br>
=C2=A0 libmultipath: Allocate keywords directly<br>
<br>
=C2=A0libmpathpersist/mpath_persist.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 28 =
+--<br>
=C2=A0libmpathpersist/mpath_persist.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A06 +-<br>
=C2=A0libmultipath/checkers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 22 ++-<br>
=C2=A0libmultipath/checkers.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 =C2=A06 +-<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0|=C2=A0 43 ++---<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0|=C2=A0 18 +-<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | 163 +++++++++++------<br>
=C2=A0libmultipath/configure.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 10 +-<br>
=C2=A0libmultipath/debug.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 =C2=A03 +<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 21 +--<br>
=C2=A0libmultipath/devmapper.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 =C2=A04 +-<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0|=C2=A0 79 ++++----<br>
=C2=A0libmultipath/dict.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | 108 ++++++-----<br>
=C2=A0libmultipath/discovery.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 12 +-<br>
=C2=A0libmultipath/dmparser.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 =C2=A06 +-<br>
=C2=A0libmultipath/dmparser.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/parser.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0|=C2=A0 61 +++----<br>
=C2=A0libmultipath/parser.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0|=C2=A0 27 +--<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 72 ++++----<br>
=C2=A0libmultipath/print.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 16 +-<br>
=C2=A0libmultipath/prio.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0|=C2=A0 40 +++--<br>
=C2=A0libmultipath/prio.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0|=C2=A0 14 +-<br>
=C2=A0libmultipath/prioritizers/alua.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 12 +-<br=
>
=C2=A0libmultipath/prioritizers/alua_rtpg.c |=C2=A0 25 +--<br>
=C2=A0libmultipath/prioritizers/alua_rtpg.h |=C2=A0 =C2=A06 +-<br>
=C2=A0libmultipath/prioritizers/emc.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A08 +-<br>
=C2=A0libmultipath/prioritizers/hds.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A08 +-<br>
=C2=A0libmultipath/prioritizers/hp_sw.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 46 ++---=
<br>
=C2=A0libmultipath/prioritizers/ontap.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 19 +-<br=
>
=C2=A0libmultipath/prioritizers/rdac.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A08 =
+-<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |=C2=A0 99 +++++-----<br>
=C2=A0libmultipath/propsel.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |=C2=A0 48 ++---<br>
=C2=A0libmultipath/structs_vec.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 62 ++++---<br>
=C2=A0libmultipath/structs_vec.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 13 +-<br>
=C2=A0libmultipath/waiter.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0|=C2=A0 =C2=A04 +<br>
=C2=A0libmultipath/wwids.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 22 ++-<br>
=C2=A0mpathpersist/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0|=C2=A0 24 ++-<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 | 199 ++++++++++++---------<br>
=C2=A0multipathd/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|=C2=A0 84 ++++++---<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0| 327 +++++++++++++++++++++++-----------<br>
=C2=A0multipathd/uxlsnr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A05 -<br>
=C2=A043 files changed, 1057 insertions(+), 727 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.6.6<br>
<br>
</font></span></blockquote></div><br></div>

--001a1140d2be5348390537196a72--


--===============5743344458867530591==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5743344458867530591==--
