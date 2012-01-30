From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Sun, 29 Jan 2012 18:30:12 -0800
Message-ID: <20120130023012.GH17211@htj.dyndns.org>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
 <20120129192447.GB17211@htj.dyndns.org>
 <4F25F5F3.6060507@gmail.com>
 <20120130014703.GG17211@htj.dyndns.org>
 <4F25FEE5.5010309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F25FEE5.5010309@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 30, 2012 at 11:22:29AM +0900, Namhyung Kim wrote:
> >It's just that this patch as it stands will break the existing tools
> >and is likely to cause some amount of head scratching for blktrace
> >users upgrading to new kernel with existing userland, so yeah, I think
> >it should be filtered in kernel from blktrace.c.
> 
> Will it break blktrace? Looking at the code, not tested though, it
> will just add one more 'C' line for bounced bio, and that's it? The
> blktrace will get way more 'C' lines for normal request based
> devices and it needs to be handled anyway. Am I missing something?

Hmmm... maybe I'm confused.  Wouldn't it cause duplicate completions
for all rq based drivers too?

-- 
tejun
