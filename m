From: Chris Mason <clmason@fusionio.com>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Fri, 19 Apr 2013 09:52:14 -0400
Message-ID: <20130419135214.30947.96188@localhost.localdomain>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk> <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk> <516FFFAC.8040103@cn.fujitsu.com>
 <20130418143014.GZ4816@kernel.dk> <5170BB00.8080200@cn.fujitsu.com>
 <20130419055754.GA9691@mtj.dyndns.org> <20130419133250.GR4816@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130419133250.GR4816@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>, "namhyung@gmail.com" <namhyung@gmail.com>, "agk@redhat.com" <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "neilb@suse.de" <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
List-Id: dm-devel.ids

Quoting Jens Axboe (2013-04-19 09:32:50)
> > 
> > No wonder this thing crashes.  Chris, can't the original bio carry
> > bbio in bi_private and let end_bio_extent_readpage() free the bbio
> > instead of abusing bi_bdev like this?
> 
> Ugh, wtf.
> 
> Chris, time for a swim in the bay :-)

Yeah, I can't really defend this one.  We needed a space for an int and
I assumed end_io meant the FS was free to do horrible things.

Really though, I'll just take a quick dip in the lake and patch this out
of btrfs. 

Jan is probably right about changing around our endio callbacks to
explicitly pass the mirror, it should be less complex and cleaner.

Many thanks to everyone here that tracked it down.

-chris
