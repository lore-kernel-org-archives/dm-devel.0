From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH v3 0/4] introduce interface to list badblocks
Date: Fri, 19 Jun 2020 20:37:59 +0800
Message-ID: <20200619123803.1441373-1-yangerkun@huawei.com>
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
To: snitzer@redhat.com, bgurney@redhat.com, agk@redhat.com, bmr@redhat.com
Cc: dm-devel@redhat.com, yangerkun@huawei.com
List-Id: dm-devel.ids

Since .message support report results to user directly. We can change
some type of message(queryblock/countbadblocks/removebadblock) to return
results to user.

Besides, we add a interface 'listbadblocks' to list all bad block. If
no bad block exists, we will return 'null', or we will list them multi
line which each line means one bad block.

v2->v3:
Realize this logical in .message, change logical for some type message to
report results to user too.

yangerkun (4):
  dm dust: report some message results back to user directly
  dm dust: update doc after message results report to user directly
  dm dust: add interface to list all badblocks
  dm dust: introduce listbadblocks in the rst

 .../admin-guide/device-mapper/dm-dust.rst     | 31 +++++++---
 drivers/md/dm-dust.c                          | 58 ++++++++++++++-----
 2 files changed, 69 insertions(+), 20 deletions(-)

-- 
2.25.4
