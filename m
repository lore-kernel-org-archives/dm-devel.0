From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/3] per-cpu in_flight counters for bio-based
	drivers
Date: Fri, 30 Nov 2018 14:57:31 -0500
Message-ID: <20181130195731.GB3719@redhat.com>
References: <20181128004211.368810060@debian.vm>
	<20181130144343.GA13483@redhat.com>
	<20181130155054.GA13744@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181130155054.GA13744@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Fri, Nov 30 2018 at 10:50am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Nov 30 2018 at  9:43am -0500,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Tue, Nov 27 2018 at  7:42pm -0500,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > These are the patches for per-cpu in_flight counters.
> > 
> > Do you have updated before vs after performance results for these
> > changes?
> > 
> > I'd imagine they are comparable to your previous run (though that run
> > included some other DM changes that I already staged).
> 
> Would like to see before vs after with:
> 
> http://git.kernel.dk/cgit/linux-block/log/?h=for-4.21/block
> vs
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=block-dm-4.21-inflight
> 
> (block-dm-4.21-inflight is based on latest for-4.21/block -- and it
> contains DM changes in front of the block changes from this thread; I'd
> prefer Jens take the changes like this rather than leave DM in a bit of
> a mess for me/us to have to cleanup later)

I ran the same fio test you did (in the previous thread where you did
the switch to percpu local to DM, rather than in block) _except_ I used
a ramdisk-based pmem device rather than a pure ramdisk:

fio --ioengine=psync --iodepth=1 --rw=read --bs=512 --direct=1 --numjobs=12 --time_based --runtime=10 --group_reporting --name=/dev/pmem0

2 6-core processors (w/ HT, so 24 logical cpus):

/dev/pmem0                                        14.6M
/dev/pmem0 with percpu counters                   14.8M
/dev/mapper/linear                                4736k
/dev/mapper/linear with percpu counters           4595k

It is only after I apply this commit that I can realize a big
performance win:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=block-dm-4.21-inflight&id=335b41c7513110b1519d8a93d412c138bf671263

/dev/mapper/linear with percpu + pending removed  11.2M
