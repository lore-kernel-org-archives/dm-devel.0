From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 01/11] block: make generic_make_request handle
	arbitrarily sized bios
Date: Tue, 4 Aug 2015 13:36:26 +0200
Message-ID: <20150804113626.GA12682@lst.de>
References: <1436168690-32102-1-git-send-email-mlin@kernel.org> <20150731192337.GA8907@redhat.com> <CAF1ivSZbMDgyo_-wFGusSNSZ1fonSMWmNU9aVavGFaQsmEyYmQ@mail.gmail.com> <20150731213831.GA16464@redhat.com> <1438412290.26596.14.camel@hasee> <20150801163356.GA21478@redhat.com> <1438581502.26596.24.camel@hasee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438581502.26596.24.camel@hasee>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Ming Lin <ming.l@ssi.samsung.com>
List-Id: dm-devel.ids

On Sun, Aug 02, 2015 at 10:58:22PM -0700, Ming Lin wrote:
> I think the important thing is the late splitting for regular bio.
> For discard/write_same bio, how about just don't do late splitting?

I'd hate having to special case them even more.  Especially as the
discard splitting is nasty and we really don't want to send giant
discards by default anyway (see Jens' patches to limit discard size
by default).

So I'd recommend to keep everything as-is, just make sure we don't
overflow bi_size.
