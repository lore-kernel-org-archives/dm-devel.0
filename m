From: Bryan Gurney <bgurney@redhat.com>
Subject: [LSF/MM TOPIC] Bringing Virtual Data Optimizer (VDO) to upstream
Date: Mon, 29 Jan 2018 13:58:50 -0500
Message-ID: <CAHhmqcQWi12He=P1uMOopwVPS3RYgXa60joLK+w9j1fJQ3fOjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

I'd like to talk about Virtual Data Optimizer (VDO), which is a
device-mapper target that provides deduplication, compression, thin
provisioning, and zero-block elimination for primary storage.  Now
that VDO is open-source, LSF/MM would be a good time to open a
dialogue between other upstream developers as we work to bring VDO
upstream.

VDO was originally developed by Permabit Technology Corporation as a
proprietary set of kernel modules and userspace tools.  After being
acquired by Red Hat, VDO has been re-licensed under the GNU General
Public License, version 2.  The VDO team has also been working a lot
closer with Mike Snitzer and other developers of device-mapper and
LVM.

The source for VDO is available at the following repositories:

https://github.com/dm-vdo/kvdo (kernel modules)
https://github.com/dm-vdo/vdo (userspace tools)

As the README files in the repositories above indicate, development on
VDO is currently focusing on upstream integration, which includes
various coding standards compliance changes, refactoring efforts, and
various other changes that become possible now that VDO is re-licensed
under the GPL.

That being said, VDO has been in production use since 2014 in its
previous proprietary form, and continues to undergo thorough testing,
including real-world test scenarios.


Thanks,

Bryan
