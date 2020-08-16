From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH 0/6] multipath-tools series: some cleanups and
	fixes
Date: Sun, 16 Aug 2020 09:41:11 +0800
Message-ID: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmarzins@redhat.com, Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


When I learn and review the multipath-tools source code, I find
some cleanups and fixes.

repo: openSUSE/multipath-tools
repo link: https://github.com/openSUSE/multipath-tools
branch: upstream-queue

ZhiqiangLiu (6):
  checker: remove useless name check in checker_get func
  multipathd: adopt static char* arr in daemon_status
  multipathd: adopt static char* arr in sd_notify_status func
  libmultipath: check blist before calling MALLOC in alloc_ble_device
    func
  vector: add lower boundary check in vector_foreach_slot_after
  multipathd: return NULL if MALLOC fails in alloc_waiteri func

 libmultipath/blacklist.c |  8 +++++--
 libmultipath/checkers.c  |  9 ++++----
 libmultipath/vector.h    |  6 +++---
 multipathd/main.c        | 56 +++++++++++++++++++++++-------------------------
 multipathd/main.h        |  3 ++-
 multipathd/waiter.c      |  4 +++-
 6 files changed, 45 insertions(+), 41 deletions(-)

-- 
1.8.3.1
