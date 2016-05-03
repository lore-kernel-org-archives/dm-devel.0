From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 00/57] SLES resync
Date: Tue, 3 May 2016 09:23:01 +0200
Message-ID: <CABr-GncfN95vE3fdv4VRxVuAdkh_wJg+5BpRAETjkE=Wdkk27w@mail.gmail.com>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4558761957159100716=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

--===============4558761957159100716==
Content-Type: multipart/alternative; boundary=001a113ec3feaf60cd0531eafad0

--001a113ec3feaf60cd0531eafad0
Content-Type: text/plain; charset=UTF-8

Here is the patchset merged so far.

e0c1b55e171373d9efbde43502a9c87fdb53f0ef Allow specific CLI commands to run
unlocked
5ed6122c0e5d8326bc0f3beaf1f5de7303986952 multipathd: push down lock in
checkerloop()
5aca183c68f7ada6fd38c866e235abc690e24328 multipathd: asynchronous
configuration
996b564931e92b5864a3e740b6b5198d69be17da multipathd: Increase uxclnt timeout
c50c729f6c72df0c164e42bde1cc94114c6c06ea multipathd: implement 'show map
$map format $fmt'
c263e76be2f83bfb94f8aecd47a3e345c2d79fc6 libmultipath: make 'dm_addmap'
static
2c9c69956431f07942c4ca71d9f1d779982d62ac multipathd: Provide standard error
description on cli failure
5007e197c55d8a287ac5ec84c1f13aef7a7a08db multipathd: strict loop timings
c0db476f2b0d92b3ab4ea5007242122fdbb103dc dmparser: Use find_path_by_dev()
18f1b0341f321f9326e08b940b3c1eed4a31d779 libmultipath: sanity check on
store_path()
3ede290fd5267176860212483f9eaad48a5e5ca8 libmultipath: ensure 'dev_t' is
set when store paths
1be502f61f92b93ab8eb1c3d84e2c19423408787 libmultipath: remove 'get_info'
argument for adopt_paths()
d87f3055b465743d00d6cae3f4d53c4cc171f2ab multipathd: Do not switch paths on
empty multipath tables
c6db07310a4c63b65a758892de187837bb381572 multipathd: set uxsock_timeout
after reconfiguration
a5b3c5561fd5300046d72f7ce4b414e8acce8547 Use multipath wwid if path wwid is
empty
0c833dd35e98da8e6a58c8a50ae6a08cd0e07e20 multipathd: accept zero-size paths
in ev_add_path()
26c4bb0f89ba9bb15e6f1873799a762e6e5078a7 Always set
DM_UDEV_DISABLE_LIBRARY_FALLBACK
a632ef41d98b4369e105ab630ffa2679a98014d3 libmultipath: remove 'use_uuid'
argument from dm_addmap()
74cbb841cec6273243d3949b277adb2430a9d6aa libmultipath: remove 'needsync'
argument from dm_simplecmd_noflush
6e14b7b54de497405878ad92c60813bf14cd4fd8 multipathd: improve uxlsnr
42539b051468bd442f5f0365b178cd9530da12f3 multipathd: skip uninitialized
devices during reconfiguration
10bd53368193cc009bdf6e52f9f01fb9ced98045 Only filter for udev property if
uid_attribute is present
5ec07b3af8d1c3a6c7ba1680af20b80ddce4f962 libmultipath: use a shared lock to
co-operate with udev
cc37c9941a2e343b0bf58c8dfef28dab3634be6f Ensure multipathd is started
before systemd-udev-trigger.service
286749f8ba07e198ad314f0d6a4d1afe4ecd7332 11-dm-mpath.rules: Only import
ID_FS_XXX variables if not set
85398f6c8f91e8e4d1a2d0fad0d603aa5521ec26 Load all device handler modules on
startup
2ccc1a70f294e9d143b78864a943e419d93a7ea0 Add dependency on
systemd-udevd.service
3f05ebe105464ed520397d5dd8b5448338111f5e libmultipath: avoid double
semicolon in lock.h
505227acb951dc0ad063d2322036cd894b9556ab multipathd: Do not print
misleading message 'not found in pathvec'
4cdbd2990f42431b9c19866e62d2ddd723697487 libmpathpersist: Fixup whitespaces
in Makefile
cb7e5658c2626b9db70528255d419d8a6ba89601 libmultipath: additional logging
messages when formatting callout
79f88dd35ab1be62f7e7d33c281a477e5346c2c3 libmultipath: call get_uid() for
all paths
6903495e748d938d8c109bd3b9e4ad6ba4004049 libmultipath: correctly display
checker status
b4d9ca8dc8bbfbd3782bf4cf2cb1a440685ccd07 libmultipath: correctly initialize
pp->sg_id
d291112dd24fe4eff70dfd50ca817146fc100936 multipathd: print error message
for invalid arguments
42f490c62b066235693a1176204fa1712456fd4d multipathd: fixup a crash when
invoking CLI commands
2516c4f1dd5c85799fff3d5c7cb5de54dece88ba multipathd: fixup queueing mode in
'show maps status'
ccf6e5316a7cd090bfa2ba4c542859f55e20c8d9 libmultipath: finally fix
dev_loss_tmo setting
8af1770fcdd9ebbd6bcb29baa49f6d0de1b1b700 libmultipath: Do not use 'sscanf'
for parsing integers
b4e1b5242355908fcb1bd461efb2851a0b41dba7 Allow for empty SCSI revision
6fe55f63b5a95eb9d4da5e32115e1629784619af Add LIO-ORG/SUSE RBD backend
hardware defaults
21136f36a38ce761a76797a2434c4fbbcbc89830 Add HP MSA 2040 to the hardware
table
c416b69808e5bc80bfb4788e3d5309c6d5b4b5b5 kpartx: Install rules file with
correct prefix
adfc5ad9713ba58d44e2d50ed8725f6a72127239 kpartx: parse emulated DASD devices
0d83956858a946817cd09b818d70de010f7bdd76 kpartx: handle more than 256 loop
devices
08cc0ccd943b35c0aaedac44632dc8056f451f41 kpartx: Fixup persistent name
generation

4628ca72bf953a26bc3580daa61e06ec1fbf4fa1 multipath: remove warning 'failed
to get wwid'
is replaced with:
01b0f396797f008b63fc244aee2b7c79e9a0f41e multipath: move the warning
'failed to get wwid' to lvl4 verbosity

Thanks.
Christophe

On Wed, Apr 27, 2016 at 1:10 PM, Hannes Reinecke <hare@suse.de> wrote:

> Hi all,
>
> as promised several times, here's now a patchset with all the patches
> queued up in my SLES repository.
>
> The first bits are pretty much uncontroversial (I hope), mainly fixes
> etc. Next there are some systemd updates, setting dependencies and such.
>
> The _really_ important patch is
>
> multipathd: skip uninitialized devices during reconfiguration
>
> which basically is the cause for all the missing wwid issues we've seen.
> So I wonder if we shouldn't just do away with all the tweaks we've
> accumlated so far and see if that patch isn't sufficient.
> According to Kay Sievers it should...
>
> Next is a general overhaul of the 'cookie' mechanism; Ben, Mike,
> mind to have a look here? It _seems_ reasonable enough, but it would
> be nice to have additional confirmation for that.
>
> Finally there are patches which probably require some more discussion:
> - Asynchronous configuration: Do not call 'reconfigure' directly, but
>   rather set the daemon_status to 'configuration' and defer the actual
>   work to the main thread. This allows us to decouple it from the CLI
>   call, and we won't run into any udev/systemd timeout issues when
>   booting on large installations
> - Lock pushdown: I remember to have sent this patch already at one
>   point, but it got rejected. So I try again :-)
>   With this patch the big vector lock is pushed down to the areas
>   where we actually need it, making the entire system running far
>   smoother during booting or failover in large instances.
>   We have been using this patch since SLE12 GA, ie for over two
>   years now. And seem to have ironed out all issues with it.
>
> The entire patchset can be found at:
>
> github.com:/hreinecke/multipath-tools.git
> branch sles-resync
>
> As usual, comments and reviews are welcome.
> Patches are based upon the latest git, including Bens patchset.
>
> Hannes Reinecke (57):
>   kpartx: Fixup persistent name generation
>   kpartx: handle more than 256 loop devices
>   kpartx: parse emulated DASD devices
>   kpartx: Install rules file with correct prefix
>   Add HP MSA 2040 to the hardware table
>   Use ALUA for HP 3PAR
>   Add LIO-ORG/SUSE RBD backend hardware defaults
>   Allow for empty SCSI revision
>   libmultipath: Do not use 'sscanf' for parsing integers
>   libmultipath: finally fix dev_loss_tmo setting
>   multipathd: fixup queueing mode in 'show maps status'
>   multipathd: fixup a crash when invoking CLI commands
>   multipathd: print error message for invalid arguments
>   libmultipath: correctly initialize pp->sg_id
>   libmultipath: correctly display checker status
>   libmultipath: call get_uid() for all paths
>   libmultipath: additional logging messages when formatting callout
>   libmpathpersist: Fixup whitespaces in Makefile
>   multipathd: Do not print misleading message 'not found in pathvec'
>   multipathd: Do not update the paths vec when removing paths
>   libmultipath: avoid double semicolon in lock.h
>   multipath: use option '-i' when called from udev
>   multipath: remove warning 'failed to get wwid'
>   Add dependency on systemd-udevd.service
>   Load all device handler modules on startup
>   11-dm-mpath.rules: Only import ID_FS_XXX variables if not set
>   Ensure multipathd is started before systemd-udev-trigger.service
>   libmultipath: use a shared lock to co-operate with udev
>   Only filter for udev property if uid_attribute is present
>   multipathd: skip uninitialized devices during reconfiguration
>   multipathd: improve uxlsnr
>   libmultipath: remove 'needsync' argument from dm_simplecmd_noflush
>   libmultipath: remove 'use_uuid' argument from dm_addmap()
>   Always set DM_UDEV_DISABLE_LIBRARY_FALLBACK
>   libmultipath: pass in cookie as argument for dm_simplecmd()
>   libmultipath: pass in 'cookie' as argument for dm_addmap()
>   Remove 'udev_sync' argument from dm_simplecmd()
>   libmultipath: Fixup 'DM_DEVICE_RELOAD' handling
>   devmapper: do not flush I/O for DM_DEVICE_CREATE
>   libmultipath: fixup dm_rename to complete cookie on failure
>   multipathd: accept zero-size paths in ev_add_path()
>   Use multipath wwid if path wwid is empty
>   multipathd: set uxsock_timeout after reconfiguration
>   multipathd: Do not switch paths on empty multipath tables
>   libmultipath: remove 'get_info' argument for adopt_paths()
>   libmultipath: ensure 'dev_t' is set when store paths
>   libmultipath: sanity check on store_path()
>   dmparser: Use find_path_by_dev()
>   multipathd: do not flush maps on startup
>   multipathd: strict loop timings
>   multipathd: Provide standard error description on cli failure
>   libmultipath: make 'dm_addmap' static
>   multipathd: implement 'show map $map format $fmt'
>   multipathd: Increase uxclnt timeout
>   multipathd: asynchronous configuration
>   multipathd: push down lock in checkerloop()
>   Allow specific CLI commands to run unlocked
>
>  kpartx/Makefile               |   6 +-
>  kpartx/dasd.c                 |  39 +++-
>  kpartx/dasd.h                 |   1 +
>  kpartx/kpartx.rules           |  11 +-
>  kpartx/kpartx_id              |  11 +-
>  kpartx/lopart.c               | 106 +++++----
>  libmpathpersist/Makefile      |   4 +-
>  libmultipath/callout.c        |   6 +-
>  libmultipath/config.h         |   1 +
>  libmultipath/configure.c      |  33 ++-
>  libmultipath/defaults.h       |   1 +
>  libmultipath/devmapper.c      | 114 ++++++----
>  libmultipath/devmapper.h      |   4 +-
>  libmultipath/dict.c           |   4 +
>  libmultipath/discovery.c      | 115 +++++-----
>  libmultipath/dmparser.c       |  20 +-
>  libmultipath/hwtable.c        |  41 +++-
>  libmultipath/lock.h           |   4 +-
>  libmultipath/print.c          |   6 +-
>  libmultipath/structs.c        |  17 +-
>  libmultipath/structs_vec.c    |  10 +-
>  libmultipath/structs_vec.h    |   2 +-
>  libmultipath/uevent.c         |  10 +-
>  multipath/11-dm-mpath.rules   |  10 +-
>  multipath/main.c              |   1 -
>  multipath/multipath.conf.5    |  16 +-
>  multipath/multipath.rules     |   2 +-
>  multipathd/cli.c              | 101 +++++++--
>  multipathd/cli.h              |   4 +-
>  multipathd/cli_handlers.c     |  85 +++++++-
>  multipathd/cli_handlers.h     |   2 +
>  multipathd/main.c             | 486
> +++++++++++++++++++++++++++++-------------
>  multipathd/main.h             |   3 +
>  multipathd/multipathd.service |   6 +-
>  multipathd/uxlsnr.c           |  97 +++++----
>  35 files changed, 923 insertions(+), 456 deletions(-)
>
> --
> 2.6.6
>
>

--001a113ec3feaf60cd0531eafad0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Here is the patchset merged so far.<div><br></div><div><di=
v>e0c1b55e171373d9efbde43502a9c87fdb53f0ef Allow specific CLI commands to r=
un unlocked</div><div>5ed6122c0e5d8326bc0f3beaf1f5de7303986952 multipathd: =
push down lock in checkerloop()</div><div>5aca183c68f7ada6fd38c866e235abc69=
0e24328 multipathd: asynchronous configuration</div><div>996b564931e92b5864=
a3e740b6b5198d69be17da multipathd: Increase uxclnt timeout</div><div>c50c72=
9f6c72df0c164e42bde1cc94114c6c06ea multipathd: implement &#39;show map $map=
 format $fmt&#39;</div><div>c263e76be2f83bfb94f8aecd47a3e345c2d79fc6 libmul=
tipath: make &#39;dm_addmap&#39; static</div><div>2c9c69956431f07942c4ca71d=
9f1d779982d62ac multipathd: Provide standard error description on cli failu=
re</div><div>5007e197c55d8a287ac5ec84c1f13aef7a7a08db multipathd: strict lo=
op timings</div><div>c0db476f2b0d92b3ab4ea5007242122fdbb103dc dmparser: Use=
 find_path_by_dev()</div><div>18f1b0341f321f9326e08b940b3c1eed4a31d779 libm=
ultipath: sanity check on store_path()</div><div>3ede290fd5267176860212483f=
9eaad48a5e5ca8 libmultipath: ensure &#39;dev_t&#39; is set when store paths=
</div><div>1be502f61f92b93ab8eb1c3d84e2c19423408787 libmultipath: remove &#=
39;get_info&#39; argument for adopt_paths()</div><div>d87f3055b465743d00d6c=
ae3f4d53c4cc171f2ab multipathd: Do not switch paths on empty multipath tabl=
es</div><div>c6db07310a4c63b65a758892de187837bb381572 multipathd: set uxsoc=
k_timeout after reconfiguration</div><div>a5b3c5561fd5300046d72f7ce4b414e8a=
cce8547 Use multipath wwid if path wwid is empty</div><div>0c833dd35e98da8e=
6a58c8a50ae6a08cd0e07e20 multipathd: accept zero-size paths in ev_add_path(=
)</div><div>26c4bb0f89ba9bb15e6f1873799a762e6e5078a7 Always set DM_UDEV_DIS=
ABLE_LIBRARY_FALLBACK</div><div>a632ef41d98b4369e105ab630ffa2679a98014d3 li=
bmultipath: remove &#39;use_uuid&#39; argument from dm_addmap()</div><div>7=
4cbb841cec6273243d3949b277adb2430a9d6aa libmultipath: remove &#39;needsync&=
#39; argument from dm_simplecmd_noflush</div><div>6e14b7b54de497405878ad92c=
60813bf14cd4fd8 multipathd: improve uxlsnr</div><div>42539b051468bd442f5f03=
65b178cd9530da12f3 multipathd: skip uninitialized devices during reconfigur=
ation</div><div>10bd53368193cc009bdf6e52f9f01fb9ced98045 Only filter for ud=
ev property if uid_attribute is present</div><div>5ec07b3af8d1c3a6c7ba1680a=
f20b80ddce4f962 libmultipath: use a shared lock to co-operate with udev</di=
v><div>cc37c9941a2e343b0bf58c8dfef28dab3634be6f Ensure multipathd is starte=
d before systemd-udev-trigger.service</div><div>286749f8ba07e198ad314f0d6a4=
d1afe4ecd7332 11-dm-mpath.rules: Only import ID_FS_XXX variables if not set=
</div><div>85398f6c8f91e8e4d1a2d0fad0d603aa5521ec26 Load all device handler=
 modules on startup</div><div>2ccc1a70f294e9d143b78864a943e419d93a7ea0 Add =
dependency on systemd-udevd.service</div><div>3f05ebe105464ed520397d5dd8b54=
48338111f5e libmultipath: avoid double semicolon in lock.h<br></div><div>50=
5227acb951dc0ad063d2322036cd894b9556ab multipathd: Do not print misleading =
message &#39;not found in pathvec&#39;</div><div>4cdbd2990f42431b9c19866e62=
d2ddd723697487 libmpathpersist: Fixup whitespaces in Makefile</div><div>cb7=
e5658c2626b9db70528255d419d8a6ba89601 libmultipath: additional logging mess=
ages when formatting callout</div><div>79f88dd35ab1be62f7e7d33c281a477e5346=
c2c3 libmultipath: call get_uid() for all paths</div><div>6903495e748d938d8=
c109bd3b9e4ad6ba4004049 libmultipath: correctly display checker status</div=
><div>b4d9ca8dc8bbfbd3782bf4cf2cb1a440685ccd07 libmultipath: correctly init=
ialize pp-&gt;sg_id</div><div>d291112dd24fe4eff70dfd50ca817146fc100936 mult=
ipathd: print error message for invalid arguments</div><div>42f490c62b06623=
5693a1176204fa1712456fd4d multipathd: fixup a crash when invoking CLI comma=
nds</div><div>2516c4f1dd5c85799fff3d5c7cb5de54dece88ba multipathd: fixup qu=
eueing mode in &#39;show maps status&#39;</div><div>ccf6e5316a7cd090bfa2ba4=
c542859f55e20c8d9 libmultipath: finally fix dev_loss_tmo setting</div><div>=
8af1770fcdd9ebbd6bcb29baa49f6d0de1b1b700 libmultipath: Do not use &#39;ssca=
nf&#39; for parsing integers</div><div>b4e1b5242355908fcb1bd461efb2851a0b41=
dba7 Allow for empty SCSI revision</div><div>6fe55f63b5a95eb9d4da5e32115e16=
29784619af Add LIO-ORG/SUSE RBD backend hardware defaults</div><div>21136f3=
6a38ce761a76797a2434c4fbbcbc89830 Add HP MSA 2040 to the hardware table</di=
v><div>c416b69808e5bc80bfb4788e3d5309c6d5b4b5b5 kpartx: Install rules file =
with correct prefix</div><div>adfc5ad9713ba58d44e2d50ed8725f6a72127239 kpar=
tx: parse emulated DASD devices</div><div>0d83956858a946817cd09b818d70de010=
f7bdd76 kpartx: handle more than 256 loop devices</div><div>08cc0ccd943b35c=
0aaedac44632dc8056f451f41 kpartx: Fixup persistent name generation</div></d=
iv><div><br></div><div><div>4628ca72bf953a26bc3580daa61e06ec1fbf4fa1 multip=
ath: remove warning &#39;failed to get wwid&#39;</div><div>is replaced with=
:<br></div><div>01b0f396797f008b63fc244aee2b7c79e9a0f41e multipath: move th=
e warning &#39;failed to get wwid&#39; to lvl4 verbosity</div></div><div><b=
r></div><div>Thanks.</div><div>Christophe</div></div><div class=3D"gmail_ex=
tra"><br><div class=3D"gmail_quote">On Wed, Apr 27, 2016 at 1:10 PM, Hannes=
 Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_=
blank">hare@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
>Hi all,<br>
<br>
as promised several times, here&#39;s now a patchset with all the patches<b=
r>
queued up in my SLES repository.<br>
<br>
The first bits are pretty much uncontroversial (I hope), mainly fixes<br>
etc. Next there are some systemd updates, setting dependencies and such.<br=
>
<br>
The _really_ important patch is<br>
<br>
multipathd: skip uninitialized devices during reconfiguration<br>
<br>
which basically is the cause for all the missing wwid issues we&#39;ve seen=
.<br>
So I wonder if we shouldn&#39;t just do away with all the tweaks we&#39;ve<=
br>
accumlated so far and see if that patch isn&#39;t sufficient.<br>
According to Kay Sievers it should...<br>
<br>
Next is a general overhaul of the &#39;cookie&#39; mechanism; Ben, Mike,<br=
>
mind to have a look here? It _seems_ reasonable enough, but it would<br>
be nice to have additional confirmation for that.<br>
<br>
Finally there are patches which probably require some more discussion:<br>
- Asynchronous configuration: Do not call &#39;reconfigure&#39; directly, b=
ut<br>
=C2=A0 rather set the daemon_status to &#39;configuration&#39; and defer th=
e actual<br>
=C2=A0 work to the main thread. This allows us to decouple it from the CLI<=
br>
=C2=A0 call, and we won&#39;t run into any udev/systemd timeout issues when=
<br>
=C2=A0 booting on large installations<br>
- Lock pushdown: I remember to have sent this patch already at one<br>
=C2=A0 point, but it got rejected. So I try again :-)<br>
=C2=A0 With this patch the big vector lock is pushed down to the areas<br>
=C2=A0 where we actually need it, making the entire system running far<br>
=C2=A0 smoother during booting or failover in large instances.<br>
=C2=A0 We have been using this patch since SLE12 GA, ie for over two<br>
=C2=A0 years now. And seem to have ironed out all issues with it.<br>
<br>
The entire patchset can be found at:<br>
<br>
github.com:/hreinecke/multipath-tools.git<br>
branch sles-resync<br>
<br>
As usual, comments and reviews are welcome.<br>
Patches are based upon the latest git, including Bens patchset.<br>
<br>
Hannes Reinecke (57):<br>
=C2=A0 kpartx: Fixup persistent name generation<br>
=C2=A0 kpartx: handle more than 256 loop devices<br>
=C2=A0 kpartx: parse emulated DASD devices<br>
=C2=A0 kpartx: Install rules file with correct prefix<br>
=C2=A0 Add HP MSA 2040 to the hardware table<br>
=C2=A0 Use ALUA for HP 3PAR<br>
=C2=A0 Add LIO-ORG/SUSE RBD backend hardware defaults<br>
=C2=A0 Allow for empty SCSI revision<br>
=C2=A0 libmultipath: Do not use &#39;sscanf&#39; for parsing integers<br>
=C2=A0 libmultipath: finally fix dev_loss_tmo setting<br>
=C2=A0 multipathd: fixup queueing mode in &#39;show maps status&#39;<br>
=C2=A0 multipathd: fixup a crash when invoking CLI commands<br>
=C2=A0 multipathd: print error message for invalid arguments<br>
=C2=A0 libmultipath: correctly initialize pp-&gt;sg_id<br>
=C2=A0 libmultipath: correctly display checker status<br>
=C2=A0 libmultipath: call get_uid() for all paths<br>
=C2=A0 libmultipath: additional logging messages when formatting callout<br=
>
=C2=A0 libmpathpersist: Fixup whitespaces in Makefile<br>
=C2=A0 multipathd: Do not print misleading message &#39;not found in pathve=
c&#39;<br>
=C2=A0 multipathd: Do not update the paths vec when removing paths<br>
=C2=A0 libmultipath: avoid double semicolon in lock.h<br>
=C2=A0 multipath: use option &#39;-i&#39; when called from udev<br>
=C2=A0 multipath: remove warning &#39;failed to get wwid&#39;<br>
=C2=A0 Add dependency on systemd-udevd.service<br>
=C2=A0 Load all device handler modules on startup<br>
=C2=A0 11-dm-mpath.rules: Only import ID_FS_XXX variables if not set<br>
=C2=A0 Ensure multipathd is started before systemd-udev-trigger.service<br>
=C2=A0 libmultipath: use a shared lock to co-operate with udev<br>
=C2=A0 Only filter for udev property if uid_attribute is present<br>
=C2=A0 multipathd: skip uninitialized devices during reconfiguration<br>
=C2=A0 multipathd: improve uxlsnr<br>
=C2=A0 libmultipath: remove &#39;needsync&#39; argument from dm_simplecmd_n=
oflush<br>
=C2=A0 libmultipath: remove &#39;use_uuid&#39; argument from dm_addmap()<br=
>
=C2=A0 Always set DM_UDEV_DISABLE_LIBRARY_FALLBACK<br>
=C2=A0 libmultipath: pass in cookie as argument for dm_simplecmd()<br>
=C2=A0 libmultipath: pass in &#39;cookie&#39; as argument for dm_addmap()<b=
r>
=C2=A0 Remove &#39;udev_sync&#39; argument from dm_simplecmd()<br>
=C2=A0 libmultipath: Fixup &#39;DM_DEVICE_RELOAD&#39; handling<br>
=C2=A0 devmapper: do not flush I/O for DM_DEVICE_CREATE<br>
=C2=A0 libmultipath: fixup dm_rename to complete cookie on failure<br>
=C2=A0 multipathd: accept zero-size paths in ev_add_path()<br>
=C2=A0 Use multipath wwid if path wwid is empty<br>
=C2=A0 multipathd: set uxsock_timeout after reconfiguration<br>
=C2=A0 multipathd: Do not switch paths on empty multipath tables<br>
=C2=A0 libmultipath: remove &#39;get_info&#39; argument for adopt_paths()<b=
r>
=C2=A0 libmultipath: ensure &#39;dev_t&#39; is set when store paths<br>
=C2=A0 libmultipath: sanity check on store_path()<br>
=C2=A0 dmparser: Use find_path_by_dev()<br>
=C2=A0 multipathd: do not flush maps on startup<br>
=C2=A0 multipathd: strict loop timings<br>
=C2=A0 multipathd: Provide standard error description on cli failure<br>
=C2=A0 libmultipath: make &#39;dm_addmap&#39; static<br>
=C2=A0 multipathd: implement &#39;show map $map format $fmt&#39;<br>
=C2=A0 multipathd: Increase uxclnt timeout<br>
=C2=A0 multipathd: asynchronous configuration<br>
=C2=A0 multipathd: push down lock in checkerloop()<br>
=C2=A0 Allow specific CLI commands to run unlocked<br>
<br>
=C2=A0kpartx/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 =C2=A06 +-<br>
=C2=A0kpartx/dasd.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|=C2=A0 39 +++-<br>
=C2=A0kpartx/dasd.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|=C2=A0 =C2=A01 +<br>
=C2=A0kpartx/kpartx.rules=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 1=
1 +-<br>
=C2=A0kpartx/kpartx_id=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 11 +-<br>
=C2=A0kpartx/lopart.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0| 106 +++++----<br>
=C2=A0libmpathpersist/Makefile=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A04 +-<br>
=C2=A0libmultipath/callout.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A06 +-<=
br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0=
1 +<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 33 ++-<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A01 +<b=
r>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0 =C2=A0 | 114 ++++++----<br>
=C2=A0libmultipath/devmapper.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A04 +-<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =
=C2=A04 +<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 | 115 +++++-----<br>
=C2=A0libmultipath/dmparser.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 20 +-<br>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 41 +++-<br>
=C2=A0libmultipath/lock.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =
=C2=A04 +-<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A0=
6 +-<br>
=C2=A0libmultipath/structs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 17 +-<br>
=C2=A0libmultipath/structs_vec.c=C2=A0 =C2=A0 |=C2=A0 10 +-<br>
=C2=A0libmultipath/structs_vec.h=C2=A0 =C2=A0 |=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/uevent.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 10 +-<=
br>
=C2=A0multipath/11-dm-mpath.rules=C2=A0 =C2=A0|=C2=A0 10 +-<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A01 -<br>
=C2=A0multipath/multipath.conf.5=C2=A0 =C2=A0 |=C2=A0 16 +-<br>
=C2=A0multipath/multipath.rules=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +-<br>
=C2=A0multipathd/cli.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 10=
1 +++++++--<br>
=C2=A0multipathd/cli.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A04 +-<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 85 +++++++-<br>
=C2=A0multipathd/cli_handlers.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 +<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 48=
6 +++++++++++++++++++++++++++++-------------<br>
=C2=A0multipathd/main.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=
=A0 =C2=A03 +<br>
=C2=A0multipathd/multipathd.service |=C2=A0 =C2=A06 +-<br>
=C2=A0multipathd/uxlsnr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 9=
7 +++++----<br>
=C2=A035 files changed, 923 insertions(+), 456 deletions(-)<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
2.6.6<br>
<br>
</font></span></blockquote></div><br></div>

--001a113ec3feaf60cd0531eafad0--


--===============4558761957159100716==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4558761957159100716==--
