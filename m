From: Milan Broz <mbroz@redhat.com>
Subject: clone() with CLONE_NEWNET breaks kobject_uevent_env()
Date: Thu, 18 Aug 2011 11:45:40 +0200
Message-ID: <4E4CDF44.5080109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>, "David S. Miller" <davem@davemloft.net>
List-Id: dm-devel.ids

Hi,

after analysing very strange report (with running chromium
some device-mapper ioctl functions started to fail) I found
interesting problem:

If you run clone() with CLONE_NEWNET (which is chromium using
for sanboxing), udev namespace is cloned too (newly registered
in uevent_sock_list) and netlink send (except the first in list)
fails with -ESRCH.

This causes that _every_ call of kobject_uevent_env() return failure.

Most of users silently ignores  kobject_uevent() return value,
so the problem was invisible for long time.

Unfortunately dm checks return value and reports failure,
taking the wrong error path.

How is this supposed to work?

Why cloning net namespace breaks the udev netlink subsystem?

Is it bug or we need to do something differently?
(I do not think ignoring return value is the proper way...)

Thanks,
Milan
