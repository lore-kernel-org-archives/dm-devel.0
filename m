From: Michael Leun <ml@newton.leun.net>
Subject: Bisected: Massive memory leak in dm-snapshot in 3.1 development
 introduced
Date: Sun, 23 Oct 2011 11:21:40 +0200
Message-ID: <20111023112140.37fd8b3d@xenia.leun.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Hi,

How to reproduce:

lvcreate -L30G -n testsnap vg1 # of course substitute VG as appropriate
dd if=/dev/zero of=/dev/vg1/testsnap bs=2M # to make things clear
lvcreate -L15G -s /dev/vg1/test -n testsnap
dd if=/dev/zero of=/dev/vg1/testsnap bs=2M &
watch free

I noticed roughly 1GB memory vanishing from free / -/+ buffers/cache
per 2GB copied.

Bisecting yielded a6e50b409d3f9e0833e69c3c9cca822e8fa4adbb, reverting
that from git master cures the memory leak

-- 
MfG,

Michael Leun
