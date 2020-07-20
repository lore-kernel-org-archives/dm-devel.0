From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 00/74] multipath-tools series part V: removed
 path handling
Date: Mon, 20 Jul 2020 16:19:17 -0500
Message-ID: <20200720211917.GG11089@octiron.msp.redhat.com>
References: <20200709105145.9211-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-1-mwilck@suse.com>
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

On Thu, Jul 09, 2020 at 12:51:24PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> This is part V of a larger patch series for multipath-tools I've been preparing.
> It's based on the previously submitted part IV.
> 
> The full series will also be available here:
> https://github.com/mwilck/multipath-tools/tree/ups/submit-2007
> 
> There are tags in that repo for each part of the series.
> This part is tagged "submit-200709-5".


For the part, with the exception of patches 61,63,64,65,66 & 71
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> The series addresses several issues with missing, unintialized, and removed
> paths. The motivation was that I strongly dislike the side effects of
> disassemble_map(), adding paths and setting WWIDs while parsing map
> parameters. IMO this has always been a layering violation. This patch set adds
> a new function dedicated to handling paths which have not been detected via
> udev but are present as members of dm maps. That makes it much easier to
> track and improve the logic applied when such devices are detected.
> 
> I believe that the new logic will also fix the issue recently reported by
> Chongyun ("libmultipath/dmparser: add missing path with good status when sync
> state with dm kernel"). At least, the approach is very similar, although
> the call to pathinfo() for new devices now happens in update_pathvec_from_dm()
> rather than in disassemble_map().
> 
> The patch set also gets rid of the "is_daemon" argument for disassemble_map(),
> causing semantics in daemon and non-daemon mode. The reason for this parameter
> goes way back into history; it was avoiding to re-add manually removed paths
> because they were still showing up in maps. But OTOH we must add missing
> devices which we've failed to detect. The patch set handles this by tracking
> the state of "being removed" as a new init state, and only actually removing
> the paths from pathvec when they don't show up in maps any more.
> 
> Regards
> Martin
> 
> Martin Wilck (21):
>   libmultipath: protect use of pp->udev
>   libmultipath: add uninitialize_path()
>   multipath-tools: introduce INIT_REMOVED state
>   libmultipath: update_mpp_paths(): handle INIT_REMOVED
>   libmultipath: verify_paths(): don't delete paths from pathvec
>   libmultipath: sync_paths(): handle INIT_REMOVED
>   libmultipath: orphan_paths(): delete paths in INIT_REMOVED state
>   libmultipath: adopt_paths(): skip removed paths
>   multipathd: ev_remove_path(): use INIT_REMOVED
>   multipathd: deal with INIT_REMOVED during path addition
>   multipathd: check_path(): set retrigger_delay if necessary
>   libmultipath: add update_pathvec_from_dm()
>   libmultipath: update_pathvec_from_dm: handle pp->mpp mismatch
>   libmultipath: disassemble_map(): always search paths by dev_t
>   libmultipath: disassemble_map(): require non-NULL pathvec
>   libmultipath: disassemble_map(): get rid of "is_daemon" argument
>   libmultipath: disassemble_map(): do not change pathvec and WWIDs
>   multipath: use update_pathvec_from_dm()
>   libmpathpersist: use update_pathvec_from_dm()
>   libmultipath: decrease loglevel in store_path()
>   libmultipath: dmparser: constify function arguments
> 
>  libmpathpersist/mpath_persist.c       |  56 +-----
>  libmultipath/configure.c              |   2 +-
>  libmultipath/discovery.c              |  15 +-
>  libmultipath/dmparser.c               |  70 ++-----
>  libmultipath/dmparser.h               |   4 +-
>  libmultipath/prioritizers/alua_rtpg.c |   6 +-
>  libmultipath/structs.c                |  21 +-
>  libmultipath/structs.h                |   6 +
>  libmultipath/structs_vec.c            | 263 +++++++++++++++++++++++---
>  libmultipath/structs_vec.h            |  11 +-
>  multipath/main.c                      |  71 +------
>  multipathd/cli_handlers.c             |  49 ++++-
>  multipathd/main.c                     | 113 ++++++++---
>  13 files changed, 445 insertions(+), 242 deletions(-)
> 
> -- 
> 2.26.2
