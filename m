From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH 12/15] block: merge blk_types.h into bio.h
Date: Fri, 19 May 2017 10:22:44 +0200
Message-ID: <20170519082244.GC1411@lst.de>
References: <20170518131812.22956-1-hch@lst.de> <20170518131812.22956-13-hch@lst.de> <1495117551.2713.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495117551.2713.1.camel@sandisk.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, May 18, 2017 at 02:25:52PM +0000, Bart Van Assche wrote:
> On Thu, 2017-05-18 at 15:18 +0200, Christoph Hellwig wrote:
> > We've cleaned up our headers sufficiently that we don't need this split
> > anymore.
> 
> Hello Christoph,
> 
> Request-based drivers need the structure definitions from <linux/blkdev.h> and
> the type definitions from <linux/blk_types.h> but do not need the definition of
> struct bio. Have you considered to remove #include <linux/bio.h> from file
> include/linux/blkdev.h? Do you think that would help to reduce the kernel build
> time?

Most block drivers end up needing bio.h anyway.  But I can skip this
part of the series for now.
