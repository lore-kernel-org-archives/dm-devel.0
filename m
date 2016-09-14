From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 0/3] block: Improve bio_set_op_attrs() robustness
Date: Wed, 14 Sep 2016 08:48:50 -0600
Message-ID: <7b465fd4-fd31-1561-239d-d0215b6557ea@fb.com>
References: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <35e3cdd6-8983-6c84-cb4c-9a7be15aea55@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Mike Christie <mchristi@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@hgst.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, linux-btrfs@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 09/14/2016 02:42 AM, Bart Van Assche wrote:
> Hi Jens,
>
> bio_set_op_attrs() does not yet check whether the "op_flags" field
> overflows into the "op" field. Since adding support for SMR requires to
> introduce more REQ_* flags I think it is important to have such a check.
> Hence this patch series. Please consider these patches for inclusion in
> the upstream Linux kernel.

Thanks Bart, I like this series. Applied for 4.9.

-- 
Jens Axboe

