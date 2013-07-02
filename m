From: Mikulas Patocka <mpatocka@redhat.com>
Subject: test needed for a dm-bufio patch
Date: Tue, 2 Jul 2013 17:51:50 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1307021747280.2229@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi Joe

Could you please try this patch 
http://people.redhat.com/agk/patches/linux/editing/dm-bufio-submit-writes-outside-lock.patch
and test if it generates some regressions for dm-thin?

Run some benchmark that you normally use for dm-thin and test if it is 
better, same or worse with the patch.

The patch changes dm-bufio so that it drops the lock when submitting bios 
inside dm_bufio_write_dirty_buffers so that there is more parallelism.

Mikulas
