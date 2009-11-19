From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 0/2] Update command result handling
Date: Thu, 19 Nov 2009 13:24:49 +0100
Message-ID: <20091119122449.D13B93A085@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids


Currently we're updating the request result upon completion
only for BLK_PC requests. This makes it impossible for the
upper layers to reliable detect the real cause for an
I/O failure. By attaching the result and the sense to all
requests we can update multipathing to make some more elaborate
choices on how to handle I/O errors.
This also solves a potential data corruption with multipathing
and persistent reservations. When queue_if_no_path is active
multipath will queue any I/O failure (including those failed
with RESERVATION CONFLICT) until the reservation status changes.
But by then I/O might have been ongoing on the other paths,
thus the delayed submission will severely corrupt your data.

Signed-off-by: Hannes Reinecke <hare@suse.de>
