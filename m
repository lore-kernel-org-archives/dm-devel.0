From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 0/2] Couple of minor code cleanups
Date: Mon,  6 Jul 2015 11:55:39 -0400
Message-ID: <1436198141-19730-1-git-send-email-vgoyal@redhat.com>
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
Cc: thornber@redhat.com, Vivek Goyal <vgoyal@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

Hi,

Here are couple of minor code cleanups I found while I was browsing through
the code.

Thanks
Vivek

Vivek Goyal (2):
  Remove unused parameter in btree_split_sibling()
  dm-btree-remove: Remove function get_nr_entries()

 drivers/md/persistent-data/dm-btree-remove.c | 22 ----------------------
 drivers/md/persistent-data/dm-btree.c        |  6 +++---
 2 files changed, 3 insertions(+), 25 deletions(-)

-- 
2.1.0
