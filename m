From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/80] multipath-tools series part VI:
 incomplete udev initialization
Date: Mon, 20 Jul 2020 16:20:47 -0500
Message-ID: <20200720212047.GH11089@octiron.msp.redhat.com>
References: <20200709110330.9917-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709110330.9917-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 09, 2020 at 01:03:24PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> This is part VI of a larger patch series for multipath-tools I've been preparing.
> It's based on the previously submitted part V.
> 
> The full series will also be available here:
> https://github.com/mwilck/multipath-tools/tree/ups/submit-2007
> 
> There are tags in that repo for each part of the series.
> This part is tagged "submit-200709-6".

for the part
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
 
> The series handles an issue observed in certain partner installations, where
> DM devices were incompletely initialized by udev - during initrd procesing,
> the "add" event had been processed, but the subsequent "change" event had not,
> because udevd had been killed before getting around to handle them.
> 
> My first attempt to fix this was based on udev rules ("11-dm-mpath.rules: Fix
> udev rule processing during coldplug"), but this patch was wrong. We have to
> add logic in multipathd itself. The most important patch in the series that
> fixed the actual customer problem is patch 76. Patch 75 was supposed to handle
> a slightly different incarnation of the same problem, which so far hasn't been
> actually observed. But I think having this patch "just in case" doesn't hurt,
> either.
> 
> Patch 78 and 79 rename "update_path_groups()", which over time has grown
> to be the main entry point for reloading maps.
> 
> Patch 80 fixes an issue which I observed while testing the first 3 patches.
> 
> Regards,
> Martin
> 
> Martin Wilck (6):
>   multipathd: uev_trigger(): handle incomplete ADD events
>   libmultipath: select_action(): force udev reload for uninitialized
>     maps
>   libmultipath: log dm_task_run() errors
>   libmultipath: move reload_map() to multipathd
>   multipathd: rename update_path_groups() -> reload_and_sync_map()
>   libmultipath: select_action(): don't drop map if alias clashes
> 
>  libmultipath/configure.c  | 112 +++++++++++++++-----------------------
>  libmultipath/configure.h  |   3 +-
>  libmultipath/devmapper.c  |  61 +++++++++++++++++----
>  libmultipath/devmapper.h  |   4 ++
>  multipathd/cli_handlers.c |   8 +--
>  multipathd/dmevents.c     |   4 +-
>  multipathd/main.c         |  71 ++++++++++++++++++++++--
>  multipathd/main.h         |   4 +-
>  multipathd/waiter.c       |   2 +
>  9 files changed, 178 insertions(+), 91 deletions(-)
> 
> -- 
> 2.26.2
