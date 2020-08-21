From: Ye Bin <yebin10@huawei.com>
Subject: [PATCH 0/4] Fix use-after-free in dm_bm_set_read_only
Date: Fri, 21 Aug 2020 17:26:47 +0800
Message-ID: <20200821092651.1587859-1-yebin10@huawei.com>
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
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: yebin10@huawei.com
List-Id: dm-devel.ids

Ye Bin (4):
  dm thin metadata: Avoid return pmd->bm wild pointer when process with
    error
  dm thin metadata: Fix use-after-free in dm_bm_set_read_only
  dm cache metadata: Avoid return pmd->bm wild pointer when process with
    error
  dm cache metadata: Avoid use-after-free in
    dm_cache_metadata_set_read_only

 drivers/md/dm-cache-metadata.c | 14 ++++++++++----
 drivers/md/dm-thin-metadata.c  | 14 ++++++++++----
 2 files changed, 20 insertions(+), 8 deletions(-)

-- 
2.25.4
