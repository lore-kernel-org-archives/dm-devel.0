From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH V2] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Tue, 23 Jan 2018 10:14:05 -0500
Message-ID: <1516720445.10171.1.camel@redhat.com>
References: <20180123105611.7389-1-ming.lei@redhat.com>
         <yq1zi54hfcu.fsf@oracle.com> <20180123142709.GC9792@ming.t460p>
         <20180123144419.GA25384@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180123144419.GA25384@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Tue, 2018-01-23 at 09:44 -0500, Mike Snitzer wrote:
> On Tue, Jan 23 2018 at  9:27am -0500,
> Ming Lei <ming.lei@redhat.com> wrote:
> 
> > Hello Martin,
> > 
> > On Tue, Jan 23, 2018 at 08:30:41AM -0500, Martin K. Petersen wrote:
> > > 
> > > Ming,
> > > 
> > > > + * Block layer and block driver specific status, which is
> > > > ususally returnd
> > > 
> > >                                                                  
> > >      ^^^^^^^
> > > > + * from driver to block layer in IO path.
> > > 
> > > Given that the comment blurb is long and the flag not defined
> > > until
> > > later, it is not entirely obvious that you are documenting
> > > BLK_STS_DEV_RESOURCE. So please make that clear at the beginning
> > > of the
> > > comment.
> > 
> > OK, how about the following document?
> > 
> > /*
> >  * BLK_STS_DEV_RESOURC: Block layer and block driver specific
> > status,
> 
>      ^^^^^^^^^^^^^^^^^^^ typo
> 
> >  * which is usually returned from driver to block layer in IO path.
> >  *
> >  * BLK_STS_DEV_RESOURCE is returned from driver to block layer if
> > device
> >  * related resource is run out of, but driver can guarantee that
> > queue
> >  * will be rerun in future for dispatching the current request when
> > this
> >  * resource is available.
> >  *
> >  * Difference with BLK_STS_RESOURCE:
> >  * If driver isn't sure if the queue can be run again for dealing
> > with the
> >  * current request after this kind of resource is available, please
> > return
> >  * BLK_STS_SOURCE, for example, when memory allocation, DMA Mapping
> > or other
> 
>      ^^^^^^^^^^^^^^ typo
> 
> >  * system resource allocation fails and IO can't be submitted to
> > device,
> >  * BLK_STS_RESOURCE should be used for avoiding IO hang.
> >  */
> 
> In general the 2nd paragraph is one big run-on sentence.  Needs some
> isolation.

I built a new kernel from Mikes latest tree which has all Ming's latest
patches so I could sanity test this on SRP.

I do not have Bart's special parameter the (the can_queue param) but I
am running Bart's 02-mq test over and over looking for a stall.

I am running 5 parallel 02-mq runs via fio against 5 mpaths on which I
have 5 xfs file systems.

So far I have 20 loops of 5 parallel runs and I do not see any stalls
or lock-ups.


Will be good to know if Bart can test this too in his test bed.


Top of Mikes tree is this

afb07d0 Merge branch 'block-4.16_dm-4.16' of https://git.kernel.org/pub
/scm/linux/kernel/git/snitzer/linux int
o block-4.16_dm-4.16
16ce390 Merge branch 'dm-4.16' into block-4.16_dm-4.16
0b943d7 Merge branch 'block-4.16' into block-4.16_dm-4.16
f046ecc blk-mq: introduce BLK_STS_DEV_RESOURCE
4c8cf1c dm mpath selector: more evenly distribute ties
475a055 blk-throttle: use queue_is_rq_based
7923111 dm thin: fix trailing semicolon in
__remap_and_issue_shared_cell
1b3c530 dm table: fix NVMe bio-based dm_table_determine_type()
validation
2ba27c8 dm: various cleanups to md->queue initialization code
e603071 dm mpath: delay the retry of a request if the target responded
as busy
316a795 dm mpath: don't call blk_mq_delay_run_hw_queue() in case of
BLK_STS_RESOURCE
f5ced52 block: Remove kblockd_schedule_delayed_work{,_on}()
ae943d2 blk-mq: Avoid that blk_mq_delay_run_hw_queue() introduces
unintended delays
c77ff7f blk-mq: Rename blk_mq_request_direct_issue() into
blk_mq_request_issue_directly()
8c7a8d1 lib/scatterlist: Fix chaining support in sgl_alloc_order()
9b9c63f7 Merge branch 'nvme-4.16' of git://git.infradead.org/nvme into
for-4.16/block
b889bf6 blk-throttle: track read and write request individually
486e45f IB/srp: Add target_can_queue login parameter
a13553c block: add bdev_read_only() checks to common helpers
721c7fc block: fail op_is_write() requests to read-only partitions
17534c6 blk-throttle: export io_serviced_recursive,
io_service_bytes_recursive
2c2086a block: Protect less code with sysfs_lock in
blk_{un,}register_queue()
14a2349 block: Document scheduler modification locking requirements
83d016a block: Unexport elv_register_queue() and elv_unregister_queue()
8a8747d block, bfq: limit sectors served with interactive weight
raising
a52a69e block, bfq: limit tags for writes and async I/O
2f53fbe Merge branch 'block-4.16_dm-4.16' of https://git.kernel.org/pub
/scm/linux/kernel/git/snitzer/linux int
o block-4.16_dm-4.16
7d089f98 Merge branch 'dm-4.16' into block-4.16_dm-4.16

Typical collectl capture looks like this, solid I/O until completion
ZERO gaps at 1s interval captures.

#         <----------Disks----------->
#Time     KBRead  Reads KBWrit
Writes 
10:11:50       0      4 333332  20777 
10:11:51       0      1 961009  56736 
10:11:52       0      0  1400K  61694 
10:11:53       0      0  1595K  53154 
10:11:54       0      0  1838K  40027 
10:11:55       0      0  1736K  39865 
10:11:56       0      0  2010K  19867 
10:11:57       0      0  1746K  36227 
10:11:58       0      0  1256K 104195 
10:11:59       0      0 928996 126062 
10:12:00   29152   7288 773564  79886 
10:12:01  171924  42981      0      0 
#         <----------Disks----------->
#Time     KBRead  Reads KBWrit Writes 
10:12:02  181500  45375      0      0 
10:12:03  213976  53493      0      0 
10:12:04  206808  51703      4      1 
10:12:05  197260  49315      0      0 
10:12:06  207252  51813      0      0 
10:12:07  202348  50587      0      0 
10:12:08  214412  53603      0      0 
10:12:09  210232  52558      0      0 
10:12:10  206756  51689      0      0 
10:12:11  194708  48677      0      0 
10:12:12  188132  47032      0      0 
10:12:13  193272  48319     36      5 
10:12:14  200372  50093      4      1 
10:12:15  200088  50022      0      0 
10:12:16  181816  45454      0      0 
10:12:17  179116  44779      0      0 
10:12:18  182212  45553      0      0 
10:12:19  191192  47798      0      0 
10:12:20  186580  46649      4      4 
10:12:21  191496  47875      1      1 
10:12:22  182752  45688      0      0 
10:12:23  186272  46567      0      0 
#         <----------Disks----------->
#Time     KBRead  Reads KBWrit Writes 
10:12:24  188660  47166      8      2 
10:12:25  195072  48768      0      0 
10:12:26  188696  47174      0      0 
10:12:27  195560  48890     61      6 
10:12:28  201228  50307      0      0 
10:12:29  202776  50694      0      0 
10:12:30  204900  51225      0      0 
10:12:31  198860  49715      0      0 
10:12:32  203500  50875      0      0 
10:12:33  207860  51965      0      0 
10:12:34  200608  50152      4      1 
10:12:35  181780  45445      0      0 
10:12:36  202020  50505      0      0 
10:12:37  199856  49963      0      0 
10:12:38  198744  49687      0      0 
10:12:39  200156  50039      0      0 
10:12:40  205280  51320      0      0 
10:12:41  205308  51327      0      0 
10:12:42  200236  50059      0      0 
10:12:43  197364  49341      0      0 
10:12:44  203864  50966      8      2 
10:12:45  198548  49638      0      0 
#         <----------Disks----------->
#Time     KBRead  Reads KBWrit Writes 
10:12:46  196468  49115      0      0 
10:12:47  161360  40341      0      0 
10:12:48  155240  38810      0      0 
10:12:49  202264  50566      0      0 
10:12:50  197448  49361      0      0 
10:12:51  191276  47820     80      5 
10:12:52  202460  50615      0      0 
10:12:53  197224  49306      0      0 
10:12:54  189064  47266      4      1 
10:12:55  201244  50311      0      0 
10:12:56  196640  49160      0      0 
10:12:57  190344  47586     72      8 
10:12:58  196880  49220      0      0 
10:12:59  193896  48474      0      0 
10:13:00  178112  44528      0      0 
10:13:01  193904  48476      0      0 
10:13:02  188084  47021      0      0 
10:13:03  187304  46826      0      0 
10:13:04  176236  44059      4      1 
10:13:05  193848  48462      0      0 
10:13:06  189856  47464      0      0 
10:13:07  172788  43197      0      0 
#         <----------Disks----------->
#Time     KBRead  Reads KBWrit Writes 
10:13:08  144608  36152      0      0 
10:13:09  133972  33493      0      0 
10:13:10  158800  39700      0      0 
10:13:11  193416  48354      0      0 
10:13:12  196384  49096      0      0 
10:13:13  188396  47098      0      0 
10:13:14  200520  50131      4      1 
10:13:15  195560  48890      0      0 
10:13:16  198440  49610      0      0 
10:13:17  192260  48065      0      0 
10:13:18  200164  50041      0      0 
10:13:19  202188  50547      0      0 
10:13:20  198104  49526      0      0 
10:13:21  181892  45482     29     18 
10:13:22  101488  25376     21      8 
10:13:23   10004   2503     11      4 
