From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Sun, 29 Jan 2012 18:53:26 -0800
Message-ID: <20120130025326.GI17211@htj.dyndns.org>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
 <20120129192447.GB17211@htj.dyndns.org>
 <4F25F5F3.6060507@gmail.com>
 <20120130014703.GG17211@htj.dyndns.org>
 <4F25FEE5.5010309@gmail.com>
 <20120130023012.GH17211@htj.dyndns.org>
 <4F260547.1030405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F260547.1030405@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

On Mon, Jan 30, 2012 at 11:49:43AM +0900, Namhyung Kim wrote:
> Yes, blktrace will see both of completions for rq and bio's it
> contains from now on, and I thought it's your intention? For the
> bounced bio's, it'll see one more completion per bio.

Umm... no, blktrace users shouldn't see confusing outputs.  My point
was that we should leave raw tracepoints as raw monitor points so that
they can provide raw data to different users and filter from
blktrace.c so that the existing users aren't disturbed.

Thanks.

-- 
tejun
