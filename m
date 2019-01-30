From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 0/4] Marginal Path Fixes and cleanups
Date: Wed, 30 Jan 2019 16:13:03 -0600
Message-ID: <1548886387-23381-1-git-send-email-bmarzins@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>, Martin Wilck <mwilck@suse.com>, Muneendra <muneendra.kumar@broadcom.com>
List-Id: dm-devel.ids

I've been playing around with the marginal path code, and I've run into
a couple of things that could be cleaned up. The one important issue is
that the marginal paths code tries to enqueue the path for IO error
checking when it is down.  To enqueue the path, it needs to open the
device, which can fail because the path is down.  Instead, it should
wait for the path to come back up before it queues it, and starts the IO
error checking. This is fixed in patch 0003. The other patches are
mostly cleanups. The issues they fix aren't actually breaking things. 

Benjamin Marzinski (4):
  libmultipath: handle existing paths in marginal_path enqueue
  multipathd: cleanup marginal paths checking timers
  libmultipath: fix marginal paths queueing errors
  libmultipath: fix marginal_paths nr_active check

 libmultipath/io_err_stat.c | 71 +++++++++++++++-----------------------
 libmultipath/io_err_stat.h |  2 +-
 multipathd/main.c          |  3 +-
 3 files changed, 31 insertions(+), 45 deletions(-)

-- 
2.17.2
