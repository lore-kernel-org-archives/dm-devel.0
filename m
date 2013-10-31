From: Kent Overstreet <kmo@daterainc.com>
Subject: Re: [PATCH] Btrfs: update bi_remaining to relfect our bio endio
 chaining
Date: Thu, 31 Oct 2013 12:57:15 -0700
Message-ID: <20131031195715.GC27129@kmo>
References: <20131031193820.10239.79827@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131031193820.10239.79827@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chris Mason <chris.mason@fusionio.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Thu, Oct 31, 2013 at 03:38:20PM -0400, Chris Mason wrote:
> Btrfs is sometimes calling bio_endio twice on the same bio while
> we chain things.  This makes sure we don't trip over new assertions in
> fs/bio.c
> 
> Signed-off-by: Chris Mason <chris.mason@fusionio.com>

Beat me to it :P

Tested-by: Kent Overstreet <kmo@daterainc.com>
