From: Christoph Hellwig <hch@lst.de>
Subject: dm fixes for 4.12-rc
Date: Mon, 15 May 2017 17:28:35 +0200
Message-ID: <20170515152839.23375-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Mike,

the first three patches sort out a few issues with how my dm cleanups and
the multipath fixes from Bart interacted.  The fourth is something I found
in an audit, it might or might not be worth to go into 4.12.  If not please
don't apply it yet as it will be needed as the baseline for some block work
I'll post in a few days.
