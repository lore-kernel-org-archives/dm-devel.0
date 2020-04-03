From: mwilck@suse.com
Subject: [PATCH v2 0/2] multipath-tools: fixes for kpartx.rules
	and skip_kpartx
Date: Fri,  3 Apr 2020 13:19:12 +0200
Message-ID: <20200403111914.30717-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, vliaskovitis@suse.com
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Hi Christophe, Ben,

The "skip_kpartx" option serves to prevent creation of partitions on
top of multipath devices where that's undesired, e.g. on VM hosts which are
supposed to provide the unpartitioned dm devices to guests. This is broken
with our current udev rules, because partition creation is only suppressed
on "primary" uevents, and not on "sporadic" ones.

This series fixes the issue. It replaces my previous patch "kpartx.rules: 
check for skip_kpartx if DM_ACTIVATION is unset", which turned out to be
insufficient.

Regards,
Martin


Martin Wilck (2):
  kpartx.rules: honor DM_UDEV_DISABLE_OTHER_RULES_FLAG
  kpartx.rules: check for skip_kpartx on synthetic uevents

 kpartx/kpartx.rules | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
2.25.1
