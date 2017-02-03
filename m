From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] dm: don't allow ioctls to targets that don't map to
        whole devices
Date: Fri, 3 Feb 2017 11:34:43 +0100
Message-ID: <20170203103443.GA29497@lst.de>
References: <20170203100613.9023-1-hch@lst.de> <60c7f620-403c-5ec2-ae9f-e99676410b38@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <60c7f620-403c-5ec2-ae9f-e99676410b38@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, snitzer@redhat.com, agk@redhat.com, pbonzini@redhat.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 03, 2017 at 11:10:10AM +0100, Johannes Thumshirn wrote:
> On 02/03/2017 11:06 AM, Christoph Hellwig wrote:
>> .. at least for unprivilegued users.  Before we called into the SCSI
>> ioctl code to allow excemptions for a few SCSI passthrough ioctls,
>> but this is pretty unsafe and except for this call dm knows nothing
>> about SCSI ioctls.  As SCSI the SCSI ioctl code is made optionally
>                                              ^~ duped SCSI or should it 
> read "as in SCSI the SCSI ioctl code [...]"

Yeah, thanks.
