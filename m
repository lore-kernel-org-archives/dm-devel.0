From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH v2 0/2] introduce interface to list all badblocks
Date: Thu, 18 Jun 2020 17:06:18 +0800
Message-ID: <20200618090620.3517530-1-yangerkun@huawei.com>
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


This patchset will list badblocks while we do 'dmsetup status'.

Image that we have mark block 1 and 2 as bad block, run following
command will list all bad blocks:

    $ sudo dmsetup status dust1
    0 33552384 dust 252:17 bypass verbose badblocks list: 1 2

v1->v2:
Realize this logical in dust_status instead dust_message since the
result can return to user directly.


yangerkun (2):
  dm dust: list badblock in dust_status
  dm dust: introduce list badblocks in the rst

 .../admin-guide/device-mapper/dm-dust.rst     | 14 +++++++++++
 drivers/md/dm-dust.c                          | 25 +++++++++++++++++++
 2 files changed, 39 insertions(+)

-- 
2.25.4
