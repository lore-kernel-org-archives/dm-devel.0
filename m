From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [dm-devel] [PATCH] Fix over-zealous flush_disk when changing
 device size.
Date: Mon, 07 Mar 2011 10:46:58 -0600
Message-ID: <1299516418.15258.4.camel@mulgrave.site>
References: <20110217165057.5c50e566@notabene.brown>
	 <20110303143120.GA8134@infradead.org>
	 <20110304111624.4be27aaf@notabene.brown> <1299259506.2118.24.camel@grinch>
	 <20110306174755.49404c8e@notabene.brown>  <1299471771.2228.11.camel@grinch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1299471771.2228.11.camel@grinch>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: NeilBrown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Sun, 2011-03-06 at 21:22 -0700, Andrew Patterson wrote:
> On Sun, 2011-03-06 at 17:47 +1100, NeilBrown wrote:
> >  Would you be uncomfortable if I asked Linus to revert both my fix and your
> >  original patch??
> 
> James Bottomley wanted me to put this functionality in. I have no
> problem with reverting it myself, especially if it is causing other
> problems.  I would have to say that you need to ask him (or rather, I am
> not qualified to render an opinion here).

So it seems we have a couple of problems: the first being that
flush_disk() doesn't actually do what it says (flush the disk).  If it's
just discarding all data, dirty or clean, then its use in the
grow/shrink interface is definitely wrong.

The idea is that before we complete the grow/shrink, we make sure that
the device doesn't have any errors, so we want to try to write out all
dirty buffers to make sure they still have a home.  If flush_disk()
doesn't do that, then we need to use a different interface ... what's
the interface to flush a disk?

James
