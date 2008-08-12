From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/7] I/O bandwidth controller and BIO tracking
Date: Tue, 12 Aug 2008 21:31:53 +0900 (JST)
Message-ID: <20080812.213153.193691490.ryov@valinux.co.jp>
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

Here are new releases of dm-ioband and bio-cgroup.

The major change from the previous version is that dm-ioband now supports
a device-mapper bvec merge function, which removes the restriction that
the device-mapper framework automatically splits a I/O request into
several small I/O requests. The size of I/O requests was limited to
PAGE_SIZE when the underlying device, such as software RAID, had its
own merge function. This restriction had ever been applied to all
device-mapper drivers, but it has been solved recently by introducing
the bvec merge function feature into device-mapper.

The release also includes a minor update of bio-cgroup, that removes
some unused code in bio_cgroup_move_task(), which is no longer necessary.

dm-ioband
  Dm-ioband is an I/O bandwidth controller implemented as a
  device-mapper driver, which gives specified bandwidth to each job
  running on the same block device. A job is a group of processes
  with the same pid or pgrp or uid or a virtual machine such as KVM
  or Xen. A job can also be a cgroup by applying the bio-cgroup patch.

bio-cgroup
  Bio-cgroup is a BIO tracking mechanism, which is implemented on the
  cgroup memory subsystem. With the mechanism, it is able to determine
  which cgroup each of bio belongs to, even when the bio is one of
  delayed-write requests issued from a kernel thread such as pdflush.

The following is a list of patches:

  [PATCH 1/7] dm-ioband: Patch of device-mapper driver
  [PATCH 2/7] dm-ioband: Documentation of design overview, installation,
                         command reference and examples.
  [PATCH 3/7] bio-cgroup: Introduction
  [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into two parts
  [PATCH 5/7] bio-cgroup: Remove a lot of "#ifdef"s
  [PATCH 6/7] bio-cgroup: Implement the bio-cgroup
  [PATCH 7/7] bio-cgroup: Add a cgroup support to dm-ioband

Please see the following site for more information:
  Linux Block I/O Bandwidth Control Project
  http://people.valinux.co.jp/~ryov/bwctl/

Thanks,
Ryo Tsuruta
