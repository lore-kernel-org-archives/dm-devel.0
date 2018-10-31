From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 0/2] dm kcopyd: dm snapshot: Fix bugs causing
	excessive memory usage and workqueue stalls
Date: Wed, 31 Oct 2018 17:53:07 -0400
Message-ID: <20181031215309.6493-1-ntsironis@arrikto.com>
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
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: iliastsi@arrikto.com
List-Id: dm-devel.ids

This patchset fixes two kcopyd and dm-snapshot related issues:

  1. If kcopyd is not used properly, the kcopyd job slab cache can grow
     without limit causing excessive memory usage, which can lead to
     user processes being killed by the OOM killer.

  2. The kcopyd thread can hog the CPU while processing the submitted
     jobs resulting in workqueue stalls and performance degradation.

The root cause for issue (1) is the way dm-snapshot uses kcopyd. In
particular, the lack of an explicit or implicit limit to the maximum
number of in-flight COW jobs.

Issue (2) is caused by:

  a. Again, the lack of an upper limit to the number of in-flight kcopyd
     jobs created by dm-snapshot.

  b. The fact that one can keep inserting new completed jobs through
     dm_kcopyd_do_callback() or submitting copy jobs with a source size
     of 0, while the kcopyd thread is processing these jobs. This can
     lead to the kcopyd thread running completed jobs indefinitely.

Relevant dmesg outputs are provided per patch.

These issues were discovered using the device mapper test suite [1] and
the fixes were also tested with it. The relevant tests used are
documented per patch.

[1] https://github.com/jthornber/device-mapper-test-suite

Nikos Tsironis (2):
  dm snapshot: Fix excessive memory usage and workqueue stalls
  dm kcopyd: Fix bug causing workqueue stalls

 drivers/md/dm-kcopyd.c | 19 ++++++++++++++-----
 drivers/md/dm-snap.c   | 22 ++++++++++++++++++++++
 2 files changed, 36 insertions(+), 5 deletions(-)

-- 
2.11.0
