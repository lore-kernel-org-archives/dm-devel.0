From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request
	handle	arbitrarily sized bios
Date: Tue, 26 May 2015 16:34:14 +0100
Message-ID: <20150526153414.GA31182@agk-dp.fab.redhat.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-2-git-send-email-mlin@kernel.org>
	<20150526143626.GA4315@redhat.com>
	<CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Lin <mlin@kernel.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@canonical.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kent.overstreet@gmail.com>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <dchinner@redhat.com>, Jens Axboe <axboe@kernel.dk>, Andreas Dilger <andreas.dilger@intel.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, lkml <linux-kernel@vger.kernel.org>, Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>, Dongsu Park <dpark@posteo.net>
List-Id: dm-devel.ids

On Tue, May 26, 2015 at 08:02:08AM -0700, Ming Lin wrote:
> Now bio_add_page() can build lager bios.
> And blk_queue_split() can split the bios in ->make_request() if needed.

But why not try to make the bio the right size in the first place so you
don't have to incur the performance impact of splitting?

What performance testing have you yet done to demonstrate the *actual* impact
of this patchset in situations where merge_bvec_fn is currently a net benefit?

Alasdair
