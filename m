From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 1/7] blkio-cgroup-v10: Introduction
Date: Tue, 28 Jul 2009 21:09:34 +0900 (JST)
Message-ID: <20090728.210934.193696111.ryov@valinux.co.jp>
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
List-Id: dm-devel.ids

Hi all,

This is a new release of blkio-cgroup v10. This release reduces
IO tracking overhead and fixes an issue that could cause a deadlock
since lock_page_cgroup() is no longer used.
Thank you KAMEZAWA-san for your suggestions and pointing out the issue.

This patch can be applied to 2.6.31-rc3-mmotm0716 and 2.6.31-rc4.

The list of the patches:
  [PATCH 1/7] blkio-cgroup-v10: Introduction
  [PATCH 2/7] blkio-cgroup-v10: The new page_cgroup framework
  [PATCH 3/7] blkio-cgroup-v10: Refactoring io-context initialization
  [PATCH 4/7] blkio-cgroup-v10: The body of blkio-cgroup
  [PATCH 5/7] blkio-cgroup-v10: The document of blkio-cgroup
  [PATCH 6/7] blkio-cgroup-v10: Page tracking hooks
  [PATCH 7/7] blkio-cgroup-v10: Add a cgroup support to dm-ioband

About blkio-cgroup:
blkio-cgroup is a block I/O tracking mechanism implemented on the
cgroup memory subsystem. Using this feature the owners of any type of
I/O can be determined. This allows dm-ioband to control block I/O
bandwidth even when it is accepting delayed write requests. dm-ioband
can find the cgroup of each request. It is also for possible that
others working on I/O bandwidth throttling to use this functionality
to control asynchronous I/O with a little enhancement.

Please visit our website, the patches and more information are available.
  Linux Block I/O Bandwidth Control Project
  http://sourceforge.net/apps/trac/ioband/

I'd like to get some feedbacks from the list. Any comments are
appreciated.

Thanks,
Ryo Tsuruta
