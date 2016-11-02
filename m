From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 09/60] dm: dm.c: replace 'bio->bi_vcnt == 1' with
 !bio_multiple_segments
Date: Tue, 1 Nov 2016 19:09:06 -0800
Message-ID: <20161102030906.22vwlv3ktp6l4bcy@kmo-pixel>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
 <1477728600-12938-10-git-send-email-tom.leiming@gmail.com>
 <20161031152901.GD30919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161031152901.GD30919@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Oct 31, 2016 at 08:29:01AM -0700, Christoph Hellwig wrote:
> On Sat, Oct 29, 2016 at 04:08:08PM +0800, Ming Lei wrote:
> > Avoid to access .bi_vcnt directly, because it may be not what
> > the driver expected any more after supporting multipage bvec.
> > 
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> 
> It would be really nice to have a comment in the code why it's
> even checking for multiple segments.

Or ideally refactor the code to not care about multiple segments at all.
