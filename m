From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM TOPIC][LSF/MM ATTEND] multipath redesign
Date: Wed, 11 Jan 2017 10:44:08 +0100
Message-ID: <00700606-3005-c82b-ee37-127417fbd201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi all,

I'd like to attend LSF/MM this year, and would like to discuss a
redesign of the multipath handling.

With recent kernels we've got quite some functionality required for
multipathing already implemented, making some design decisions of the
original multipath-tools implementation quite pointless.

I'm working on a proof-of-concept implementation which just uses a
simple configfs interface and doesn't require a daemon altogether.

At LSF/MM I'd like to discuss how to move forward here, and whether we'd
like to stay with the current device-mapper integration or move away
from that towards a stand-alone implementation.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
