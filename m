From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH V2 0/5] multipath-tools series: some cleanups and
	fixes
Date: Fri, 21 Aug 2020 18:57:31 +0800
Message-ID: <52b3b834-6da6-99c1-a2d1-95c2387c47e3@huawei.com>
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
To: mwilck@suse.com, Benjamin Marzinski <bmarzins@redhat.com>, Christophe
	Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


When I learn and review the multipath-tools source code, I find
some cleanups and fixes.

V1->V2:
- rewrite some patches as suggested by Martin.

repo: openSUSE/multipath-tools
repo link: https://github.com/openSUSE/multipath-tools
branch: upstream-queue

ZhiqiangLiu (5):
  multipathd: adopt static char* arr in daemon_status
  multipathd: use daemon_status_msg to construct sd notify msg in
    do_sd_notify func
  libmultipath: check blist before calling MALLOC in alloc_ble_device
    func
  vector: add lower boundary check in vector_foreach_slot_after
  multipathd: remove useless memset after MALLOC in alloc_waiteri func

 libmultipath/blacklist.c |  8 +++--
 libmultipath/vector.h    |  7 +++--
 multipathd/main.c        | 66 +++++++++++++++++++---------------------
 multipathd/main.h        |  3 +-
 multipathd/waiter.c      |  8 +----
 5 files changed, 44 insertions(+), 48 deletions(-)

-- 
2.24.0.windows.2
