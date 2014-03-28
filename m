From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/9] dm crypt: improve cpu scalability
Date: Fri, 28 Mar 2014 16:11:07 -0400
Message-ID: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

With these changes we hope to improve dm-crypt performance for a
wide-range of dm-crypt use-cases and configurations.  Extensive
testing is planned to identify the performance difference(s) as
compared to stock v3.14-rc8.  We'll up this thread as results become
available.

These changes are staged in linux-dm.git 'for-next' -- that is
primarily for linux-next test coverage purposes.  We'll make a call on
whether any of these patches are included in 3.15 when we have the
benefit of performance comparison results.

Mikulas Patocka (9):
  dm crypt: fix cpu hotplug crash by removing per-cpu structure
  block: use kmalloc alignment for bio slab
  dm crypt: use per-bio data
  dm crypt: use unbound workqueue for request processing
  dm crypt: don't allocate pages for a partial request
  dm crypt: avoid deadlock in mempools
  dm crypt: remove io_pool
  dm crypt: offload writes to thread
  dm crypt: sort writes

 drivers/md/dm-crypt.c | 413 +++++++++++++++++++++++++-------------------------
 fs/bio.c              |   3 +-
 2 files changed, 209 insertions(+), 207 deletions(-)

-- 
1.8.1.4
