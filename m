From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath low performance with blk-mq
Date: Mon, 1 Feb 2016 07:46:59 +0100
Message-ID: <56AEFF63.7050606@suse.de>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com> <20160125214016.GA10060@redhat.com>
	<20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com>
	<56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com> <56A904B6.50407@dev.mellanox.co.il>
	<20160129233504.GA13661@redhat.com> <56AC79D0.5060104@suse.de>
	<20160130191238.GA18686@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160130191238.GA18686@redhat.com>
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
Cc: axboe@kernel.dk, "keith.busch@intel.com" <keith.busch@intel.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On 01/30/2016 08:12 PM, Mike Snitzer wrote:
> On Sat, Jan 30 2016 at  3:52am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> =

>> On 01/30/2016 12:35 AM, Mike Snitzer wrote:
>>>
>>> Your test above is prone to exhaust the dm-mpath blk-mq tags (128)
>>> because 24 threads * 32 easily exceeds 128 (by a factor of 6).
>>>
>>> I found that we were context switching (via bt_get's io_schedule)
>>> waiting for tags to become available.
>>>
>>> This is embarassing but, until Jens told me today, I was oblivious to
>>> the fact that the number of blk-mq's tags per hw_queue was defined by
>>> tag_set.queue_depth.
>>>
>>> Previously request-based DM's blk-mq support had:
>>> md->tag_set.queue_depth =3D BLKDEV_MAX_RQ; (again: 128)
>>>
>>> Now I have a patch that allows tuning queue_depth via dm_mod module
>>> parameter.  And I'll likely bump the default to 4096 or something (doing
>>> so eliminated blocking in bt_get).
>>>
>>> But eliminating the tags bottleneck only raised my read IOPs from ~600K
>>> to ~800K (using 1 hw_queue for both null_blk and dm-mpath).
>>>
>>> When I raise nr_hw_queues to 4 for null_blk (keeping dm-mq at 1) I see a
>>> whole lot more context switching due to request-based DM's use of
>>> ksoftirqd (and kworkers) for request completion.
>>>
>>> So I'm moving on to optimizing the completion path.  But at least some
>>> progress was made, more to come...
>>>
>>
>> Would you mind sharing your patches?
> =

> I'm still working through this.  I'll hopefully have a handful of
> RFC-level changes by end of day Monday.  But could take longer.
> =

> One change that I already shared in a previous mail is:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=
=3Ddevel2&id=3D99ebcaf36d9d1fa3acec98492c36664d57ba8fbd
> =

>> We're currently doing tests with a high-performance FC setup
>> (16G FC with all-flash storage), and are still 20% short of the
>> announced backend performance.
>>
>> Just as a side note: we're currently getting 550k IOPs.
>> With unpatched dm-mpath.
> =

> What is your test workload?  If you can share I'll be sure to factor it
> into my testing.
> =

That's a plain random read via fio, using 8 LUNs on the target.

>> So nearly on par with your null-blk setup. but with real hardware.
>> (Which in itself is pretty cool. You should get faster RAM :-)
> =

> You've misunderstood what I said my null_blk (RAM) performance is.
> =

> My null_blk test gets ~1900K read IOPs.  But dm-mpath ontop only gets
> between 600K and 1000K IOPs depending on $FIO_QUEUE_DEPTH and if I
> use multiple $NULL_BLK_HW_QUEUES.
> =

Right.
We're using two 16G FC links, each talking to 4 LUNs.
With dm-mpath on top. The FC HBAs have a hardware queue depth
of roughly 2000, so we might need to tweak the queue depth of the
multipath devices, too.


Will be having a look at your patches.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
