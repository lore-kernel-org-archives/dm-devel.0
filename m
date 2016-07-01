From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 00/26] Userspace-RCU for config accesses
Date: Fri, 1 Jul 2016 15:44:00 -0500
Message-ID: <20160701204400.GZ8095@octiron.msp.redhat.com>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Mon, Jun 20, 2016 at 10:08:47AM +0200, Hannes Reinecke wrote:
> Hi all,

ACK on all patches besides 2 and 17 (which I've commented on).

-Ben

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
> The patchset can be found at
> 
> github.com:/hreinecke/multipath-tools.git
> branch rcu
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
>  libmultipath/discovery.c              | 121 +++++++------
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
>  multipathd/main.c                     | 327 +++++++++++++++++++++++-----------
>  multipathd/uxlsnr.c                   |   5 -
>  43 files changed, 1063 insertions(+), 734 deletions(-)
> 
> -- 
> 2.6.6
