From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: [PATCH] Memory leaks and race condition fixes.
Date: Wed, 18 Mar 2009 19:38:05 -0400
Message-ID: <1237419489-3303-1-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Various set of fixes I've carried in my tree. These patches
came as a result of running valgrind on multipathd/multipath
and finding simple bugs and some complex.

Konrad Rzeszutek (4):
      Free prio_name and checker_name now that we dynamically allocate them.
      Unload prio and checkers libraries during shutdown.
      Don't display the state of the newly added map during addition in the daemon and don't switch groups.
      Race-condition fix with free_waiter threads during shutdown.
