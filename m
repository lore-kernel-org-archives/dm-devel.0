From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: SCSI Hardware Handler and slow failover with large number of LUNS
Date: Sat, 04 Apr 2009 14:30:36 -0700
Message-ID: <1238880636.11478.8.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: dm-devel <dm-devel@redhat.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

Hello All,

During testing with the latest SCSI DH Handler on a rdac storage, Babu
found that the failover time with 100+ luns takes about 15 minutes,
which is not good.

We found that the problem is due to the fact that we serialize activate
in dm on the work queue.

We can solve the problem in rdac handler in 2 ways
 1. batch up the activates (mode_selects) and send few of them.
 2. Do mode selects in async mode.

Just wondering if anybody had seen the same problem in other storages
(EMC, HP and Alua). 

Please share your experiences, so we can come up with a solution that
works for all hardware handlers.

regards,

chandra

