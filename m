From: "srostedt@gmail.com" <rostedt@goodmis.org>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Date: Thu, 18 Apr 2013 21:08:54 -0400
Message-ID: <292ec4c2-f2d3-47fc-816f-472e83c10959@email.android.com>
References: <516FED09.1040008@cn.fujitsu.com> <20130418133546.GX4816@kernel.dk>
	<516FFFAC.8040103@cn.fujitsu.com> <20130418143014.GZ4816@kernel.dk>
	<CA+55aFwA8njGh4v8ZfR_o4s4m=Hugnadeir=uxbeE4yxHiBKLg@mail.gmail.com>
	<20130418172732.GB9897@mtj.dyndns.org>
	<20130418173811.GF4816@kernel.dk>
	<20130418180752.GD9897@mtj.dyndns.org>
	<20130418181318.GH4816@kernel.dk>
	<CA+55aFxEThMJid_PiL=ko3duRPzzynkhMovsrm3TR_UXxUGciA@mail.gmail.com>
	<20130418203705.GJ4816@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130418203705.GJ4816@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Could it be a module not recompiled with a newer kernel?

-- Steve


Jens Axboe <axboe@kernel.dk> wrote:


>
>Hmm dunno. It happens right after we've completed the bio, which
>touches
>a lot of fields too. bi_bdev sits between bi_next (which we definitely
>used) and bi_flags.
>
>But adding slab use-after-free debugging would show for sure.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
