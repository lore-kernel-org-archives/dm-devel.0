From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/8] I/O bandwidth controller and BIO tracking
Date: Thu, 13 Nov 2008 12:10:19 +0900 (JST)
Message-ID: <20081113.121019.104237699577193919.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org
List-Id: dm-devel.ids

Hi everyone,

This is a new release of dm-ioband and bio-cgroup. With this release,
the overhead of bio-cgroup is significantly reduced and the accuracy
of block I/O tracking is much improved. These patches are for
2.6.28-rc2-mm1.

Enjoy it!

dm-ioband
=========

Dm-ioband is an I/O bandwidth controller implemented as a
device-mapper driver, which gives specified bandwidth to each job
running on the same block device. A job is a group of processes
or a virtual machine such as KVM or Xen. 
I/O throughput on dm-ioband is excellent not only on SATA storage
but on SDD, which as good as the one without dm-ioband.

Changes from the previous release:
  - Fix a bug that create_workqueue() is called during spin lock
    when creating a new ioband group.
  - A new tunable parameter "carryover" is added, which specifies
    how many tokens an ioband group can keep for the future use
    when the group isn't so active.

TODO:
  - Other policies to schedule BIOs.
    - Policies which fits SSD.
     e.g.)
       - Guarantee response time.
       - Guarantee throughput.
    - Policies which fits Highend Storage or hardware raid storage.
       - Some LUNs may share the same bandwidth.
  - Support WRITE_BARRIER when the device-mapper layer supports it.
  - Implement the algorithm of dm-ioband in the block I/O layer
    experimentally.

bio-cgroup
==========

Bio-cgroup is a BIO tracking mechanism, which is implemented on the
cgroup memory subsystem. With the mechanism, it is able to determine
which cgroup each of bio belongs to, even when the bio is one of
delayed-write requests issued from a kernel thread such as pdflush.

Changes from the previous release:
  - This release is a new implementation.
  - This is based on the new design of the cgroup memory controller
    framework, which pre-allocates all cgroup-page data structures to
    reduce the overhead.
  - The overhead to trace block I/O requests is much smaller than that
    of the previous one. This is done by making every page have the id
    of its corresponding bio-cgroup instead of the pointer to it and
    most of spin-locks and atomic operations are gone.
  - This implementation uses only 4 bytes per page for I/O tracking
    while the previous version uses 12 bytes on a 32 bit machine and 24
    bytes on a 64 bit machine.
  - The accuracy of I/O tracking is improved that it can trace I/O
    requests even when the processes which issued these requests get
    moved into another bio-cgroup.
  - Support bounce buffers tracking. They will have the same bio-cgroup
    owners as the original I/O requests.

TODO:
  - Support to track I/O requests that will be generated in Linux
    kernel, such as those of RAID0 and RAID5.

A list of patches
=================

The following is a list of patches:

  [PATCH 0/8] I/O bandwidth controller and BIO tracking
  [PATCH 1/8] dm-ioband: Introduction
  [PATCH 2/8] dm-ioband: Source code and patch
  [PATCH 3/8] dm-ioband: Document
  [PATCH 4/8] bio-cgroup: Introduction
  [PATCH 5/8] bio-cgroup: The new page_cgroup framework
  [PATCH 6/8] bio-cgroup: The body of bio-cgroup
  [PATCH 7/8] bio-cgroup: Page tracking hooks
  [PATCH 8/8] bio-cgroup: Add a cgroup support to dm-ioband

Please see the following site for more information:
  Linux Block I/O Bandwidth Control Project
  http://people.valinux.co.jp/~ryov/bwctl/

Thanks,
Ryo Tsuruta
