From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v2] Fix fallout from changes to FUA and PREFLUSH definitions
Date: Wed, 31 May 2017 09:44:31 +0200
Message-ID: <20170531074433.14298-1-jack@suse.cz>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

here are patches for DM/MD that address a possible performance issue caused by
commit b685d3d65ac7 "block: treat REQ_FUA and REQ_PREFLUSH as synchronous".

The core of the problem is that above mentioned commit removed REQ_SYNC flag
from WRITE_{FUA|PREFLUSH|...} definitions.  generic_make_request_checks()
however strips REQ_FUA and REQ_PREFLUSH flags from a bio when the storage
doesn't report volatile write cache and thus write effectively becomes
asynchronous which can lead to performance regressions.

DM/MD guys, can you please have a look at patches and take them through your
trees? Thanks!

								Honza
