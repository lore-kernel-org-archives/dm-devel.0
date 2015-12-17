From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 3/6] block: Optimize __blkdev_issue_zeroout()
Date: Thu, 17 Dec 2015 15:18:51 +0100
Message-ID: <5672C44B.4000105@sandisk.com>
References: <56729ECF.50906@sandisk.com> <56729F4D.5060105@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56729F4D.5060105@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Dmitry Monakhov <dmonakhov@openvz.org>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On 12/17/2015 12:41 PM, Bart Van Assche wrote:
> Avoid to confuse SCSI target software by ensuring that the WRITE SAME
> data buffer length matches the block size.

(replying to my own e-mail)

Please ignore this patch - it is wrong. Apparently my jet lag has not 
yet completely disappeared ...

Bart.
