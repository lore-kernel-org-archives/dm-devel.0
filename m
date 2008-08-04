From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 0/7] I/O bandwidth controller and BIO tracking
Date: Mon, 04 Aug 2008 17:51:26 +0900 (JST)
Message-ID: <20080804.175126.193692178.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753789AbYHDIvg@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: agk@sourceware.org
List-Id: dm-devel.ids

Hi everyone,

This series of patches of dm-ioband now includes "The bio tracking mechanism,"
which has been posted individually to this mailing list.
This makes it easy for anybody to control the I/O bandwidth even when
the I/O is one of delayed-write requests.
Have fun!

This series of patches consists of two parts:
  1. dm-ioband
    Dm-ioband is an I/O bandwidth controller implemented as a
    device-mapper driver, which gives specified bandwidth to each job
    running on the same physical device. A job is a group of processes
    with the same pid or pgrp or uid or a virtual machine such as KVM
    or Xen. A job can also be a cgroup by applying the bio-cgroup patch.
  2. bio-cgroup
    Bio-cgroup is a BIO tracking mechanism, which is implemented on
    the cgroup memory subsystem. With the mechanism, it is able to
    determine which cgroup each of bio belongs to, even when the bio
    is one of delayed-write requests issued from a kernel thread
    such as pdflush.

The above two parts have been posted individually to this mailing list
until now, but after this time we would release them all together.

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
