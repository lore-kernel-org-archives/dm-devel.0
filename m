From: Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH v4 01/11] block: make generic_make_request
	handle arbitrarily sized bios
Date: Wed, 27 May 2015 10:20:18 +0200
Message-ID: <20150527082018.GB25575@lst.de>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org> <1432318723-18829-2-git-send-email-mlin@kernel.org> <20150526143626.GA4315@redhat.com> <CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com> <20150526153414.GA31182@agk-dp.fab.redhat.com> <20150527090640.44c346e2@notabene.brown> <20150527004022.GD31182@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150527004022.GD31182@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@canonical.com>, Al@redhat.com, Christoph Hellwig <hch@lst.de>, Lars Ellenberg <drbd-dev@lists.linbit.com>, Oleg@redhat.com, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Kent@redhat.com, Overstreet <kent.overstreet@gmail.com>, Nitin Gupta <ngupta@vflare.org>, Drokin <oleg.drokin@intel.com>, Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>, Ming Lin <mlin@kernel.org>, Jens Axboe <axboe@kernel.dk>, Andreas Dilger <andreas.dilger@intel.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, lkml <linux-kernel@vger.kernel.org>, Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>, Dongsu Park <dpark@posteo.net>
List-Id: dm-devel.ids

On Wed, May 27, 2015 at 01:40:22AM +0100, Alasdair G Kergon wrote:
> It does sometimes make a significant difference to device-mapper stacks.
> DM only uses it for performance reasons - it can already split bios when
> it needs to.  I tried to remove merge_bvec_fn from DM several years ago but
> couldn't because of the adverse performance impact of lots of splitting activity.

Does it still?  Since the move to immutable biovecs the bio splits are
pretty cheap now, but I'd really like to see this verified by benchmarks.
