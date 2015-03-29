From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 00/78] SUSE SLES resync
Date: Sun, 29 Mar 2015 18:28:24 +0200
Message-ID: <CABr-Gne1sYtJzKRGPTQJA7QOzFJ-MvD9Y0NphB8chFWsw9VKKA@mail.gmail.com>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6825950298143657024=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
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

--===============6825950298143657024==
Content-Type: multipart/alternative; boundary=001a11c2cd50cb85d205126fdae1

--001a11c2cd50cb85d205126fdae1
Content-Type: text/plain; charset=UTF-8

Hi,

This patchset is merged up to 75734af37267100778468319813cecc050befb1a
: multipathd: push down lock in checkerloop().

Ben,
incidentally the find_multipath patches are in.

Best regards,
Christophe Varoqui


On Mon, Mar 16, 2015 at 1:35 PM, Hannes Reinecke <hare@suse.de> wrote:

> Hi Christophe,
>
> here are the patches which I've queued up during SLES12 development.
> Most of them are (more or less) obvious bugfixes, but there are some
> things which would warrant a deeper review:
> - device-mapper cookie handling: This _really_ is an arcane topic,
>   and I would love to have someone from the device-mapper team
>   to review it. I'm still facing some issues where udev emits
>   a warning 'conflicting device node /dev/mapper/XXX ..', so
>   there might be some issue with it.
> - Asynchronous configuration: On large systems configure() as
>   being called during multipathd startup might exceed the systemd
>   job timeout, resulting in multipathd being killed by systemd.
>   For that I've been implementing an udev retrigger method, which
>   just issues an 'add' event for all available block devices.
> - Related to the above: I've implemented an asynchronous 'reconfigure'
>   CLI call, as for the same reason systemd might kill the multipathd
>   during a 'restart' operation
> - systemd/udev integration: This is _a pain_. It took me months to
>   come up with a working solution. _Especially_ as apparently RH
>   is shipping an '11-dm-multipath.rules' udev ruleset for multipathd,
>   which supposedly should be handling this.
>   It didn't do it for me, though, so I've attached my own version here.
>   The udev integration I've been settling for works like this:
>   - 11-dm-mpath.rules checks if the device is eligible for multipathing
>     For that I've implemented a new option '-u' which looks at the
>     uevent variables _only_.
>   - if a device should be handled by multipathing the 'by-id' and
>     'by-uuid' persistent symlinks are _not_ generated, as this would
>     trigger systemd to start scanning/mounting/lvm activation/whatnot;
>     the 'by-id' and 'by-uuid' symlinks are only generated for the
>     multipath devices themselves.
>   - I've added a new multipath.rules file which should be inserted between
>     55-scsi-sg3_id.rules and 58-scsi_sg3_symlink.rules. This will
>     intercept the SCSI IDENT variables and blank them out if the (block)
>     device is handled by multipathing.
> - sysfs VPD page handling. I've planned to implement this as a direct
>   replacement of the original scsi_id program, but then it turned out
>   that our WWID handling is actually too generic for that: Both getuid
>   and uid_attribute can basically take _any_ value, so it's impossible
>   to tell if the system uses the original (scsi_id compatible) IDs or
>   not. And as the VPD parsing code can only generate scsi_id compatible
>   IDs we might run into compability issues.
>   So it's disabled per default. I'd really would like to clean it up,
>   as I suspect that about 95% of the installations are using scsi_id
>   compatible IDs. But for this to happen we need to clarify/restrict
>   the ID generation mechanism.
>
> As usual, comments and reviews are welcome.
>
> The patchset is based upon the 'find_multipaths' patchset from
> Ben Marzinski; it can be retrieved from
>
> github.com:/hreinecke/multipath-tools.git branch suse-resync
>
> Cheers,
>
> Hannes
>
> Hannes Reinecke (78):
>   libmultipath: remove compilation warning in devmapper.c
>   mpath_persist: Do not call exit() from a shared library
>   libmultipath: filter for missing property in get_refwwid()
>   Double uevent stacksize yet again
>   discovery: do not fail discovery on individual devices
>   libmultipath: Prefer deprecated 'getuid' callout
>   libmultipath: Skip paths with empty wwid
>   Make systemd installation path configurable
>   Add multipath rules for systemd support
>   Fixup multipathd.socket to resolve ordering dependeny
>   Fixup dependencies in multipathd.service
>   multipathd: set correct PID when running in debug mode
>   Do not print empty device strings during discovery
>   kpartx.rules: do not call blkid
>   Use 'SCSI_IDENT_.*' as the default property whitelist
>   Fixup wwid blacklist printing
>   Allow for empty path argument when printing information
>   Disable reassign maps per default
>   multipathd: implement 'list path <path>' cli command
>   Make checker_put() and prio_put() idempotent
>   Remove trailing linefeed from sysfs attributes
>   multipath: implement option '-u' for uevents
>   Install multipath rule under '56-multipath.rules'
>   multipath.rules: Whitelist devices
>   multipath.rules: fixup race condition with systemd
>   11-dm-mpath.rules: Import blkid values if all paths are down
>   kpartx.rules: Skip kpartx for multipath events
>   multipathd: handle DOMAP_RETRY
>   multipathd: cleanup foreground operation
>   Update hwtable for EMC XtremIO
>   multipath: check for running daemon when called with '-u'
>   Revert 'return PATH_DOWN for quiesced paths'
>   Do not treat 'transport-offline' paths as 'offline'
>   Check for valid DM_DEVICE_INFO before proceeding
>   Separate out uevent parsing functions
>   Use poll() when receiving uevents
>   mpath_persist: cleanup
>   kpartx: use standard 'major' and 'minor' macros
>   multipath: Use standard 'major' macro
>   Remove sysfs_get_dev
>   Add paths with a size of '0' as 'ghost' paths
>   Remove last argument from verify_paths()
>   Fixup device-mapper 'cookie' handling
>   multipath: do not print state 'orphan' for option '-l'
>   Return error when receiving CLI packet
>   Implement 'uxsock_timeout' keyword
>   Do not print empty multipaths section
>   multipathd: reload map if reinstate failed
>   multipathd: do not remove paths without uevents
>   Allow zero-sized devices during configuration
>   Rework uev_add_path()
>   multipathd: Issue warning on CLI command timeout
>   Use strlen() when checking for valid wwid
>   multipathd: Use standard lists for CLI handling
>   uxlsnr: use typedef for trigger function
>   multipathd: lock cli client list
>   multipath: enable sync support
>   Remove dm_udev_XXX wrapper functions
>   Revert to ACT_RELOAD in domap if the map exists
>   multipathd: use local variable for watchdog configuration
>   Ignore devices when sysfs_get_tgt_nodename fails
>   Skip USB devices during discovery
>   Read wwid from sysfs vpg_pg83 attribute
>   Assign local priority for NAA VPD descriptor
>   Use sysfs attribute vpd_pg80 to read serial number
>   Update multipath.conf.5 to clarify wwid generation
>   libmultipath: Fall back to SG_IO if no UID could be assigned
>   libmultipath: unset 'uid_attribute' on failure
>   Separate out vpd parsing functions
>   multipathd: use SG_IO as fallback to generate uid
>   Do not automatically fall back to vpd uid generation
>   libmultipath: make vpd page 0x80 optional
>   multipathd: push down lock in checkerloop()
>   Allow specific CLI commands to run unlocked
>   Push down vector lock during uevent processing
>   multipathd: timeout CLI commands when waiting for lock
>   multipathd: asynchronous configuration
>   multipathd: trigger all devices on startup
>
>  Makefile.inc                     |   8 +-
>  kpartx/devmapper.c               |  53 +++-
>  kpartx/devmapper.h               |  11 +-
>  kpartx/kpartx.c                  |  35 +--
>  kpartx/kpartx.rules              |  10 +-
>  libmpathpersist/mpath_persist.c  | 172 ++++++-----
>  libmpathpersist/mpath_updatepr.c |  20 +-
>  libmpathpersist/mpathpr.h        |   3 +-
>  libmultipath/blacklist.c         |   8 +-
>  libmultipath/blacklist.h         |   2 +-
>  libmultipath/checkers.c          |   2 +-
>  libmultipath/config.c            |   2 +
>  libmultipath/config.h            |   8 +-
>  libmultipath/configure.c         |  82 ++++--
>  libmultipath/defaults.h          |   4 +-
>  libmultipath/devmapper.c         |  77 +++--
>  libmultipath/devmapper.h         |   4 +-
>  libmultipath/dict.c              |  33 +++
>  libmultipath/discovery.c         | 613
> ++++++++++++++++++++++++++++++++++-----
>  libmultipath/discovery.h         |   8 +-
>  libmultipath/hwtable.c           |  13 +
>  libmultipath/list.h              |  49 +++-
>  libmultipath/lock.h              |   4 +-
>  libmultipath/log_pthread.c       |   2 +-
>  libmultipath/print.c             |  20 +-
>  libmultipath/prio.c              |   4 +-
>  libmultipath/propsel.c           |   6 +-
>  libmultipath/structs_vec.c       |  29 +-
>  libmultipath/structs_vec.h       |   2 +-
>  libmultipath/sysfs.c             |  53 ++++
>  libmultipath/sysfs.h             |   2 +
>  libmultipath/uevent.c            | 316 ++++++++++++--------
>  libmultipath/uxsock.c            |  32 +-
>  libmultipath/uxsock.h            |   4 +-
>  multipath.conf.defaults          |   2 +-
>  multipath/11-dm-mpath.rules      |   8 +-
>  multipath/Makefile               |   2 +
>  multipath/dev_t.h                |   3 -
>  multipath/main.c                 |  53 +++-
>  multipath/multipath.8            |   6 +-
>  multipath/multipath.conf.5       |  42 ++-
>  multipath/multipath.rules        |  14 +
>  multipathd/cli.c                 |  47 ++-
>  multipathd/cli.h                 |   4 +-
>  multipathd/cli_handlers.c        |  64 +++-
>  multipathd/cli_handlers.h        |   1 +
>  multipathd/main.c                | 400 ++++++++++++++++---------
>  multipathd/main.h                |   2 +
>  multipathd/multipathd.service    |   4 +-
>  multipathd/multipathd.socket     |   8 +-
>  multipathd/uxclnt.c              |  26 +-
>  multipathd/uxclnt.h              |   2 +-
>  multipathd/uxlsnr.c              | 102 +++++--
>  multipathd/uxlsnr.h              |   8 +-
>  54 files changed, 1834 insertions(+), 655 deletions(-)
>  delete mode 100644 multipath/dev_t.h
>  create mode 100644 multipath/multipath.rules
>
> --
> 1.8.4.5
>
>

--001a11c2cd50cb85d205126fdae1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,</div><div><br></div><div>This patchset is merged =
up to=C2=A075734af37267100778468319813cecc050befb1a :=C2=A0multipathd: push=
 down lock in checkerloop().</div><div><br></div><div>Ben,</div><div>incide=
ntally the find_multipath patches are in.</div><div><br></div><div>Best reg=
ards,</div><div>Christophe Varoqui</div><div><br></div></div><div class=3D"=
gmail_extra"><br><div class=3D"gmail_quote">On Mon, Mar 16, 2015 at 1:35 PM=
, Hannes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" tar=
get=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">Hi Christophe,<br>
<br>
here are the patches which I&#39;ve queued up during SLES12 development.<br=
>
Most of them are (more or less) obvious bugfixes, but there are some<br>
things which would warrant a deeper review:<br>
- device-mapper cookie handling: This _really_ is an arcane topic,<br>
=C2=A0 and I would love to have someone from the device-mapper team<br>
=C2=A0 to review it. I&#39;m still facing some issues where udev emits<br>
=C2=A0 a warning &#39;conflicting device node /dev/mapper/XXX ..&#39;, so<b=
r>
=C2=A0 there might be some issue with it.<br>
- Asynchronous configuration: On large systems configure() as<br>
=C2=A0 being called during multipathd startup might exceed the systemd<br>
=C2=A0 job timeout, resulting in multipathd being killed by systemd.<br>
=C2=A0 For that I&#39;ve been implementing an udev retrigger method, which<=
br>
=C2=A0 just issues an &#39;add&#39; event for all available block devices.<=
br>
- Related to the above: I&#39;ve implemented an asynchronous &#39;reconfigu=
re&#39;<br>
=C2=A0 CLI call, as for the same reason systemd might kill the multipathd<b=
r>
=C2=A0 during a &#39;restart&#39; operation<br>
- systemd/udev integration: This is _a pain_. It took me months to<br>
=C2=A0 come up with a working solution. _Especially_ as apparently RH<br>
=C2=A0 is shipping an &#39;11-dm-multipath.rules&#39; udev ruleset for mult=
ipathd,<br>
=C2=A0 which supposedly should be handling this.<br>
=C2=A0 It didn&#39;t do it for me, though, so I&#39;ve attached my own vers=
ion here.<br>
=C2=A0 The udev integration I&#39;ve been settling for works like this:<br>
=C2=A0 - 11-dm-mpath.rules checks if the device is eligible for multipathin=
g<br>
=C2=A0 =C2=A0 For that I&#39;ve implemented a new option &#39;-u&#39; which=
 looks at the<br>
=C2=A0 =C2=A0 uevent variables _only_.<br>
=C2=A0 - if a device should be handled by multipathing the &#39;by-id&#39; =
and<br>
=C2=A0 =C2=A0 &#39;by-uuid&#39; persistent symlinks are _not_ generated, as=
 this would<br>
=C2=A0 =C2=A0 trigger systemd to start scanning/mounting/lvm activation/wha=
tnot;<br>
=C2=A0 =C2=A0 the &#39;by-id&#39; and &#39;by-uuid&#39; symlinks are only g=
enerated for the<br>
=C2=A0 =C2=A0 multipath devices themselves.<br>
=C2=A0 - I&#39;ve added a new multipath.rules file which should be inserted=
 between<br>
=C2=A0 =C2=A0 55-scsi-sg3_id.rules and 58-scsi_sg3_symlink.rules. This will=
<br>
=C2=A0 =C2=A0 intercept the SCSI IDENT variables and blank them out if the =
(block)<br>
=C2=A0 =C2=A0 device is handled by multipathing.<br>
- sysfs VPD page handling. I&#39;ve planned to implement this as a direct<b=
r>
=C2=A0 replacement of the original scsi_id program, but then it turned out<=
br>
=C2=A0 that our WWID handling is actually too generic for that: Both getuid=
<br>
=C2=A0 and uid_attribute can basically take _any_ value, so it&#39;s imposs=
ible<br>
=C2=A0 to tell if the system uses the original (scsi_id compatible) IDs or<=
br>
=C2=A0 not. And as the VPD parsing code can only generate scsi_id compatibl=
e<br>
=C2=A0 IDs we might run into compability issues.<br>
=C2=A0 So it&#39;s disabled per default. I&#39;d really would like to clean=
 it up,<br>
=C2=A0 as I suspect that about 95% of the installations are using scsi_id<b=
r>
=C2=A0 compatible IDs. But for this to happen we need to clarify/restrict<b=
r>
=C2=A0 the ID generation mechanism.<br>
<br>
As usual, comments and reviews are welcome.<br>
<br>
The patchset is based upon the &#39;find_multipaths&#39; patchset from<br>
Ben Marzinski; it can be retrieved from<br>
<br>
github.com:/hreinecke/multipath-tools.git branch suse-resync<br>
<br>
Cheers,<br>
<br>
Hannes<br>
<br>
Hannes Reinecke (78):<br>
=C2=A0 libmultipath: remove compilation warning in devmapper.c<br>
=C2=A0 mpath_persist: Do not call exit() from a shared library<br>
=C2=A0 libmultipath: filter for missing property in get_refwwid()<br>
=C2=A0 Double uevent stacksize yet again<br>
=C2=A0 discovery: do not fail discovery on individual devices<br>
=C2=A0 libmultipath: Prefer deprecated &#39;getuid&#39; callout<br>
=C2=A0 libmultipath: Skip paths with empty wwid<br>
=C2=A0 Make systemd installation path configurable<br>
=C2=A0 Add multipath rules for systemd support<br>
=C2=A0 Fixup multipathd.socket to resolve ordering dependeny<br>
=C2=A0 Fixup dependencies in multipathd.service<br>
=C2=A0 multipathd: set correct PID when running in debug mode<br>
=C2=A0 Do not print empty device strings during discovery<br>
=C2=A0 kpartx.rules: do not call blkid<br>
=C2=A0 Use &#39;SCSI_IDENT_.*&#39; as the default property whitelist<br>
=C2=A0 Fixup wwid blacklist printing<br>
=C2=A0 Allow for empty path argument when printing information<br>
=C2=A0 Disable reassign maps per default<br>
=C2=A0 multipathd: implement &#39;list path &lt;path&gt;&#39; cli command<b=
r>
=C2=A0 Make checker_put() and prio_put() idempotent<br>
=C2=A0 Remove trailing linefeed from sysfs attributes<br>
=C2=A0 multipath: implement option &#39;-u&#39; for uevents<br>
=C2=A0 Install multipath rule under &#39;56-multipath.rules&#39;<br>
=C2=A0 multipath.rules: Whitelist devices<br>
=C2=A0 multipath.rules: fixup race condition with systemd<br>
=C2=A0 11-dm-mpath.rules: Import blkid values if all paths are down<br>
=C2=A0 kpartx.rules: Skip kpartx for multipath events<br>
=C2=A0 multipathd: handle DOMAP_RETRY<br>
=C2=A0 multipathd: cleanup foreground operation<br>
=C2=A0 Update hwtable for EMC XtremIO<br>
=C2=A0 multipath: check for running daemon when called with &#39;-u&#39;<br=
>
=C2=A0 Revert &#39;return PATH_DOWN for quiesced paths&#39;<br>
=C2=A0 Do not treat &#39;transport-offline&#39; paths as &#39;offline&#39;<=
br>
=C2=A0 Check for valid DM_DEVICE_INFO before proceeding<br>
=C2=A0 Separate out uevent parsing functions<br>
=C2=A0 Use poll() when receiving uevents<br>
=C2=A0 mpath_persist: cleanup<br>
=C2=A0 kpartx: use standard &#39;major&#39; and &#39;minor&#39; macros<br>
=C2=A0 multipath: Use standard &#39;major&#39; macro<br>
=C2=A0 Remove sysfs_get_dev<br>
=C2=A0 Add paths with a size of &#39;0&#39; as &#39;ghost&#39; paths<br>
=C2=A0 Remove last argument from verify_paths()<br>
=C2=A0 Fixup device-mapper &#39;cookie&#39; handling<br>
=C2=A0 multipath: do not print state &#39;orphan&#39; for option &#39;-l&#3=
9;<br>
=C2=A0 Return error when receiving CLI packet<br>
=C2=A0 Implement &#39;uxsock_timeout&#39; keyword<br>
=C2=A0 Do not print empty multipaths section<br>
=C2=A0 multipathd: reload map if reinstate failed<br>
=C2=A0 multipathd: do not remove paths without uevents<br>
=C2=A0 Allow zero-sized devices during configuration<br>
=C2=A0 Rework uev_add_path()<br>
=C2=A0 multipathd: Issue warning on CLI command timeout<br>
=C2=A0 Use strlen() when checking for valid wwid<br>
=C2=A0 multipathd: Use standard lists for CLI handling<br>
=C2=A0 uxlsnr: use typedef for trigger function<br>
=C2=A0 multipathd: lock cli client list<br>
=C2=A0 multipath: enable sync support<br>
=C2=A0 Remove dm_udev_XXX wrapper functions<br>
=C2=A0 Revert to ACT_RELOAD in domap if the map exists<br>
=C2=A0 multipathd: use local variable for watchdog configuration<br>
=C2=A0 Ignore devices when sysfs_get_tgt_nodename fails<br>
=C2=A0 Skip USB devices during discovery<br>
=C2=A0 Read wwid from sysfs vpg_pg83 attribute<br>
=C2=A0 Assign local priority for NAA VPD descriptor<br>
=C2=A0 Use sysfs attribute vpd_pg80 to read serial number<br>
=C2=A0 Update multipath.conf.5 to clarify wwid generation<br>
=C2=A0 libmultipath: Fall back to SG_IO if no UID could be assigned<br>
=C2=A0 libmultipath: unset &#39;uid_attribute&#39; on failure<br>
=C2=A0 Separate out vpd parsing functions<br>
=C2=A0 multipathd: use SG_IO as fallback to generate uid<br>
=C2=A0 Do not automatically fall back to vpd uid generation<br>
=C2=A0 libmultipath: make vpd page 0x80 optional<br>
=C2=A0 multipathd: push down lock in checkerloop()<br>
=C2=A0 Allow specific CLI commands to run unlocked<br>
=C2=A0 Push down vector lock during uevent processing<br>
=C2=A0 multipathd: timeout CLI commands when waiting for lock<br>
=C2=A0 multipathd: asynchronous configuration<br>
=C2=A0 multipathd: trigger all devices on startup<br>
<br>
=C2=A0Makefile.inc=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A08 +-<br>
=C2=A0kpartx/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|=C2=A0 53 +++-<br>
=C2=A0kpartx/devmapper.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|=C2=A0 11 +-<br>
=C2=A0kpartx/kpartx.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 |=C2=A0 35 +--<br>
=C2=A0kpartx/kpartx.rules=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 10 +-<br>
=C2=A0libmpathpersist/mpath_persist.c=C2=A0 | 172 ++++++-----<br>
=C2=A0libmpathpersist/mpath_updatepr.c |=C2=A0 20 +-<br>
=C2=A0libmpathpersist/mpathpr.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A03 =
+-<br>
=C2=A0libmultipath/blacklist.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A08 +-<br>
=C2=A0libmultipath/blacklist.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A02 +-<br>
=C2=A0libmultipath/checkers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=
=A02 +-<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A02 +<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A08 +-<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 82 =
++++--<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=
=A04 +-<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 77 =
+++--<br>
=C2=A0libmultipath/devmapper.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A04 +-<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 33 +++<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 613 +++++=
+++++++++++++++++++++++++++++-----<br>
=C2=A0libmultipath/discovery.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=
=A08 +-<br>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=
=A0 13 +<br>
=C2=A0libmultipath/list.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 49 +++-<br>
=C2=A0libmultipath/lock.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 =C2=A04 +-<br>
=C2=A0libmultipath/log_pthread.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 =
+-<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 20 +-<br>
=C2=A0libmultipath/prio.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 =C2=A04 +-<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=
=A0 =C2=A06 +-<br>
=C2=A0libmultipath/structs_vec.c=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 29 +-<br=
>
=C2=A0libmultipath/structs_vec.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A02 =
+-<br>
=C2=A0libmultipath/sysfs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 53 ++++<br>
=C2=A0libmultipath/sysfs.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 =C2=A02 +<br>
=C2=A0libmultipath/uevent.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 316 =
++++++++++++--------<br>
=C2=A0libmultipath/uxsock.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 32 +-<br>
=C2=A0libmultipath/uxsock.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A04 +-<br>
=C2=A0multipath.conf.defaults=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=
=A02 +-<br>
=C2=A0multipath/11-dm-mpath.rules=C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A08 +-<br=
>
=C2=A0multipath/Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0|=C2=A0 =C2=A02 +<br>
=C2=A0multipath/dev_t.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 =C2=A03 -<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 53 +++-<br>
=C2=A0multipath/multipath.8=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A06 +-<br>
=C2=A0multipath/multipath.conf.5=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 42 ++-<b=
r>
=C2=A0multipath/multipath.rules=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 14 +<br>
=C2=A0multipathd/cli.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 47 ++-<br>
=C2=A0multipathd/cli.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 =C2=A04 +-<br>
=C2=A0multipathd/cli_handlers.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 64 +++-<=
br>
=C2=A0multipathd/cli_handlers.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 =C2=A01 =
+<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 | 400 ++++++++++++++++---------<br>
=C2=A0multipathd/main.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 =C2=A02 +<br>
=C2=A0multipathd/multipathd.service=C2=A0 =C2=A0 |=C2=A0 =C2=A04 +-<br>
=C2=A0multipathd/multipathd.socket=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A08 +-<br=
>
=C2=A0multipathd/uxclnt.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 26 +-<br>
=C2=A0multipathd/uxclnt.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 =C2=A02 +-<br>
=C2=A0multipathd/uxlsnr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
 102 +++++--<br>
=C2=A0multipathd/uxlsnr.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=
=C2=A0 =C2=A08 +-<br>
=C2=A054 files changed, 1834 insertions(+), 655 deletions(-)<br>
=C2=A0delete mode 100644 multipath/dev_t.h<br>
=C2=A0create mode 100644 multipath/multipath.rules<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.4.5<br>
<br>
</font></span></blockquote></div><br></div>

--001a11c2cd50cb85d205126fdae1--


--===============6825950298143657024==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6825950298143657024==--
