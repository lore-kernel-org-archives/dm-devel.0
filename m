From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 0/2] marginal path fixes
Date: Wed,  7 Mar 2018 15:07:31 +0100
Message-ID: <20180307140733.28709-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Guan Junxiong <guanjunxiong@huawei.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Changes wrt v2:
 - 2/2: Fixed bug that would cause a crash if marginal path checker was off.
        (if we don't start the thread, we'd better not kill it, either).

Martin Wilck (2):
  libmultipath: fix race in stop_io_err_stat_thread
  multipathd: start marginal path checker thread lazily

 libmultipath/configure.c   | 14 ++++++++---
 libmultipath/configure.h   |  3 ++-
 libmultipath/io_err_stat.c | 59 ++++++++++++++++++++++++++++++++++++++++++----
 libmultipath/structs_vec.c |  3 ++-
 multipathd/cli_handlers.c  |  2 +-
 multipathd/main.c          |  8 ++-----
 6 files changed, 72 insertions(+), 17 deletions(-)

-- 
2.16.1
