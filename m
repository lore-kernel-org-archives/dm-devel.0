From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.8.0:
 Introduction
Date: Fri, 17 Oct 2008 16:09:50 +0900 (JST)
Message-ID: <20081017.160950.71109894.ryov@valinux.co.jp>
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
To: agk@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: fernando@oss.ntt.co.jp
List-Id: dm-devel.ids

Hi Alasdair and all,

This is the dm-ioband version 1.8.0 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

This release is a minor bug fix and confirmed running on the latest
stable kernel 2.6.27.1.

- Can be applied to the kernel 2.6.27.1 and 2.6.27-rc5-mm1.
- Changes from 1.7.0 (posted on Oct 3, 2008):
  - Fix a minor bug in io_limit setting that causes dm-ioband to stop
    issuing I/O requests when a large value is set to io_limit.

Alasdair, could you please review this patch and give me any comments?

Thanks,
Ryo Tsuruta
