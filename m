From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: linux-next: Tree for August 27
Date: Sun, 31 Aug 2008 15:38:38 +0200
Message-ID: <200808311538.38918.bzolnier@gmail.com>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808292123.07246.bzolnier@gmail.com> <48B90E81.5060905@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <48B90E81.5060905@kernel.org>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Saturday 30 August 2008, Tejun Heo wrote:

[...]

> > Actually it seems that CONFIG_DEBUG_BLOCK_EXT_DEVT introduction (which I
> > think is a nice step forward) is a good oportunity to put the deprecation
> > of the default root device further, i.e. it may be worth to hook the
> > default root device check and/or CONFIG_DEBUG_BLOCK_EXT_DEVT one into
> > mount_block_root().
> 
> Maybe we can add a warning there if BLOCK_EXT_DEVT is enabled or do
> you have something else on mind?

Yes, this is would be nice, having warning on using the default root
device (instead of "root=") would be even nicer.

Thanks,
Bart
