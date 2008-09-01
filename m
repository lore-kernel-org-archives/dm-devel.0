From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH #blk-for-2.8] init: DEBUG_BLOCK_EXT_DEVT requires explicit   root= param
Date: Mon, 1 Sep 2008 13:30:59 +0200
Message-ID: <20080901113059.GO20055@kernel.dk>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <200808292123.07246.bzolnier@gmail.com> <48B90E81.5060905@kernel.org> <200808311538.38918.bzolnier@gmail.com> <48BBCB62.4040309@kernel.org> <20080901111635.GN20055@kernel.dk> <48BBD01A.7000603@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48BBD01A.7000603@kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 01 2008, Tejun Heo wrote:
> Jens Axboe wrote:
> >> There are other ways to specify device numbers directly (ie. root=8:0)
> >> and DEBUG_BLOCK_EXT_DEVT being a debug option I don't think it
> >> warrants a complex logic, so I just added simple warning message.
> > 
> > How about just putting that in the help entry as well? Given that it's
> > now defaulting to 'n', people that enable it should read the help text
> > anyway.
> 
> I'll add that to help message but I still think it'll be beneficial to
> have warning message printed to avoid getting people off guard. e.g.
> alpha/beta distro built with the debug option turned on to detect bugs.

Honestly, those distros should not enable that option. But it's not a
big deal, if you send a patch with the Kconfig wording updated as well,
I'll add it.

-- 
Jens Axboe
