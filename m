From: Guangliang Zhao <gzhao@suse.com>
Subject: [PATCH 0/3 v3] add resync speed control for dm-raid1
Date: Mon,  7 Jan 2013 18:02:10 +0800
Message-ID: <1357552933-26126-1-git-send-email-gzhao@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: lucienchao@gmail.com
List-Id: dm-devel.ids

Hi,

These patches are used to add resync speed control for dm-raid1. The
second and third patch provide support for user-space tool dmsetup.
I have made some modifications by the comments. This is the third
version.

Guangliang Zhao (3):
  dm raid1: add resync speed control for dm-raid1
  dm raid1: add interface to set resync speed
  dm raid1: add interface to get resync speed

 drivers/md/dm-raid1.c |   90 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 89 insertions(+), 1 deletion(-)

-- 
1.7.10.4
