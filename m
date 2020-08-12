From: mwilck@suse.com
Subject: [PATCH v2 00/74] multipath-tools series part V: removed
	path handling
Date: Wed, 12 Aug 2020 13:35:03 +0200
Message-ID: <20200812113511.26469-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, hi Ben,

This is part V of a larger patch series for multipath-tools I've been preparing.
It's based on the previously submitted part IV.

The full series will also be available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-2008
This part is tagged "submit-200812-5".

The series addresses several issues with missing, unintialized, and removed
paths. The motivation was that I strongly dislike the side effects of
disassemble_map(), adding paths and setting WWIDs while parsing map
parameters. IMO this has always been a layering violation. This patch set adds
a new function dedicated to handling paths which have not been detected via
udev but are present as members of dm maps. That makes it much easier to
track and improve the logic applied when such devices are detected.

I believe that the new logic will also fix the issue recently reported by
Chongyun ("libmultipath/dmparser: add missing path with good status when sync
state with dm kernel"). At least, the approach is very similar, although
the call to pathinfo() for new devices now happens in update_pathvec_from_dm()
rather than in disassemble_map().

The patch set also gets rid of the "is_daemon" argument for disassemble_map(),
causing semantics in daemon and non-daemon mode. The reason for this parameter
goes way back into history; it was avoiding to re-add manually removed paths
because they were still showing up in maps. But OTOH we must add missing
devices which we've failed to detect. The patch set handles this by tracking
the state of "being removed" as a new init state, and only actually removing
the paths from pathvec when they don't show up in maps any more.

Changes v1 -> v2, as suggested by Ben Marzinski:

 * 55: "libmultipath: add uninitialize_path()"
 * 58: "libmultipath: verify_paths(): don't delete paths from pathvec"
    - context changes
 * 61: "libmultipath: adopt_paths(): skip removed paths"
    - set pp->mpp before checking for INIT_REMOVED
 * 63: "multipathd: deal with INIT_REMOVED during path addition"
    - BUG message if path not mpp member
    - set pp->tick to 1 to make sure paths are quickly reinstated
    - remove "was_removed" variable
 * 64: "multipathd: check_path(): set retrigger_delay if necessary"
    - drop, replace with "libmultipath: orphan_paths(): avoid BUG message"
 * 65: libmultipath: add update_pathvec_from_dm()
    - add comment about pp->udev being initialized
    - discard paths with pathinfo() errors
    - set must_reload if pathgroup was removed
 * 66: "libmultipath: update_pathvec_from_dm: handle pp->mpp mismatch"
    - handle the two failure cases "pp->mpp points to different map" and 
      "wrong wwid" differently. In the latter case, use orphan_path()
 * 71: "multipath: use update_pathvec_from_dm()"
    - use DI_NOIO for CMD_LIST_SHORT. In update_pathvec_from_dm, mask
      out DI_NOIO when checking existing paths

NOTE: In my v1 submission, I made a mistake when sending part V, so that
*patch number 54 is present twice* in the full series.
I deliberately didn't correct that this time, to preserve numbering.

Regards
Martin

Martin Wilck (21):
  libmultipath: protect use of pp->udev
  libmultipath: add uninitialize_path()
  multipath-tools: introduce INIT_REMOVED state
  libmultipath: update_mpp_paths(): handle INIT_REMOVED
  libmultipath: verify_paths(): don't delete paths from pathvec
  libmultipath: sync_paths(): handle INIT_REMOVED
  libmultipath: orphan_paths(): delete paths in INIT_REMOVED state
  libmultipath: adopt_paths(): skip removed paths
  multipathd: ev_remove_path(): use INIT_REMOVED
  multipathd: deal with INIT_REMOVED during path addition
  libmultipath: orphan_paths(): avoid BUG message
  libmultipath: add update_pathvec_from_dm()
  libmultipath: update_pathvec_from_dm: handle pp->mpp mismatch
  libmultipath: disassemble_map(): always search paths by dev_t
  libmultipath: disassemble_map(): require non-NULL pathvec
  libmultipath: disassemble_map(): get rid of "is_daemon" argument
  libmultipath: disassemble_map(): do not change pathvec and WWIDs
  multipath: use update_pathvec_from_dm()
  libmpathpersist: use update_pathvec_from_dm()
  libmultipath: decrease loglevel in store_path()
  libmultipath: dmparser: constify function arguments

 libmpathpersist/mpath_persist.c       |  56 +----
 libmultipath/configure.c              |   2 +-
 libmultipath/discovery.c              |  15 +-
 libmultipath/dmparser.c               |  70 ++----
 libmultipath/dmparser.h               |   4 +-
 libmultipath/prioritizers/alua_rtpg.c |   6 +-
 libmultipath/structs.c                |  21 +-
 libmultipath/structs.h                |   6 +
 libmultipath/structs_vec.c            | 293 +++++++++++++++++++++++---
 libmultipath/structs_vec.h            |  11 +-
 multipath/main.c                      |  72 +------
 multipathd/cli_handlers.c             |  54 ++++-
 multipathd/main.c                     | 112 ++++++++--
 13 files changed, 479 insertions(+), 243 deletions(-)

-- 
2.28.0
