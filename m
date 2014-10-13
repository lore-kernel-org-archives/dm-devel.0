From: Mikulas Patocka <mpatocka@redhat.com>
Subject: A patchset to limit the number of outstanding bios
Date: Mon, 13 Oct 2014 11:27:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410131113450.3569@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I'm announcing the release of a patchset that limits the number of 
outstanding bios in the device mapper.

The patchset is at 
http://people.redhat.com/~mpatocka/patches/kernel/dm-limit-outstanding-bios/

The default limit is 1024, the minimum limit is 4 (but I verified that the 
testsuite works even with limit 1). The limit can be set in 
/sys/block/dm-*/queue/nr_requests

The limit for newly created dm devices can be set in 
/sys/module/dm_mod/parameters/default_nr_requests (for example, you can 
set it before running the testsuite or some benchmark).

The patchset could possibly fix bug 1010466.

Note that the patch "punt-to-workqueue.patch" is required, otherwise we 
get lockups in the testsuite at low nr_requests values. The patch 
"fix-counting.patch" isn't required, but it is included to avoid patch 
conflicts.

Mikulas
