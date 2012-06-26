From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 5] MD:  prepare RAID10 for inclusion in dm-raid.c
Date: Tue, 26 Jun 2012 03:44:19 -0500
Message-ID: <1340700259.19015.10.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dm-devel@redhat.com
Cc: jbrassow@redhat.com, neilb@suse.de, agk@redhat.com
List-Id: dm-devel.ids

Neil,

Here's a couple patches that are necessary for MD before I can add
RAID10 to the list of supported personalities through dm-raid.c:
	1) md-raid10-rename-mirror_info.patch
	2) md-raid1-rename-mirror_info.patch
	3) md-move-IO_BLOCKED-to-md_h.patch
	4) md-export-md_raid10_congested.patch

I'll send the patch that enables raid10 as a separate patch that depends
on this patch set and a couple of DM patches.

 brassow


