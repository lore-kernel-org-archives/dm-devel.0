From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 0/4] dm: fix various issues with bio splitting
	code
Date: Sat, 19 Jan 2019 13:05:02 -0500
Message-ID: <20190119180506.1300-1-snitzer@redhat.com>
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
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, NeilBrown <neilb@suse.com>, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Hi,

These mostly stable@ patches will be sent to Linus for 5.0-rc4
inclusion (would've sent today for 5.0-rc3 but I don't yet have
linux-next coverage).

Just wanted to give a heads up because some of the problems fixed
could bite other users of the bio_split()+generic_make_request()
recursive pattern.  We should probably factor out some helpers that
all users could share (e.g. so they don't forget to set
BIO_QUEUE_ENTERED or call trace_block_split(), etc).

Thanks,
Mike

Mike Snitzer (4):
  dm: fix clone_bio() to trigger blk_recount_segments()
  dm: fix redundant IO accounting for bios that need splitting
  dm: fix missing bio_split() pattern code in __split_and_process_bio()
  dm: fix dm_wq_work() to only use __split_and_process_bio() if appropriate

 drivers/md/dm.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

-- 
2.15.0
