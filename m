From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/2] Two fixes for device-mapper with REQ_OP_ZONE_APPEND
Date: Fri, 19 Jun 2020 15:59:03 +0900
Message-ID: <20200619065905.22228-1-johannes.thumshirn@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>
List-Id: dm-devel.ids

Two small fixes for issuing REQ_OP_ZONE_APPEND writes to device-mapper. The
first one is an issue reported by Naohiro and fixes a write failure. For
number two I'm not certain if it's the correct fix, hence the RFC tag.

Johannes Thumshirn (2):
  dm: update original bio sector on Zone Append
  dm: don't try to split REQ_OP_ZONE_APPEND bios

 drivers/md/dm.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

-- 
2.26.2
