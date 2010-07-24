From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 00/12] dm: enable discard support for more
	targets
Date: Sat, 24 Jul 2010 12:09:16 -0400
Message-ID: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

v2 rebases all patches to Alasdair's latest editing tree and
linux-2.6-block's 'for-2.6.36'.

This patchset enables discard support for most of the DM targets that
discards are intended to be supported on.

This patchset is also available here:
http://people.redhat.com/msnitzer/patches/dm-discard-advanced/latest/

The stripe target's discard support was the most tedious and
challenging to implement.  It may see further edits before it lands
upstream.

The mirror target still needs discard support.  Either I or someone
else (nudge: Mikulas and/or Jon? :) will need to implement that.

The snapshot and crypt targets will not have discard support.

Snapshots must preserve any data that is deleted so the value of
discard is negligible.  Discard support for the origin target may be
considered in the future (could be especially useful if origin and COW
are different devices and origin is a thinly provisioned LUN).

Crypt devices are concerned with security and, until proven otherwise,
it is believed that discards will leak too much pattern information to
the crypt device's underlying storage (especially when underlying
storage uses discards that zero data).

Mike Snitzer (12):
  dm: rename map_info flush_request to target_request_nr
  dm: introduce num_discard_requests in dm_target structure
  dm: remove the DM_TARGET_SUPPORTS_DISCARDS feature flag
  dm: use common __issue_target_request for flush and discard support
  dm: factor max_io_len for code reuse
  dm: split discard requests on target boundaries
  dm zero: silently drop discards too
  dm error: return error for discards too
  dm delay: enable discard support
  block: update request stacking methods to support discards
  dm mpath: enable discard support
  dm stripe: enable efficient discard support

 block/blk-core.c              |    5 +
 drivers/md/dm-delay.c         |    1 +
 drivers/md/dm-linear.c        |    2 +-
 drivers/md/dm-mpath.c         |    1 +
 drivers/md/dm-snap.c          |    2 +-
 drivers/md/dm-stripe.c        |  180 ++++++++++++++++++++++++++++++++++++++---
 drivers/md/dm-table.c         |    2 +-
 drivers/md/dm-target.c        |    3 +
 drivers/md/dm-zero.c          |    3 +
 drivers/md/dm.c               |   89 +++++++++++++-------
 include/linux/device-mapper.h |   11 ++-
 11 files changed, 253 insertions(+), 46 deletions(-)
