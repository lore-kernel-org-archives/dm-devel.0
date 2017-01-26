From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 18/18] block: don't assign cmd_flags in __blk_rq_prep_clone
Date: Wed, 25 Jan 2017 22:31:09 -0500
Message-ID: <yq137g68pky.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
        <1485365126-23210-19-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-19-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 25 Jan 2017 18:25:26 +0100")
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> These days we have the proper flags set since request
Christoph> allocation time.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
