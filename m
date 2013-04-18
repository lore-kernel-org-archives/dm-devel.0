From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Thu, 18 Apr 2013 09:08:34 -0700
Message-ID: <CA+55aFwA8njGh4v8ZfR_o4s4m=Hugnadeir=uxbeE4yxHiBKLg@mail.gmail.com>
References: <516E5EF8.9090507@cn.fujitsu.com>
	<1366209997.8817.12.camel@pippen.local.home>
	<20130418123738.GV4816@kernel.dk>
	<516FED09.1040008@cn.fujitsu.com>
	<20130418133546.GX4816@kernel.dk>
	<516FFFAC.8040103@cn.fujitsu.com>
	<20130418143014.GZ4816@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130418143014.GZ4816@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Namhyung Kim <namhyung@gmail.com>, Alasdair G Kergon <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Apr 18, 2013 at 7:30 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Could you capture the full dump? I'd like to see what rcx was, and that
> seems to have scrolled off.

You don't need it. The %cr2 value shows the address of the bad access,
and it's 0x00000001.

                Linus
