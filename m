From: Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 0/2] block: fix flush regression introduced in 3.1-rc3
Date: Wed, 12 Oct 2011 17:22:40 -0400
Message-ID: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: tj@kernel.org, christophe@saout.de, dm-devel@redhat.com, msnitzer@redhat.com
List-Id: dm-devel.ids

Hi,

This patch series fixes a regression introduced by commit
4853abaae7e4a2af938115ce9071ef8684fb7af4.  I've tested that this solves
the problem when dm-mpath is backed by devices that require a write
cache flush.  I've also ensured that this does not reintroduce the
performance problems that the original fix solved.

Cheers,
Jeff
