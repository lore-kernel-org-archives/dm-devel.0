From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/18] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Wed, 25 Jan 2017 22:18:39 -0500
Message-ID: <yq11svqa4q8.fsf@oracle.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
        <1485365126-23210-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1485365126-23210-9-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Wed, 25 Jan 2017 18:25:16 +0100")
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> From: Hannes Reinecke <hare@suse.de> Switch to
Christoph> scsi_execute_req_flags() and scsi_get_vpd_page() instead of
Christoph> open-coding it.  Using scsi_execute_req_flags() will set
Christoph> REQ_QUIET and REQ_PREEMPT, but this is okay as we're
Christoph> evaluating the errors anyway and should be able to send the
Christoph> command even if the device is quiesced.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
