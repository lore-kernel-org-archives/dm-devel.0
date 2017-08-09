From: Christoph Hellwig <hch@lst.de>
Subject: integrity regression fixes for 4.13-rc
Date: Wed,  9 Aug 2017 17:47:25 +0200
Message-ID: <20170809154727.2085-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: mpatocka@redhat.com, gmazyland@gmail.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Jens,

this series fixes regressions in the integrity handling update in 4.13-rc.

The first one was sent earlier by Milan and while both Martin and I aren't
exactly happy about the way dm uses the integrity code to cause this
regression this minimal fix gets us back to the status quo.

The second one makes sure that we only verify the DIF checksums on the
lowest layer where we attach the integrity information.
