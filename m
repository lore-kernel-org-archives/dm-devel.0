From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/12] multipath-tools: Coverity patches
Date: Thu, 17 Jan 2019 14:59:12 -0600
Message-ID: <20190117205912.GA11315@octiron.msp.redhat.com>
References: <20190108225409.15977-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190108225409.15977-1-mwilck@suse.com>
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

On Tue, Jan 08, 2019 at 11:53:57PM +0100, Martin Wilck wrote:

Aside from my question on 08/12, ACK for the set

-Ben

> Hi Christophe,
> 
> here are a few simple fixes motivated by a recent
> coverity scan of the latest upstream. Most are false positives,
> but it can't hurt to fix them anyway, be it only to get a quicker
> overview on future scans.
> 
> Unfortunately synopsys messed up the scan.coverity.com website
> before I could finish this work.
> 
> There are two bigger issues with coverity that this set doesn't
> address:
> 
> 1) apparently coverity doesn't understand our frequently
>     used paradigm (simplified):
> 
>     pthread_cleanup_push(pthread_mutex_unlock, &mutex);
>     pthread_mutex_lock(&mutex);
>     do_some_work();
>     pthread_cleanup_pop(1);
> 
>  2) coverity warns that we sleep in multiple places holding the
>     vecs lock. That will be a bit harder to fix.
> 
> Martin
> 
> Martin Wilck (12):
>   kpartx(coverity): fix resource leak warning
>   libmultipath(coverity): cleanup dup usage in execute_program()
>   kpartx(coverity): fix apparent out-of-bounds access
>   libmultipath(coverity): make sure readlink result is 0-terminated
>   libmultipath(coverity): fix apparent overflow
>   libmpathcmd(coverity): limit reply length
>   libmultipath(coverity): fix int overflow in sysfs_set_scsi_tmo
>   libmultipath(coverity): fix "enum misuse" for find_multipaths
>   multipathd(coverity): check retval clock_gettime()
>   libmpathpersist(coverity): range checking for PRIN length
>   libmultipath/foreign(coverity): retval check in snprint_nvme_path
>   libmultipath(coverity): fix possible NULL dereference
> 
>  kpartx/dasd.c                    |  7 +++----
>  libmpathcmd/mpath_cmd.c          |  4 ++++
>  libmpathcmd/mpath_cmd.h          |  6 ++++++
>  libmpathpersist/mpath_pr_ioctl.c | 10 +++++++---
>  libmultipath/callout.c           | 13 +++++++------
>  libmultipath/configure.c         |  2 +-
>  libmultipath/dict.c              |  2 +-
>  libmultipath/discovery.c         |  4 ++--
>  libmultipath/foreign/nvme.c      |  6 ++++--
>  libmultipath/util.c              |  1 +
>  multipathd/cli.c                 |  2 ++
>  multipathd/cli.h                 |  6 ++++++
>  multipathd/cli_handlers.c        |  1 +
>  multipathd/main.c                |  9 +++++----
>  14 files changed, 50 insertions(+), 23 deletions(-)
> 
> -- 
> 2.19.2
