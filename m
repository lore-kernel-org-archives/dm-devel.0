From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/13] dax, pmem: move cpu cache maintenance to
        libnvdimm
Date: Sun, 22 Jan 2017 19:30:46 +0100
Message-ID: <20170122183046.GA7359@lst.de>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com> <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com> <20170121175212.GA28180@lst.de> <BY2PR21MB00367799FE7B7E8302A99260CB730@BY2PR21MB0036.namprd21.prod.outlook.com> <20170122162910.GA5267@lst.de> <BY2PR21MB00368E95CBB533D4C761C882CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BY2PR21MB00368E95CBB533D4C761C882CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Brian Boylston <brian.boylston@hpe.com>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ross
List-Id: dm-devel.ids

On Sun, Jan 22, 2017 at 06:19:24PM +0000, Matthew Wilcox wrote:
> No, I mean a network filesystem like 9p or cifs or nfs.  If the memcpy
> is supposed to be performed by the backing device

struct backing_dev has no relation to the DAX code.  Even more so what's
the point of doing a DAXish memcpy in that case?  If we buffer in
memory for network I/O we should just use the page cache.

> (Also, the network filesystem might have a command, like RDMA has/will have, to ensure that the write has reached persistence)

I know very well due to my work for a DAX-backed pNFS layout.  But that
is mostly transparent to the NFS frontend code and won't use DAX
on the client at all.  Just pagecache as a source for RDMA READ/WRITE.
