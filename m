From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 0/3] block: allow REQ_NOWAIT to some bio-based/stacked
 devices
Date: Mon, 01 Jun 2020 15:37:01 +0300
Message-ID: <159101473169.180989.12175693728191972447.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

Here is pretty straight forward attempt of handling REQ_NOWAIT for
bio-based and stacked devices.

They are marked with flag queue->limits.nowait_requests which tells that
queue method make_request() handles REQ_NOWAIT or doesn't delay requests,
and all backend devices do the same.

As a example second/third patches add support into md-raid0 and dm-linear.

---

Konstantin Khlebnikov (3):
      block: add flag 'nowait_requests' into queue limits
      md/raid0: enable REQ_NOWAIT
      dm: add support for REQ_NOWAIT and enable for target dm-linear


 drivers/md/dm-linear.c        | 5 +++--
 drivers/md/dm-table.c         | 3 +++
 drivers/md/dm.c               | 4 +++-
 drivers/md/raid0.c            | 3 +++
 include/linux/device-mapper.h | 6 ++++++
 5 files changed, 18 insertions(+), 3 deletions(-)

--
Signature
