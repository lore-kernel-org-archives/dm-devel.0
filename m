From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 01/10] block: make generic_make_request handle	arbitrarily
 sized bios
Date: Tue, 28 Apr 2015 16:01:26 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1504281546340.19844@localhost.lm.intel.com>
References: <1430203717-13307-1-git-send-email-mlin@kernel.org> <1430203717-13307-2-git-send-email-mlin@kernel.org> <20150428114320.GA9790@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150428114320.GA9790@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

On Tue, 28 Apr 2015, Christoph Hellwig wrote:
> This seems to lack support for QUEUE_FLAG_SG_GAPS to work around
> the retarded PPR format in the NVMe driver.

Might strong words, sir! I'm missing the context here, but I'll say PRP
is much more efficient for h/w to process over SGL, and the requirement
comes from that h/w rather than the driver.
