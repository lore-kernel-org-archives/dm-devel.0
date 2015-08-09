From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH v5 01/11] block: make generic_make_request
 handle arbitrarily sized bios
Date: Sat, 8 Aug 2015 23:41:28 -0700
Message-ID: <20150809064128.GB2436@infradead.org>
References: <1436168690-32102-1-git-send-email-mlin@kernel.org>
 <20150731192337.GA8907@redhat.com>
 <CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com>
 <20150731213831.GA16464@redhat.com>
 <1438412290.26596.14.camel@hasee>
 <20150801163356.GA21478@redhat.com>
 <yq18u9liwhj.fsf@sermon.lab.mkp.net>
 <1439099990.7880.0.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439099990.7880.0.camel@hasee>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Ming Lei <ming.lei@canonical.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kent.overstreet@gmail.com>, Nitin Gupta <ngupta@vflare.org>, Ming Lin <ming.l@ssi.samsung.com>, Oleg Drokin <oleg.drokin@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Andreas Dilger <andreas.dilger@intel.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, lkml <linux-kernel@vger.kernel.org>, Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>, Dongsu Park <dpark@posteo.net>, drbd-user@list
List-Id: dm-devel.ids

On Sat, Aug 08, 2015 at 10:59:50PM -0700, Ming Lin wrote:
> +/*
> + * Ensure that max discard sectors doesn't overflow bi_size and hopefully
> + * it is of the proper granularity as long as the granularity is a power
> + * of two.
> + */
> +#define MAX_DISCARD_SECTORS ((1U << 31) >> 9)

Thisn't isn't MAX_DISCARD_SECTORS, it's MAX_BIO_SECTORS.  If we ever
to something like Kent's multipage biovecs we'll actually need it for
regular read/write bios in addition to discard and write same.

Except for that the patch looks reasonable to me.
