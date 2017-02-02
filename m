From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next: Tree for Feb 2 (drivers/md/dm.c)
Date: Thu, 2 Feb 2017 13:29:16 -0500
Message-ID: <20170202182916.GA26910@redhat.com>
References: <20170202182117.73e354f1@canb.auug.org.au>
 <8a8224e7-4c90-7fa7-9960-fc04fe658014@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8a8224e7-4c90-7fa7-9960-fc04fe658014@infradead.org>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, dm <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>, hch@infradead.org
List-Id: dm-devel.ids

On Thu, Feb 02 2017 at 12:58pm -0500,
Randy Dunlap <rdunlap@infradead.org> wrote:

> On 02/01/17 23:21, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20170201:
> > 
> 
> on x86_64:
> 
> drivers/built-in.o: In function `dm_blk_ioctl':
> dm.c:(.text+0x1a5121): undefined reference to `scsi_verify_blk_ioctl'

Are you trying to say that this happens using a certain .config?

Also, not sure why you didn't cc Christoph (or Jens) seeing as these
changes are _not_ staged in linux-next by linux-dm.git.
