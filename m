From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Subject: [PATCH 0/3] dm-mpath: dynamic load balancers
	(v1)
Date: Wed, 18 Mar 2009 17:34:42 +0900
Message-ID: <49C0B222.9010600@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, stefan.bader@canonical.com
List-Id: dm-devel.ids

Hi,

The patch-set adds the following 2 dynamic load balancers:
  o dm-queue-length: queue-length oriented dynamic load balancer
  o dm-service-time: service-time oriented dynamic load balancer

This patch-set can be applied on top of 2.6.29-rc8.
No dependencies on Alasdair's linux-next patches.

NOTE:
While the patches compile and work with the current bio-based dm,
for them to *properly* work, the request-based dm patches should
be applied, too.
See <http://lkml.org/lkml/2008/9/12/100> for why request-based dm
improves multipath load balancing.

Summary of the patch-set:
  1/3: dm-mpath: interface change for dynamic load balancers
  2/3: dm-mpath: add queue-length oriented dynamic load balancer
  3/3: dm-mpath: add service-time oriented dynamic load balancer

 drivers/md/Kconfig            |   18 ++
 drivers/md/Makefile           |    2 
 drivers/md/dm-mpath.c         |   28 ++-
 drivers/md/dm-path-selector.h |    8 -
 drivers/md/dm-queue-length.c  |  257 +++++++++++++++++++++++++++++++++++
 drivers/md/dm-round-robin.c   |    2 
 drivers/md/dm-service-time.c  |  301 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 603 insertions(+), 13 deletions(-)

Thanks,
Kiyoshi Ueda
