From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Target and deduplication?
Date: Thu, 28 Jan 2016 00:50:13 -0800
Message-ID: <20160128085013.GA18023@infradead.org>
References: <CAKdSmgsZe_dfhN_7R6P7tLfkciv-9dUJKKNj16xeWYXG8aTVVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKdSmgsZe_dfhN_7R6P7tLfkciv-9dUJKKNj16xeWYXG8aTVVA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Henrik Goldman <hg@x-formation.com>
Cc: target-devel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 28, 2016 at 12:44:25AM +0100, Henrik Goldman wrote:
> Hello,
> 
> Has anyone (possibly except purestorage) managed to make target work
> with deduplication?

The iblock drivers works perfectly fine on top of the dm-dedup driver,
which unfortunately still hasn't made it to mainline despite looking
rather solid.

I'm pretty sure you can use the file driver on top of btrfs (and XFS
soon!) and use the non-inline dedup feature, but I haven't tried it.

> This means making a filesystem and using fileio to map to a disk image
> on the filesystem.
> ZFS is obviously another way to get the same but comes at a cost of
> large memory consumption.

Nevermind that you can ship or distribute the resulting product as the
ZFS licensing doesn't allow that.
