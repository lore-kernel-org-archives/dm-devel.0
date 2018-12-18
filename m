From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: give req_size precisely given by user
Date: Tue, 18 Dec 2018 14:47:09 -0500
Message-ID: <20181218194708.GA24676@redhat.com>
References: <20181218172537.12300-1-jaegeuk@kernel.org>
 <01a60138-63ab-6a9d-c0ba-b8fea551b14e@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01a60138-63ab-6a9d-c0ba-b8fea551b14e@kernel.dk>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Dec 18 2018 at 12:45pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 12/18/18 10:25 AM, Jaegeuk Kim wrote:
> > This patch makes dm be aware of io_pages to assign sane req_size for reads.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> 

I've applied this, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.21&id=c6d6e9b0f6b4201c77f2cea3964dd122697e3543
