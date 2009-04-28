From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/3] scsi_dh: Make scsi_dh_activate asynchronous
Date: Mon, 27 Apr 2009 19:52:30 -0700
Message-ID: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, babu.moger@lsi.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>
List-Id: dm-devel.ids

Hello All,

Currently, device handlers process path activation in series. This leads
to a lot of time delay when more than 100 luns are involved. For example,
with lsi rdac 100+ luns take about 12-15 minutes. This was found by Moger
Babu of LSI.

This time delay can be avoided if we can do the activations asynchronously.
By making scsi_dh_activate() async, we can give the device handlers an
oppurtunity to decide on how to send the device activation down the wire
to make the turn around time faster. They can send the commands
asynchronously or send them in batches.

I brought up this issue on th emailing list few days back
(http://marc.info/?l=linux-scsi&m=123888063818755&w=2).

This set of patches applies cleanly on 2.6.30-rc3 and is tested on the same.

Please review and provide comments.

This set of patched adds asynchronous support only to rdac handler. WIll be
sending patches to support other handlers too.

Thanks & Regards,

chandra

