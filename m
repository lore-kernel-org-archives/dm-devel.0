From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 0/0] dm-mpath: service-time oriented dynamic
	load balancer
Date: Thu, 29 Jan 2009 16:07:55 +0900
Message-ID: <498155CB.8030902@ct.jp.nec.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

The following patches add a service-time oriented dynamic load
balancer, dm-service-time, which selects a path to complete
the incoming I/O with the shortest time.

While the dm-queue-length path selector posted in the other thread
is ready for inclusion, I would rather like to hear comments from
other dm-multipath users and developers for dm-service-time before
pushing it to mainline.


dm-service-time stores the recent throughput information for each path.
Service time for a incoming I/O is estimated by:
  ("the total size of in-flight I/Os on the path" +
   "the size of the incoming I/O") / "the recent throughput"

There could be simpler path selection methods:
  - Size-based path selection.
    i.e. just use the total size of in-flight I/Os on the path.
    It is simpler and works fine if each path has same bandwidth,
    is evenly loaded and has no disturbance from external system.
  - Use user-specified performance value for each path.
    i.e. instead of calculating the throughput in kernel, the value
    is given from userspace.
    It works fine if the bandwidth of paths are asymmetric but
    there is no disturbance from external system.

dm-service-time is more adaptive than the above 2 methods.
However, if the simpler methods are preferred in some cases, I can
split the dm-service-time into the pieces to allow the simpler
approaches.


This patch-set can be applied on top of 2.6.29-rc2 + dm-queue-length
patches(*).

(*) https://www.redhat.com/archives/dm-devel/2009-January/msg00183.html

Summary of the patch-set:
  1/2: dm-mpath: interface change for preparation
  2/2: dm-mpath: add service-time oriented dynamic load balancer

Thanks,
Kiyoshi Ueda
