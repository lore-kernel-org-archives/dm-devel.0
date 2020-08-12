From: mwilck@suse.com
Subject: [PATCH v2 00/42] multipath-tools series part III:
	duplicate alias
Date: Wed, 12 Aug 2020 13:34:03 +0200
Message-ID: <20200812113405.26206-1-mwilck@suse.com>
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

This is part III of a larger patch series for multpath-tools I've been preparing.
It contains fixes for a customer issue where the same alias was set for
several maps with different WWIDs in the WWIDs file.

Note that this does *not* break the scenario Ben described in his response to
v1 of the part of the series. Details in the commit message of patch 41/42.

This part based on the previously submitted part II (which is completely
unchanged from the v1 submission and not re-posted).

The full series will also be available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-2008
This part is tagged "submit-200812-3".

Changes v1 -> v2, as suggested by Ben Marzinski:

 * 40/42 "libmultipath: refuse creating map with duplicate alias"
    - dropped, as this breaks valid scenarios
 * 40/42 "libmultipath: free_multipath(): remove mpp references"
    - new patch added, required to avoid segfaults; inserted here to preserve
      numbering
 * 41/42 "libmultipath: refuse reloading an existing map with different WWID"
    - unchanged, but not reviewed yet. Commit message improved.

NOTE: part VI and VII of the the series contain patches related to the topic
of this part, improving the handling of inconsistent alias settings further:

  80/80 "libmultipath: select_action(): don't drop map if alias clashes"
  84/84 "libmultipath: add consistency check for alias settings"

Regards,
Martin

Martin Wilck (3):
  libmultipath: free_multipath(): remove mpp references
  libmultipath: refuse reloading an existing map with different WWID
  libmultipath: dm_addmap(): refuse creating map with empty WWID

 libmultipath/configure.c | 19 +++++++++++++++----
 libmultipath/devmapper.c | 26 +++++++++++++++-----------
 libmultipath/structs.c   | 15 +++++++++++++++
 3 files changed, 45 insertions(+), 15 deletions(-)

-- 
2.28.0
