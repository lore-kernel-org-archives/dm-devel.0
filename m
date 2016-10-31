From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 09/60] dm: dm.c: replace 'bio->bi_vcnt == 1' with !bio_multiple_segments
Date: Tue, 1 Nov 2016 06:59:52 +0800
Message-ID: <CACVXFVOBUBqZ4VZk=STsk+NeLshcid2_a494_mEg7O7JwAphpg@mail.gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
 <1477728600-12938-10-git-send-email-tom.leiming@gmail.com> <20161031152901.GD30919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161031152901.GD30919@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Mon, Oct 31, 2016 at 11:29 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Oct 29, 2016 at 04:08:08PM +0800, Ming Lei wrote:
>> Avoid to access .bi_vcnt directly, because it may be not what
>> the driver expected any more after supporting multipage bvec.
>>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>
> It would be really nice to have a comment in the code why it's
> even checking for multiple segments.
>

OK, will add comment about using !bio_multiple_segments(rq->bio)
to replace 'rq->bio->bi_vcnt == 1'.


Thanks,
Ming Lei
