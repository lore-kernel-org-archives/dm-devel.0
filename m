From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 4] dm-raid: various bug fixes
Date: Tue, 17 Apr 2012 21:30:19 -0500
Message-ID: <1334716219.23908.14.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Neil,

I've cleaned up the first two patches I sent earlier:
	[1 of 5] dm-raid-set-recovery-flags-on-resume.patch
	[2 of 5] dm-raid-record-and-handle-missing-devices.patch
and added a couple more:
	[3 of 5] dm-raid-need-safe-version-of-rdev_for_each.patch
	[4 of 5] dm-raid-use-md_error-in-place-of-faulty-bit.patch
	[5 of 5] md-raid1-further-conditionalize-fullsync.patch

Patch [5 of 5] I think needs some work.  It fixes the problem I'm seeing
and seems to go along with similar logic used for RAID5 in commit
d6b212f4b19da5301e6b6eca562e5c7a2a6e8c8d.  It also seems like a workable
solution based on the code surrounding commit
d30519fc59c5cc2f7772fa67b16b1a2426d36c95.  Can you let me know if I'm
stretching the usage of 'saved_raid_disk' too far?

Thanks,
 brassow

