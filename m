From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: check for kmalloc failure in
 dm_init_request_based_blk_mq_queue()
Date: Tue, 9 Feb 2016 10:08:17 -0500
Message-ID: <20160209150817.GA21685@redhat.com>
References: <20160209111440.GB23998@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160209111440.GB23998@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Feb 09 2016 at  6:14am -0500,
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We can just return -ENOMEM if the kzalloc() fails.
> 
> Fixes: 41b2facaf4ba ('dm: allocate blk_mq_tag_set rather than embed in mapped_device')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, folded in.
