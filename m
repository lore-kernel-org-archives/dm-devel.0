From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Kernel v4.1-rc1 + MQ dm-multipath + MQ SRP oops
Date: Tue, 28 Apr 2015 09:52:58 -0400
Message-ID: <20150428135258.GA16267@redhat.com>
References: <553F7474.70905@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <553F7474.70905@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Tue, Apr 28 2015 at  7:52am -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Hello,
> 
> Earlier today I started testing an SRP initiator patch series on top
> of Linux kernel v4.1-rc1. Although that patch series works reliably
> on top of kernel v4.0, a test during which I triggered
> scsi_remove_host() + relogin (for p in
> /sys/class/srp_remote_ports/*; do echo 1 >$p/delete & done; wait;
> srp_daemon -oaec) triggered the following kernel oops:
> 
> device-mapper: multipath: Failing path 8:0.
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000138
> IP: [<ffffffffa045f8e9>] free_rq_clone+0x29/0xb0 [dm_mod]
...
 
> In case anyone wants to see the translation of the crash address:
> 
> (gdb) list *(free_rq_clone+0x29)
> 0x919 is in free_rq_clone (drivers/md/dm.c:1092).
> 1087            struct dm_rq_target_io *tio = clone->end_io_data;
> 1088            struct mapped_device *md = tio->md;
> 1089
> 1090            blk_rq_unprep_clone(clone);
> 1091
> 1092            if (clone->q->mq_ops)
> 1093                    tio->ti->type->release_clone_rq(clone);
> 1094            else if (!md->queue->mq_ops)
> 1095                    /* request_fn queue stacked on request_fn
> queue(s) */
> 1096                    free_clone_request(md, clone);

I saw a crash like this yesterday with 4.1-rc1 (definitely due to
clone->q being NULL) but I didn't get a full backtrace over serial
console so I cannot be sure it is exactly like yours.

In my case I was using hch's lio-utils based test setup that he
documented here:
https://www.redhat.com/archives/dm-devel/2015-April/msg00138.html

But I got the crash the first time I ran this script:
multipathd -F
tcm_loop --unload
tcm_node --freedev iblock_0/array

Rough first experience with LIO ;)  So I just chalked it up to tcm_loop
or something not being careful about device lifetime.

So we now have 2 data points (each using different storage backend).  I
haven't been able to reproduce the issue again though -- but I switch
away from using multipathd to create the multipath device and resorted
to using dmsetup directly (with a dmsetup remove for cleanup instead of
multipath -F).
