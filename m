From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/10] block: make generic_make_request handle
	arbitrarily sized bios
Date: Tue, 28 Apr 2015 13:43:20 +0200
Message-ID: <20150428114320.GA9790@lst.de>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org> <1430203717-13307-2-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1430203717-13307-2-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

This seems to lack support for QUEUE_FLAG_SG_GAPS to work around
the retarded PPR format in the NVMe driver.  I'm actually not
sure we have a way to reproduce them for BLOCK_PC requests, but I think
we should make sure to properly handle them.

Maybe Keith or Jens have a good reproducer for these.
