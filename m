From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 1/1] block: fix blk_queue_split() resource exhaustion
Date: Mon, 11 Jul 2016 16:13:35 +0200
Message-ID: <20160711141335.GZ13335@soda.linbit>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
 <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
 <20160708184957.GA10765@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160708184957.GA10765@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, NeilBrown <neilb@suse.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

Dropped the XXX comment (oops),
moved the current_has_pending_bios() helper to bio.h
and dropped the identical ones from bio.c and md.h.

Reposted in-thread as
[PATCH v2 1/1] block: fix blk_queue_split() resource exhaustion

Thanks,

    Lars Ellenberg
