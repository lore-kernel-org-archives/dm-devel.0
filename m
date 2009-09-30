From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/4] scsi_dh: Make scsi_dh_activate asynchronous
Date: Tue, 29 Sep 2009 19:08:11 -0700
Message-ID: <20090930020811.11455.59565.sendpatchset@chandra-ubuntu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, babu.moger@lsi.com, michaelc@cs.wisc.edu, Benoit_Arthur@emc.com, Eddie.Williams@steeleye.com, berthiaume_wayne@emc.com, Chandra Seetharaman <sekharan@us.ibm.com>
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

I brought up this issue on the mailing list
(http://marc.info/?l=linux-scsi&m=123888063818755&w=2) and provided a
set of patch a loooong while back http://marc.info/?l=linux-scsi&m=124088712709821&w=2

This set of patches applies cleanly on 2.6.31 and I tested the rdac handler
on the same.

Please review and provide comments.

This set of patched adds asynchronous support for rdac, hp, and alua handlers.

Didn't add async support for EMC for the following reasons:
 - EMC handler is getting more hairy (when I try to move to _nowait())
 - I do not know if EMC has a special command to group them (like rdac).
 - I wasn't sure if EMC has this problem in the first place ( I did not get
   any response from EMC).
Can somebody from EMC comment, please.

Thanks & Regards,

chandra

