From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.2.0:
 Introduction
Date: Fri, 04 Jul 2008 12:40:38 +0900 (JST)
Message-ID: <20080704.124038.193696173.ryov@valinux.co.jp>
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
Cc: agk@sourceware.org
List-Id: dm-devel.ids

Hi everyone,

This is the dm-ioband version 1.2.0 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

- Can be applied to the kernel 2.6.26-rc5-mm3.
- Changes from 1.1.0 (posted on June 2, 2008):
  - Dynamic policy switching
    A user can change the bandwidth control policy while the dm-ioband
    device is active. It is useful when the dm-ioband device is used
    as a root device.
  - I/O smoothing take #1
    This feature makes I/O requests of each group issued smoothly.
    Once a certain group has used up its tokens, all I/O requests to
    the group will be blocked until all the other groups used up theirs.
    This feature is to minimize this blocking time.
    We are now testing on the 2nd step and we will release it soon,
    which will improve the smoothness significantly.
  - Replace simple_strtol() with strict_strtol().
  - Fix I/O errors encountered after "dmsetup resume."

Thanks,
Ryo Tsuruta
Linux Block I/O Bandwidth Control Project
http://people.valinux.co.jp/~ryov/bwctl/
