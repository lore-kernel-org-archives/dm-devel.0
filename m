From: Christoph Hellwig <hch@lst.de>
Subject: PR API fixes for multipathing
Date: Fri,  8 Jul 2016 21:23:49 +0900
Message-ID: <1467980631-18945-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

I was a bit overeager to thing ALL_TG_PT would solve all our multipathing
woes in respect to persistent reservation.  Turns out that there are
lots of possible setups where it doesn't work, and we'll have to ask
device mapper to register all underlying devices instead.

