From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 0 of 2] dm-raid: Bug fixes
Date: Mon, 16 Apr 2012 18:45:17 -0500
Message-ID: <1334619917.16017.25.camel@f14.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-raid@vger.kernel.org
Cc: agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Neil,

I have 3 bugs that I've been working on.  Two I have fixed and one I
have not, but have a question.

The first patch (dm-raid-set-recovery-flags-on-resume) addresses the
fact that some recovery flags are altered during suspend, but not
corrected upon resume.  I'm wondering if you think these flags would be
better pushed into 'mddev_resume' rather that being altered in
dm-raid.c?

The second patch (dm-raid-record-and-handle-missing-devices) adds code
to address the case where the user specifies particular array positions
as missing.  I don't have any significant questions about this patch.

The 3rd issue I am seeing concerns how 'suspend' happens.  Suspend
should flush all outstanding I/O and quiesce.  When I look at the code,
I feel it should be doing this.  ('md_stop_writes' is called and
followed-up by a call to 'mddev_suspend', which quiesces the
personality.)  However, if I create a RAID1 device, suspend it, and then
detach one of the legs, it does not show the changes written immediately
before the suspend.  If I issue a 'sync', then the changes do show-up.
I confused as to why the suspend process doesn't seem to be pushing out
the writes that have been issued.  Any ideas?

Thanks, (the first two patches follow)
 brassow


