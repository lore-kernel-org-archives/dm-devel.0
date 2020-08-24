From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 3/3] nvme: don't call revalidate_disk from
 nvme_set_queue_dying
Date: Mon, 24 Aug 2020 01:26:10 -0700
Message-ID: <b5422c22-7f68-e2a5-ec53-e1457d11f3ad@grimberg.me>
References: <20200823091043.2600261-1-hch@lst.de>
 <20200823091043.2600261-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200823091043.2600261-4-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-s390@vger.kernel.org, Jan Hoeppner <hoeppner@linux.ibm.com>, Justin Sanders <justin@coraid.com>, linux-nvme@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>, Xianting Tian <xianting_tian@126.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Stefan Haberland <sth@linux.ibm.com>, nbd@other.debian.org
List-Id: dm-devel.ids

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
