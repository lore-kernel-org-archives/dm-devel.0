From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.0.0:
 Introduction
Date: Mon, 19 May 2008 17:22:38 +0900 (JST)
Message-ID: <20080519.172238.193709851.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: agk@sourceware.org
List-Id: dm-devel.ids

Hi everyone,

This is dm-ioband version 1.0.0 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

- Can be applied to the kernel 2.6.26-rc2-mm1.
- Changes from 0.0.4 (24th April):
    - Performance tuning
      - A new bandwidth control policy is added. This policy controls
        bandwidth based on the number of I/O sectors instead of the
	number of I/O requests.
	I think it would be useful for some applications such as video
	streaming or when you want to use high-end storages.
       - Control read and write requests separately. So even if a
         write I/O queue in an elevator is full, read I/O requests
	 won't be blocked.
      - More accurate bandwidth control.
    - Code cleanups. Remove the "LINUX_VERSION_CODE" and "inline" stuff.
    - Fix panic on "dmsetup suspend."

For more details, please refer to:
http://people.valinux.co.jp/~ryov/dm-ioband/

Thanks,
Ryo Tsuruta
