From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH 00/30] SLES resync, second try
Date: Tue, 16 Jul 2013 22:21:04 +0200
Message-ID: <1374006064.9409.7.camel@lapoo.opensvc.com>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373958801-103613-1-git-send-email-hare@suse.de>
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
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mar., 2013-07-16 at 09:12 +0200, Hannes Reinecke wrote:
> Hi Christophe,
> 
I applied the patchset.

The following patch I had to apply out of order because git am refused
to accept them:

18/30
25/30
28/30

Impressive work implementing udev and devloss_tmo subtelties.

Best regards,
Christophe Varoqui

> here as some patches which accumulated in my SLES repository.
> Most are plain bugfixes, but there are some nasty issues fixed
> with this:
> - The conversion to libudev was a bit overzealous; originally
>   we'd be skipping all devices which don't have a SCSI ID.
>   With libudev we'd be including even those, making multipath
>   claiming even USB flash disks 
>   So I've implemented a new 'property' blacklist which will
>   allow us to blacklist devices based on the udev property.
> - dev_loss_tmo setting continues to be tricky, but this time
>   I think we've got it sorted
> - When using libudev to read attribute variables we'd be getting
>   an automated caching from libudev. Which is nice, unless the
>   data changed in between. So I'd have to go back an roll our
>   own accessors, skipping libudev here.
> - Ripping out 'getuid_callout' rendered all old configuration
>   files still using in unworkable. So I've re-introduced it by
>   marked it 'obsolete'.
> - The confusion regarding directly reading from udev has been
>   cleared up; I've added another patch for reading the 'state'
>   attribute directly, too.
> 
> As usual, comments etc are welcome.
> 
> The patchset can also be pulled from
> git://github.com/hreinecke/multipath-tools.git
> branch sles-resync
> 
> Hannes Reinecke (28):
>   multipath: bind lifetime of udev context to main thread
>   Document 'infinity' as possible value for dev_loss_tmo
>   alua: Do not add preferred path priority for active/optimized
>   multipath: Increase dev_loss_tmo prior to fast_io_fail
>   libmultipath: return PATH_DOWN for quiesced paths
>   libmultipath: Implement PATH_TIMEOUT
>   Deprecate pg_timeout
>   kpartx: create correct symlinks for PATH_FAILED events
>   multipath: Deprecate 'getuid' configuration variable
>   multipath: Add 'Datacore Virtual Disk' to internal hardware table
>   Minor fixes for priority handling
>   Check return value from pathinfo()
>   Read directly from sysfs when checking the device size
>   multipath.conf.annotated: Document rr_min_io_rq
>   Correctly print out 'max' for max_fds
>   Correctly set max_fds in case of failure
>   Update multipath.conf.defaults
>   Correctly set pgfailback
>   multipath.conf.5: clarify 'no_path_retry' default setting
>   multipath.conf.annotated: remove 'udev_dir'
>   multipath: Implement 'property' blacklist
>   Do not print error when rport is blocked
>   multipath: reference the udev context when starting event queue
>   multipathd: valgrind fixes
>   multipathd: increase stacksize for uevent listener
>   Specify checker_timeout in seconds
>   multipath: reset queue_if_no_path if flush failed
>   libmultipath: read path state directly from sysfs
> 
> Petr Uzel (2):
>   kpartx: support disk with non-512B sectors
>   multipath: fix setting of fast_io_fail_tmo
> 
>  kpartx/dos.c                         |  17 +--
>  kpartx/gpt.c                         |  20 +---
>  kpartx/kpartx.c                      |  12 ++
>  kpartx/kpartx.h                      |   8 ++
>  kpartx/kpartx.rules                  |  18 ++-
>  libmpathpersist/mpath_persist.c      |   7 +-
>  libmpathpersist/mpath_persist.h      |   2 +-
>  libmpathpersist/mpath_pr_ioctl.c     |   5 +-
>  libmultipath/Makefile                |   2 +-
>  libmultipath/blacklist.c             | 105 +++++++++++++----
>  libmultipath/blacklist.h             |  19 +--
>  libmultipath/callout.c               | 216 +++++++++++++++++++++++++++++++++++
>  libmultipath/callout.h               |   7 ++
>  libmultipath/checkers.c              |   3 +-
>  libmultipath/checkers.h              |   5 +
>  libmultipath/checkers/emc_clariion.c |   2 +-
>  libmultipath/checkers/hp_sw.c        |   4 +-
>  libmultipath/checkers/libsg.c        |   2 +-
>  libmultipath/checkers/rdac.c         |   4 +-
>  libmultipath/checkers/tur.c          |   4 +-
>  libmultipath/config.c                |  44 +++++--
>  libmultipath/config.h                |  10 +-
>  libmultipath/configure.c             |  25 ++--
>  libmultipath/devmapper.c             |  31 ++---
>  libmultipath/devmapper.h             |   3 +-
>  libmultipath/dict.c                  | 195 +++++++++++++++++--------------
>  libmultipath/discovery.c             | 174 +++++++++++++++++++++-------
>  libmultipath/discovery.h             |   2 +-
>  libmultipath/hwtable.c               |  13 +++
>  libmultipath/print.c                 |  35 ++++++
>  libmultipath/prioritizers/alua.c     |   2 +-
>  libmultipath/propsel.c               |  57 +++------
>  libmultipath/propsel.h               |   1 -
>  libmultipath/structs.h               |   2 +-
>  libmultipath/structs_vec.c           |   2 +-
>  libmultipath/sysfs.c                 |  86 +++++++++++---
>  libmultipath/sysfs.h                 |   2 +
>  libmultipath/uevent.c                |  16 ++-
>  libmultipath/uevent.h                |   4 +-
>  mpathpersist/main.c                  |  11 +-
>  multipath.conf.annotated             |  40 +++++--
>  multipath.conf.defaults              | 112 ++++++++++--------
>  multipath/main.c                     |  27 +++--
>  multipath/multipath.conf.5           |  27 ++++-
>  multipathd/main.c                    |  19 ++-
>  45 files changed, 1009 insertions(+), 393 deletions(-)
>  create mode 100644 libmultipath/callout.c
>  create mode 100644 libmultipath/callout.h
> 
