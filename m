From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/4] dm-mpath: bug fixes around pg-init handling
Date: Mon, 01 Feb 2010 13:13:59 +0900
Message-ID: <4B665507.8080205@ct.jp.nec.com>
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
To: Alasdair Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair and multipath developers,

I've started to work on removing the multipath internal I/O queue,
since request-based dm-core now has a generic queue and multipath
can use it instead of having its own queue.

As a first step, I'm separating pg-init handling from queued I/O
handling.  During code inspection for that work, I found some bugs
in the current pg-init handling codes.
This patch-set fixes those bugs (and implies preparations for
the work of removing the multipath internal queue).

I don't have any active-passive storage, so I've just done compile
and boot tests.  Please review, and test on your storages.

This patch-set was made on top of 2.6.33-rc6 + Alasdair's patches below:
  dm-mpath-pass-struct-pgpath-to-pg-init-done.patch
  dm-mpath-skip-activate_path-for-failed-paths.patch
  dm-mpath-Remove-suspended-flag-from-struct-multipath.patch

Summary of the patch-set:
  1/4: dm-mpath: don't clear m->queue_io until all activations complete
  2/4: dm-mpath: must wait for pg-init completion in postsuspend
  3/4: dm-mpath: separate pg-init handling from process_queued_ios()
  4/4: dm-mpath: move initial pg-init kick into __switch_pg()

 drivers/md/dm-mpath.c |  131 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 97 insertions(+), 34 deletions(-)

Thanks,
Kiyoshi Ueda
