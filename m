From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/9] dm patches for kernel v4.9
Date: Wed, 31 Aug 2016 15:14:32 -0700
Message-ID: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello Mike,

This patch series avoids that removing a dm device hangs sporadically. I 
would appreciate it if you would consider these patches for inclusion in 
kernel v4.9. The patches in this series are:

0001-blk-mq-Introduce-blk_mq_queue_stopped.patch
0002-dm-Rename-a-function-argument.patch
0003-dm-Introduce-signal_pending_state.patch
0004-dm-Convert-wait-loops.patch
0005-dm-Add-two-lockdep_assert_held-statements.patch
0006-dm-Simplify-dm_old_stop_queue.patch
0007-dm-Mark-block-layer-queue-dead-before-destroying-the.patch
0008-dm-Fix-two-race-conditions-related-to-stopping-and-s.patch
0009-dm-path-selector-Avoid-that-device-removal-triggers-.patch

Thanks,

Bart.
