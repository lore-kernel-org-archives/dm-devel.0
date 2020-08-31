From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH V4 0/5] multipath-tools series: some cleanups and
	fixes
Date: Mon, 31 Aug 2020 19:36:15 +0800
Message-ID: <50b2333d-8c5d-8705-a31a-11bb84980373@huawei.com>
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
Content-Language: en-US
To: Martin Wilck <mwilck@suse.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, yanxiaodan@huawei.com, linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com, zkabelac@redhat.com, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


When I learn and review the multipath-tools source code, I find
some cleanups and fixes.

V3->V4:
[PATCH V4 2/5] multipathd: use daemon_status_msg to construct sd notify msg
in do_sd_notify func
-- put "STATUS=" in format string to avoid "prefix" var as suggested by
Martin.


V2->V3:
[PATCH V3 1/5] multipathd: adopt static char* arr in daemon_status
  - add default case in sd_notify_status to fix compile error
[PATCH V3 2/5] multipathd: use daemon_status_msg to construct sd notify
  - set MSG_SIZE to 32 and use safe_sprintf as suggested by Martin.

V1->V2:
- rewrite some patches as suggested by Martin.

repo: openSUSE/multipath-tools
repo link: https://github.com/openSUSE/multipath-tools
branch: upstream-queue

ZhiqiangLiu (2):
  multipathd: adopt static char* arr in daemon_status
  multipathd: use daemon_status_msg to construct sd notify msg in
    do_sd_notify func

 multipathd/main.c | 62 +++++++++++++++++++++--------------------------
 multipathd/main.h |  3 ++-
 2 files changed, 29 insertions(+), 36 deletions(-)

-- 
2.24.0.windows.2
