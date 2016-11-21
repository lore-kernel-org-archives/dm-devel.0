From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/12] dm: use bvec iterator helpers to implement
 .get_page and .next_page
Date: Mon, 21 Nov 2016 09:49:56 -0500
Message-ID: <20161121144956.GB23051@redhat.com>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
 <1478865957-25252-8-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478865957-25252-8-git-send-email-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, Nov 11 2016 at  7:05am -0500,
Ming Lei <tom.leiming@gmail.com> wrote:

> Firstly we have mature bvec/bio iterator helper for iterate each
> page in one bio, not necessary to reinvent a wheel to do that.
> 
> Secondly the coming multipage bvecs requires this patch.
> 
> Also add comments about the direct access to bvec table.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

I've staged this for 4.10
