From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: dm-ioband RPM packages
Date: Fri, 26 Jun 2009 17:46:39 +0900 (JST)
Message-ID: <20090626.174639.193685940.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, centos@centos.org
List-Id: dm-devel.ids

Hi all,

I'm pleased to announce that the new dm-ioband RPM package (v1.12.0)
has been released at:
  http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband

dm-ioband provides disk bandwidth control on per partition, per user,
per process and per virtual machine (such as KVM or Xen) basis.

The RPM packages are for Red Hat Enterprise Linux 5.x and CentOS
5.x. They were tested on RHEL 5.2 and CentOS 5.3 and will also work on
other 5.x versions.

The major change of this release is that a new bandwidth control
policy "range-bw" is supported. This policy is developed by Dong-Jae
Kang, and it allows users to set a minimum and maximum I/O bandwidth
by absolute numbers. The minimum I/O bandwidth should be guaranteed
for stable performance or reliability of specific process groups, and
I/O bandwidth over the maximum limit should be throttled to protect
the limited I/O resource from over-provisioning in unnecessary usage
or to reserve the I/O bandwidth for another use.

Please visit our website for more information.
  http://sourceforge.net/apps/trac/ioband/wiki/dm-ioband

Any comments and suggestions are welcome!

Thanks,
Ryo Tsuruta
