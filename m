From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Tue, 23 Dec 2014 16:42:12 -0500
Message-ID: <CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<20141217230622.GC15390@redhat.com> <54943714.2040704@acm.org>
	<20141219153801.GA8697@redhat.com> <20141219171438.GA6347@redhat.com>
	<5498389D.6070909@acm.org> <20141222184910.GB8054@redhat.com>
	<54999756.70303@acm.org>
	<1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>, device-mapper@redhat.com, Keith Busch <keith.busch@intel.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Tue, Dec 23, 2014 at 12:13 PM, Mike Snitzer <msnitzer@redhat.com> wrote:
> Sorry for top post but:
>
> You'll likely fix this if you establish the cloned request's rq_disk member
> in the blk-mq branch of dm-mpath.c:__multipath_map()

I've rebased with this fix folded into both the 'for-next' and
'dm-for-3.20-blk-mq' branches of linux-dm.git
