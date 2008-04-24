From: KAIZUKA Hiroyuki <kaizuka@valinux.co.jp>
Subject: Utility tool for dm-ioband.
Date: Thu, 24 Apr 2008 20:55:27 +0900
Message-ID: <4810752F.30205@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, xen-devel@lists.xensource.com
Cc: agk@sourceware.org
List-Id: dm-devel.ids

Hi everyone,

I made a utility tool for dm-ioband version 0.0.4, named iobandctl.

It enables you to easily apply I/O bandwidth control to an entire disk,
and manage it. It helps you set the percentage of bandwidth
to give each partition, and each user, process, group, or cgroup.
(You are not able to use cgroup support yet, because the dm-ioband
patch to enable cgroup support (http://lwn.net/Articles/273802/)
is not ported to linux-2.6.25, but it will be soon.)

You can download it and find the manual at
http://people.valinux.co.jp/~kaizuka/dm-ioband/iobandctl/

This is a prototype code.
So, I'd like to hear your requests.
Feature fixed, it is going to be re-written in C.

Thanks,
KAIZUKA Hiroyuki
