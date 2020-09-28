From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/23] libmultipath: improve cleanup on exit
Date: Mon, 28 Sep 2020 15:51:02 -0500
Message-ID: <20200928205102.GQ3384@octiron.msp.redhat.com>
References: <20200924134054.14632-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924134054.14632-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 03:40:31PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben, hi lixiaokeng,
> 
> this series was inspired by lixiaokeng's recent posting "[QUESTION] memory
> leak in main (multipath)". It implements my first idea, registering
> cleanup handlers with atexit(). However it turned out to be quite
> complex. In particular multipathd has a lot of things to clean up.
> 
> This series is based on the previous series "multipath-tools: shutdown, 
> libdevmapper races, globals".
> 
> While the bulk of the series is the cleanup handling, it also contains
> some bug fixes for issues that I found while working on this.
> 
> Regards
> Martin
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
For all patches except 1, 7, 14, 18, & 23
> Martin Wilck (23):
>   multipathd: uxlsnr: avoid deadlock on exit
>   multipathd: Fix liburcu memory leak
>   multipathd: move handling of io_err_stat_attr into libmultipath
>   multipathd: move vecs desctruction into cleanup function
>   multipathd: make some globals static
>   multipathd: move threads destruction into separate function
>   multipathd: move conf destruction into separate function
>   multipathd: move pid destruction into separate function
>   multipathd: close pidfile on exit
>   multipathd: add helper for systemd notification at exit
>   multipathd: child(): call cleanups in failure case, too
>   multipathd: unwatch_all_dmevents: check if waiter is initialized
>   multipathd: print error message if config can't be loaded
>   libmultipath: add libmp_dm_exit()
>   multipathd: fixup libdm deinitialization
>   libmultipath: log_thread_stop(): check if logarea is initialized
>   multipathd: add cleanup_child() exit handler
>   libmultipath: fix log_thread startup and teardown
>   multipathd: move cleanup_{prio,checkers,foreign} to libmultipath_exit
>   multipath: use atexit() for cleanup handlers
>   mpathpersist: use atexit() for cleanup handlers
>   multipath: fix leaks in check_path_valid()
>   multipath-tools: mpath-tools.supp: file with valgrind suppressions
> 
>  libmpathpersist/mpath_persist.c       |   2 -
>  libmultipath/config.c                 |   5 +
>  libmultipath/config.h                 |   2 +
>  libmultipath/devmapper.c              |  10 +
>  libmultipath/devmapper.h              |   1 +
>  libmultipath/io_err_stat.c            |   7 +-
>  libmultipath/libmultipath.version     |  26 +--
>  libmultipath/log_pthread.c            |  60 +++--
>  mpathpersist/main.c                   |   5 +-
>  multipath/main.c                      |  94 +++++---
>  multipathd/dmevents.c                 |   2 +
>  multipathd/main.c                     | 305 +++++++++++++++++---------
>  multipathd/uxlsnr.c                   |  17 +-
>  third-party/valgrind/mpath-tools.supp |  33 +++
>  14 files changed, 389 insertions(+), 180 deletions(-)
>  create mode 100644 third-party/valgrind/mpath-tools.supp
> 
> -- 
> 2.28.0
