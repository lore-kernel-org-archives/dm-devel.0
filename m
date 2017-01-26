From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 15/16] block: split scsi_request out of struct request
Date: Thu, 26 Jan 2017 11:12:51 -0800
Message-ID: <455a58ef-905c-abf9-ae59-ca98f003f31e@sandisk.com>
References: <1485185361-29786-1-git-send-email-hch@lst.de>
 <1485185361-29786-16-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1485185361-29786-16-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 01/23/2017 07:29 AM, Christoph Hellwig wrote:
> +int scsi_cmd_buf_len(struct request *rq)
> +{
> +	return scsi_req(rq)->cmd_len * 3;
> +}
> +EXPORT_SYMBOL(scsi_cmd_buf_len);

Hello Christoph,

Where does the '* 3' come from? I think that deserves a comment.
Additionally, this patch introduces a new warning when building with W=1:

block/scsi_ioctl.c:761:5: warning: no previous prototype for
‘scsi_cmd_buf_len’ [-Wmissing-prototypes]

Please consider adding #include <linux/blktrace_api.h> to the source
file in which scsi_cmd_buf_len() is added.

Thanks,

Bart.
