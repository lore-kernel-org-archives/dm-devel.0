From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/4] multipath-tools: prio handling for offline
	paths
Date: Thu, 11 Apr 2019 12:49:19 +0200
Message-ID: <20190411104923.13470-1-mwilck@suse.com>
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

A recent bug report revealed that the handling of path priorities is
inconsistent in multipathd when paths fail. In the current code, depending
on timing, the prio of a faild path may be reset to 0, reset to -1
(PRIO_UNDEF), or not reset at all. The inconsistency is most obvious
with "group_by_prio", as it results in strange artefacts how failed
paths are regrouped, and how path groups are sorted.

This series tries to address these issues.

The general mind set that I applied is that, in case of doubt, it's
best to retain the priority that was retrieved while the path was
last accessible.

Martin Wilck (4):
  libmultipath: group_by_prio: fix signedness bug
  Revert "Set priority to '0' for PATH_BLOCKED or PATH_DOWN"
  libmultipath: ana prioritizer: decrease log level
  libmultipath: get_prio(): don't reset prio for inaccessible paths

 libmultipath/discovery.c        | 16 +++++++++++-----
 libmultipath/pgpolicies.c       |  2 +-
 libmultipath/prioritizers/ana.c |  2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.21.0
