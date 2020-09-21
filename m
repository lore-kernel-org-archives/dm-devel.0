From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/19] multipath-tools: shutdown,
 libdevmapper races, globals
Date: Mon, 21 Sep 2020 15:20:13 -0500
Message-ID: <20200921202013.GA11108@octiron.msp.redhat.com>
References: <20200916153718.582-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916153718.582-1-mwilck@suse.com>
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

On Wed, Sep 16, 2020 at 05:36:59PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> this series contains a number of patches I've wanted to do for some
> time. As usual, it's based on my "upstream-queue" tree
> (https://github.com/openSUSE/multipath-tools/tree/upstream-queue).
> 
> Patch 1-8 are related to multipathd shutdown and systemd notifcation.
> Patch 1 and 8 have been part of my earlier series "multipath-tools: 
> Fix remaining shutdown delay issues" from Jan, 2019. But this is so
> long ago that I didn't mark this as a v2. I have tried to address
> Ben's issues with #1 (size_mismatch_seen leak, and premature sd_notify)
> (https://www.redhat.com/archives/dm-devel/2019-January/msg00097.html).
> #8 is just resent, after the recent discussion
> (https://www.redhat.com/archives/dm-devel/2020-August/msg00342.html).
> Ben's remark about sd_notify() drove me to reexamine that feature,
> and actually improve a little by informing systemd of shutdown and
> reconfigure operations.
> 
> Patch 9-11 are an attempt to fix races in libdevmapper, as discussed
> a while ago in the "fix fd leak when iscsi device logs in" thread
> (https://www.redhat.com/archives/dm-devel/2020-July/msg00321.html and
> references).
> 
> Patch 12ff. add definitions of the symbol get_multipath_config(),
> put_multipath_config(), udev, and logsink to libmultipath. This way
> callers won't have to bother with defining these global symbols any
> more in the future (but they still can).

Thanks for doing this. I really like these cleanups. I'll be resending
my libmpathvalid library code on top of this set.

Reviewed-by: Benjamin Marzinski <bmarizns@redhatc.com> 
For all the patches I didn't comment on. 

-Ben

> Regards,
> Martin
> 
> Cc: lixiaokeng@huawei.com
> 
> Martin Wilck (19):
>   multipathd: allow shutdown during configure()
>   multipathd: avoid sending "READY=1" to systemd on early shutdown
>   multipathd: send "STOPPING=1" to systemd on shutdown
>   multipathd: send "RELOADING=1" to systemd on DAEMON_CONFIGURE state
>   multipathd: use volatile qualifier for running_state
>   multipathd: generalize and fix wait_for_state_change_if()
>   multipathd: set_config_state(): avoid code duplication
>   multipathd: cancel threads early during shutdown
>   multipath-tools: don't call dm_lib_release() any more
>   libmultipath: devmapper: refactor libdm version determination
>   libmultipath: protect racy libdevmapper calls with a mutex
>   libmultipath: constify file argument in config parser
>   libmultipath: provide defaults for {get,put}_multipath_config
>   libmpathpersist: allow using libmultipath {get,put}_multipath_config
>   multipath: use {get_put}_multipath_config from libmultipath
>   mpathpersist: use {get,put}_multipath_config() from libmultipath
>   libmultipath: add udev and logsink symbols
>   multipath: remove logsink and udev
>   mpathpersist: remove logsink and udev
> 
>  kpartx/kpartx.c                 |   1 -
>  libmpathpersist/mpath_persist.c |  43 +++++-
>  libmpathpersist/mpath_persist.h |  28 ++++
>  libmultipath/config.c           |  95 +++++++++++--
>  libmultipath/config.h           |  28 +++-
>  libmultipath/configure.c        |   6 +
>  libmultipath/debug.c            |   2 +
>  libmultipath/devmapper.c        | 228 +++++++++++++++++++++-----------
>  libmultipath/devmapper.h        |  13 +-
>  libmultipath/discovery.c        |   3 +
>  libmultipath/parser.c           |   9 +-
>  libmultipath/parser.h           |   2 +-
>  libmultipath/propsel.c          |  10 +-
>  libmultipath/util.c             |  10 ++
>  libmultipath/util.h             |   2 +
>  mpathpersist/main.c             |  26 +---
>  multipath/main.c                |  28 +---
>  multipathd/cli_handlers.c       |   2 -
>  multipathd/dmevents.c           |   4 +-
>  multipathd/main.c               | 117 ++++++++--------
>  multipathd/waiter.c             |   2 +-
>  21 files changed, 441 insertions(+), 218 deletions(-)
> 
> -- 
> 2.28.0
