From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Is it deliberate that the device mapper is not passing the DISCARD ioctls
Date: Mon, 20 Sep 2010 09:14:56 -0400
Message-ID: <E1OxgCu-0000XW-29@tytso-glaptop>
Return-path: <linux-ext4-owner@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
To: linux-ext4@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi there,

I was just testing discard support in mke2fs, and I was surprised that
although the dm layer appears to pass discard requests through to the
underlying block device driver when submitted through the bio layer
(i.e., from kernel file systems), apparently the discard ioctls (i.e.,
BLKDISCARD, BLKDISCARDSEC, BLKDISCARDZEROES) are not currently wired up
in the dm layer.

Is this deliberate, or an oversight?

Thanks, regards,

					- Ted
