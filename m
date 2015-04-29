From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH -stable] block: destroy bdi before blockdev is
	unregistered.
Date: Wed, 29 Apr 2015 15:35:12 +0200
Message-ID: <20150429133512.GA4436@lst.de>
References: <20150414171537.GH25394@azat> <20150423160551.45345f96@notabene.brown> <20150427141222.5dac22f1@notabene.brown> <CAMM=eLf2aFFH29xeDVrS7beFj6T8kqUQRh=4KB1YO0kWGa7Rog@mail.gmail.com> <20150429072530.39d38b00@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150429072530.39d38b00@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>, Azat Khuzhin <a3at.mail@gmail.com>, Christoph Hellwig <hch@lst.de>, "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>, Guoqing Jiang <GQJiang@suse.com>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: dm-devel.ids

On Wed, Apr 29, 2015 at 07:25:30AM +1000, NeilBrown wrote:
> As bdi_set_min_ratio doesn't touch bdi->dev, there seems to be no need for
> the test, or the warning.
> 
> I wonder if it would make sense to move the bdi_set_min_ratio() call to
> bdi_destroy, and discard bdi_unregister??
> There is a comment which suggests bdi_unregister might be of use later, but
> it might be best to have a clean slate in which to add whatever might be
> needed??

This seems fine to me from the block dev point of view.  I don't really
understand the bdi_min_ratio logic, but Peter might have a better idea.
