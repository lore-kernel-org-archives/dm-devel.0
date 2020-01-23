From: Stefan Bader <stefan.bader@canonical.com>
Subject: [PATCH 0/1] Handle NULL make_request_fn in generic_make_request()
Date: Thu, 23 Jan 2020 11:17:12 +0200
Message-ID: <20200123091713.12623-1-stefan.bader@canonical.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tyler Hicks <tyler.hicks@canonical.com>
List-Id: dm-devel.ids

In ff36ab34583a "dm: remove request-based logic from make_request_fn wrapper",
device creation became a 2 stage process. In the first stage, the block
device is created which has a queue set up but no mapping function set.
This is done in the second stage, when the mapping table is supplied. At
that stage the device can become either multi-queue/request based or
doing the mapping on the bio level.

So right now, it is possible to crash the kernel by doing a
- dmsetup create --notable <name>
- mount /dev/dm-<minor> <somewhere>

While this may also need to be some fixing up in the device-
mapper codebase, it also should be handled from the block core as
allocating a queue can potentially be done separate from assigning a
mapping function.
There is already one check for not having set up a queue for a device,
so this just adds an additional check for make_request_fn being unset
before trying to further submit the requests.

-Stefan

Stefan Bader (1):
  blk/core: Gracefully handle unset make_request_fn

 block/blk-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.17.1
