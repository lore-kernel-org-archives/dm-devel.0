From: mwilck@suse.com
Subject: [PATCH 00/42] multipath-tools series part III: duplicate
	alias
Date: Thu,  9 Jul 2020 12:35:10 +0200
Message-ID: <20200709103513.8142-1-mwilck@suse.com>
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

This is part II of a larger patch series for multpath-tools I've been preparing.
It contains fixes for a customer issue where the same alias was set for
several maps with different WWIDs in the WWIDs file.

It's based on the previously submitted part II.

The full series will also be available here:
https://github.com/mwilck/multipath-tools/tree/ups/submit-2007

There are tags in that repo for each part of the series.
This part is tagged "submit-200709-3".

Regards,
Martin

Martin Wilck (3):
  libmultipath: refuse creating map with duplicate alias
  libmultipath: refuse reloading an existing map with different WWID
  libmultipath: dm_addmap(): refuse creating map with empty WWID

 libmultipath/configure.c   | 24 ++++++++++++++++++++----
 libmultipath/devmapper.c   | 26 +++++++++++++++-----------
 libmultipath/structs_vec.c | 13 +++++++++++++
 libmultipath/structs_vec.h |  1 +
 multipathd/main.c          |  6 +++++-
 5 files changed, 54 insertions(+), 16 deletions(-)

-- 
2.26.2
