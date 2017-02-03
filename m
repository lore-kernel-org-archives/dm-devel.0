From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] dm: don't allow ioctls to targets that don't map to whole
 devices
Date: Fri, 3 Feb 2017 11:10:10 +0100
Message-ID: <60c7f620-403c-5ec2-ae9f-e99676410b38@suse.de>
References: <20170203100613.9023-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170203100613.9023-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, snitzer@redhat.com
Cc: agk@redhat.com, pbonzini@redhat.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 02/03/2017 11:06 AM, Christoph Hellwig wrote:
> .. at least for unprivilegued users.  Before we called into the SCSI
> ioctl code to allow excemptions for a few SCSI passthrough ioctls,
> but this is pretty unsafe and except for this call dm knows nothing
> about SCSI ioctls.  As SCSI the SCSI ioctl code is made optionally
                                              ^~ duped SCSI or should it 
read "as in SCSI the SCSI ioctl code [...]"

> now we really don't want to drag it in for DM, and the exception is
> not very useful anyway.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Note: this should go into the block tree, as that's where
> scsi_verify_blk_ioctl becomes optional.
>
> ---
Rest looks OK to me,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

