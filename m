From: Christoph Hellwig <hch@lst.de>
Subject: Re: [for-4.14 RFC PATCH 0/2] dm rq: eliminate historic blk-mq and
        .request_fn queue stacking restrictions
Date: Fri, 14 Jul 2017 09:12:57 +0200
Message-ID: <20170714071257.GB17046@lst.de>
References: <20170713211217.52361-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170713211217.52361-1-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

Btw, we might want to expedite this to 4.13, a 4.13 now defaults
to blk-mq for scsi, and this patch would make sure that dm keeps
on just working with that switch.
