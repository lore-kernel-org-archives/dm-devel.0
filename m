From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/13] dax, pmem: move cpu cache maintenance to
        libnvdimm
Date: Mon, 23 Jan 2017 17:00:09 +0100
Message-ID: <20170123160009.GB517@lst.de>
References: <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com> <20170121175212.GA28180@lst.de> <BY2PR21MB00367799FE7B7E8302A99260CB730@BY2PR21MB0036.namprd21.prod.outlook.com> <20170122162910.GA5267@lst.de> <BY2PR21MB00368E95CBB533D4C761C882CB730@BY2PR21MB0036.namprd21.prod.outlook.com> <20170122183046.GA7359@lst.de> <BY2PR21MB0036CC7935BFE438EA001763CB730@BY2PR21MB0036.namprd21.prod.outlook.com> <20170122184439.GA7603@lst.de> <BY2PR21MB0036CA85562DDD21814C0B27CB720@BY2PR21MB0036.namprd21.prod.outlook.com> <CAPcyv4h83wk5SGVPY+8nUZ1e4Gq9fz61GE3BhAdzGi=HFAuDcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4h83wk5SGVPY+8nUZ1e4Gq9fz61GE3BhAdzGi=HFAuDcg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: dm-devel.ids

On Sun, Jan 22, 2017 at 11:10:04PM -0800, Dan Williams wrote:
> How about we solve the copy_from_user() abuse first before we hijack
> this thread for some future feature that afaics has no patches posted
> yet.

Solving copy_from_user abuse first sounds perfectly fine to me.  But
please do so without abusing the block layer for persistent memory
access.  Given that we don't have use cases for different pmem access
methods in a single OS image yet let's avoid introducing new ops
for now and just remove the copy_from_user abuse.

In the longer run I like your dax_operations, but they need to be
separate from the block layer.
