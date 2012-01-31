From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Tue, 31 Jan 2012 02:39:47 -0800
Message-ID: <CAOS58YP1F6_yBxRArcP4oyzAJVArLJB-ckjdXU35U1SNwi75XQ@mail.gmail.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com>
	<4F263B01.4050103@gmail.com>
	<20120130170548.GA3355@google.com>
	<4F278A78.8080300@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F278A78.8080300@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

On Mon, Jan 30, 2012 at 10:30 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> Right, but the point is it could make a NULL pointer dereference during
> evaluation of the argument of the TP AFAICS. I'm not sure about the TP
> implementation though, I think I was wrong - T_E_C() cannot protect us from
> it because it happens just before jumping to the TP, right?
>
> So I think we need a conditional jump (with the "likely" annotation) for
> this even when the TP is disabled.

Hmmm... still not following. Where the said NULL dereference happen?
TEC conditional is equivalent to "if (COND) TP;".  If you don't use
TEC, it'll be "if (COND) if (TP enabled) TP;".  With TEC, it will be
"if (TP enabled) if (COND) TP;".  There's no other difference.

Thanks.

-- 
tejun
