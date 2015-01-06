From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Tue, 6 Jan 2015 00:59:45 -0800
Message-ID: <20150106085945.GA19722@infradead.org>
References: <20141222184910.GB8054@redhat.com> <54999756.70303@acm.org>
	<1v2g6masssbu88ans1r6lres.1419354811001@email.android.com>
	<CAMM=eLd_A+fRBHDvcDqwF1a9co+G7XZvVhRyBd1AjxOdgjKhbA@mail.gmail.com>
	<549AB979.4050302@acm.org> <20141224182143.GA12922@redhat.com>
	<20141224185529.GA13246@redhat.com>
	<20141224192643.GA30461@redhat.com> <54A6DB1D.4030201@acm.org>
	<20150105213557.GA5030@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150105213557.GA5030@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Mon, Jan 05, 2015 at 04:35:57PM -0500, Mike Snitzer wrote:
> I don't have very large blk-mq devices, but I can work on that.

Just export a large sparse file over an iSCSI target?
