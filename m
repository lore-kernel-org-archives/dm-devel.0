From: Chris Mason <clmason@fusionio.com>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Fri, 19 Apr 2013 08:15:32 -0400
Message-ID: <20130419121532.30947.69296@localhost.localdomain>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk> <516FED09.1040008@cn.fujitsu.com>
 <20130418133546.GX4816@kernel.dk> <516FFFAC.8040103@cn.fujitsu.com>
 <20130418143014.GZ4816@kernel.dk> <5170BB00.8080200@cn.fujitsu.com>
 <20130419055754.GA9691@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130419055754.GA9691@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Steven Rostedt <rostedt@goodmis.org>, "namhyung@gmail.com" <namhyung@gmail.com>, "agk@redhat.com" <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "neilb@suse.de" <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
List-Id: dm-devel.ids

Quoting Tejun Heo (2013-04-19 01:57:54)
> 
> Ewweeeeeeeeeeeeeeeeeehh........
> 
> No wonder this thing crashes.  Chris, can't the original bio carry
> bbio in bi_private and let end_bio_extent_readpage() free the bbio
> instead of abusing bi_bdev like this?

Yes, we can definitely carry bbio up higher in the stack.  I'll patch it
up right now.  I do agree that it'll be too big for -final, but we'll
have it either way.

-chris
