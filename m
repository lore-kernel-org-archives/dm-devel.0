From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/19] san_path_err & multipath ANA support
Date: Fri, 21 Dec 2018 10:06:40 -0600
Message-ID: <20181221160640.GI11315@octiron.msp.redhat.com>
References: <20181218231931.10762-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181218231931.10762-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Dec 19, 2018 at 12:19:12AM +0100, Martin Wilck wrote:
> Hi Christophe,
> 
> this series consists of 3 parts. The first part improves the documentation on
> the current approaches to "shaky" or "marginal" path detection, and
> re-introduces the previously removed "san_path_err_xy" approach, which has
> been prematurely removed IMO. At the time, I thought that it was superseded by
> the "marginal path" algorithm, but I have my issues with latter (hopefully
> subject of a follow-up series), and I believe the "medium" complexity of the
> san_path_err code actually has its merits. But to be honest, my strongest
> reason to re-add it is that I have to continue to support it in SLES for some
> time to come.

I've been thinking about how we handle marginal paths, and it seems to
me that instead of telling the kernel that they have failed, it might be
better to create pathgroups of last resort, which contains marginal
paths that should only be used if all the other paths are down.

The downsides to this method are that it is quite possible that it could
double the number of pathgroups whenever you have connection issues,
since a connection issue near the host HBA could cause a marginal path
in each pathgroup. This means more reloading tables, and more confusing
layouts.

The upside to this method is that multipath won't run out of paths while
their are still marginal paths that it could use. When queuing isn't
enabled, there's nothing to stop the kernel from failing IO while
potentially usable marginal paths exist.

On the other hand, this problem could be mitigated by having multipath
work such that, when marginal path detection is configured, it always
makes sure that no_path_retry is at least some minimum value that we
believe is long enough for multipathd to be notified of the path failure
by the kernel and to reinstate the marginal paths.

Any thoughts?

-Ben
 
> The second part accumulates a few bug fixes.
> 
> The third part introduces NVMe ANA support to multipath-tools, based on the
> original patch from Li Jie of Huawei (#14). Instead of copy/pasting some code
> from nvme-cli, as Li Jie did, I decided to copy some nvme-cli code unmodified
> to our repo, and create a small wrapper around it.  I took care not increase
> the generated binaries with code we don't need. I added detect_prio on top of
> it, and also added ANA support for the "foreign" code for native NVMe
> multipath. BTW: Instead of applying patch #12, it would probably be possible
> to simply add https://github.com/linux-nvme/nvme-cli as a submodule to multipath-
> tools. I haven't tried that yet.
> 
> One thing to note: in dm-multipath mode, multipathd can now read the ANA
> properties and derive prio values. But it can't react on updates from the
> storage so far, because the kernel doesn't generate events to user space
> if this happens. I haven't decided how to tackle this problem yet. Hints
> and comments are welcome.
> 
> Cheers,
> Martin
> 
> Kyle Mahlkuch (1):
>   libmultipath: Increase SERIAL_SIZE to 128 bytes
> 
> lijie (1):
>   multipath-tools: add ANA support for NVMe device
> 
> Martin Wilck (17):
>   multipath.conf.5: explain "shaky" path detection
>   libmultipath: propsel: don't print undefined values
>   Revert "multipath-tools: discard san_path_err_XXX feature"
>   multipathd: marginal_path overrides san_path_err
>   multipath.conf.5: man page fixes for san_path_err_xy
>   setup_map: wait for pending path checkers to finish
>   libmultipath: add ARRAY_SIZE helper
>   libmultipath: make close_fd() a common helper
>   libmultipath: restore PG prio in update_multipath_strings
>   multipathd: don't check foreign paths every tick
>   libmultipath: add files from nvme-cli for NVMe support
>   libmultipath: add wrapper library for nvme ioctls
>   libmultipath: ANA prioritzer: use nvme wrapper library
>   libmultipath: detect_prio: try ANA for NVMe
>   libmultipath/foreign/nvme: use failover topology
>   libmultipath/foreign/nvme: show ANA state
>   libmultipath/foreign/nvme: indicate ANA support
> 
>  libmultipath/Makefile              |   18 +-
>  libmultipath/config.c              |    3 +
>  libmultipath/config.h              |    9 +
>  libmultipath/configure.c           |   86 +-
>  libmultipath/dict.c                |   39 +
>  libmultipath/foreign/Makefile      |    2 +-
>  libmultipath/foreign/nvme.c        |  180 +++-
>  libmultipath/nvme-lib.c            |   49 +
>  libmultipath/nvme-lib.h            |   39 +
>  libmultipath/nvme/argconfig.h      |   99 ++
>  libmultipath/nvme/json.h           |   87 ++
>  libmultipath/nvme/linux/nvme.h     | 1450 ++++++++++++++++++++++++++++
>  libmultipath/nvme/nvme-ioctl.c     |  869 +++++++++++++++++
>  libmultipath/nvme/nvme-ioctl.h     |  139 +++
>  libmultipath/nvme/nvme.h           |  163 ++++
>  libmultipath/nvme/plugin.h         |   36 +
>  libmultipath/prio.h                |    1 +
>  libmultipath/prioritizers/Makefile |    5 +
>  libmultipath/prioritizers/ana.c    |  201 ++++
>  libmultipath/prioritizers/ana.h    |  221 +++++
>  libmultipath/propsel.c             |  151 ++-
>  libmultipath/propsel.h             |    3 +
>  libmultipath/structs.h             |   30 +-
>  libmultipath/structs_vec.c         |    8 +
>  libmultipath/sysfs.c               |    5 -
>  libmultipath/util.c                |    5 +
>  libmultipath/util.h                |    3 +
>  multipath/main.c                   |    4 -
>  multipath/multipath.conf.5         |  141 ++-
>  multipathd/main.c                  |  105 +-
>  tests/hwtable.c                    |    2 +-
>  31 files changed, 4051 insertions(+), 102 deletions(-)
>  create mode 100644 libmultipath/nvme-lib.c
>  create mode 100644 libmultipath/nvme-lib.h
>  create mode 100644 libmultipath/nvme/argconfig.h
>  create mode 100644 libmultipath/nvme/json.h
>  create mode 100644 libmultipath/nvme/linux/nvme.h
>  create mode 100644 libmultipath/nvme/nvme-ioctl.c
>  create mode 100644 libmultipath/nvme/nvme-ioctl.h
>  create mode 100644 libmultipath/nvme/nvme.h
>  create mode 100644 libmultipath/nvme/plugin.h
>  create mode 100644 libmultipath/prioritizers/ana.c
>  create mode 100644 libmultipath/prioritizers/ana.h
> 
> -- 
> 2.19.2
