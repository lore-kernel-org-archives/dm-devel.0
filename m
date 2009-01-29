From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/0] dm-mpath: queue-length oriented dynamic load
	balancer
Date: Thu, 29 Jan 2009 15:59:10 +0900
Message-ID: <498153BE.60104@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Cc: dm-devel@redhat.com, stefan.bader@canonical.com
List-Id: dm-devel.ids

Hi,

The following patches add a queue-length oriented dynamic load
balancer, dm-queue-length, which selects a path having the least
number of in-flight I/Os.

This patch-set can be applied on top of 2.6.29-rc2.

Summary of the patch-set:
  1/2: dm-mpath: add a path-selector interface
  2/2: dm-mpath: add queue-length oriented dynamic load balancer

Thanks,
Kiyoshi Ueda
