From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [BUG] kernel 2.6.32.x hangs during boot process
Date: Thu, 28 Jan 2010 13:25:28 -0500
Message-ID: <20100128182528.GA29926@infradead.org>
References: <d2deb3241001160158r4baed1e1t7e8f6642de018b4c@mail.gmail.com> <20100122160740.6c16c22d.akpm@linux-foundation.org> <20100128134205.352044bd@notabene> <4B612F89.7020503@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B612F89.7020503@ce.jp.nec.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Fran?ois Figarola <francois.figarola@i-consult.fr>, hch@infradead.org, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: dm-devel.ids

On Thu, Jan 28, 2010 at 03:32:41PM +0900, Jun'ichi Nomura wrote:
> When MS_RDONLY, both freeze_bdev and thaw_bdev call deactivate_locked_super,
> which seems wrong. The change was introduced with the commit below:
> 
>   commit 4504230a71566785a05d3e6b53fa1ee071b864eb
>   Author: Christoph Hellwig <hch@lst.de>
>   Date:   Mon Aug 3 23:28:35 2009 +0200
> 
>   freeze_bdev: grab active reference to frozen superblocks
> 
> With the attached patch, both remount-ro and remount-rw are
> rejected as EBUSY on freezed device as expected.
> 
> Christoph, do you think this is the right fix?

Indeed, this looks wrong in my original code, and the patch looks like
the correct fix.  Thanks a lot!


Reviewed-by: Christoph Hellwig <hch@lst.de>

