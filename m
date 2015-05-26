From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Tue, 26 May 2015 10:36:26 -0400
Message-ID: <20150526143626.GA4315@redhat.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
 <1432318723-18829-2-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432318723-18829-2-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On Fri, May 22 2015 at  2:18pm -0400,
Ming Lin <mlin@kernel.org> wrote:

> From: Kent Overstreet <kent.overstreet@gmail.com>
> 
> The way the block layer is currently written, it goes to great lengths
> to avoid having to split bios; upper layer code (such as bio_add_page())
> checks what the underlying device can handle and tries to always create
> bios that don't need to be split.
> 
> But this approach becomes unwieldy and eventually breaks down with
> stacked devices and devices with dynamic limits, and it adds a lot of
> complexity. If the block layer could split bios as needed, we could
> eliminate a lot of complexity elsewhere - particularly in stacked
> drivers. Code that creates bios can then create whatever size bios are
> convenient, and more importantly stacked drivers don't have to deal with
> both their own bio size limitations and the limitations of the
> (potentially multiple) devices underneath them.  In the future this will
> let us delete merge_bvec_fn and a bunch of other code.

This series doesn't take any steps to train upper layers
(e.g. filesystems) to size their bios larger (which is defined as
"whatever size bios are convenient" above).

bio_add_page(), and merge_bvec_fn, served as the means for upper layers
(and direct IO) to build up optimally sized bios.  Without a replacement
(that I can see anyway) how is this patchset making forward progress
(getting Acks, etc)!?

I like the idea of reduced complexity associated with these late bio
splitting changes I'm just not seeing how this is ready given there are
no upper layer changes that speak to building larger bios..

What am I missing?

Please advise, thanks!
Mike
