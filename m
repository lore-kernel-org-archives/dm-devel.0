From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Crash in dm_done()
Date: Wed, 11 Jan 2012 11:25:04 -0500
Message-ID: <20120111162501.GA25980@redhat.com>
References: <4F0C1E68.30602@suse.de>
 <4F0D4A23.7060604@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4F0D4A23.7060604@ce.jp.nec.com>
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
List-Id: dm-devel.ids

On Wed, Jan 11 2012 at  3:36am -0500,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi Hannes,
> 
> On 01/10/12 20:18, Hannes Reinecke wrote:
> > I'm trying to hunt down a mysterious crash:
> > 
> > Unable to handle kernel pointer dereference at virtual kernel
> > address 000003c001762000
> > Oops: 0011 [#1] SMP
> > Modules linked in: dm_round_robin sg sd_mod crc_t10dif ipv6 loop
> > dm_multipath scsi_dh dm_mod qeth_l3 ipv6_lib zfcp scsi_transport_fc
> > scsi_tgt scsi_mod dasd_eckd_mod dasd_mod qeth qdio ccwgroup ext3
> > mbcache jbd
> > Supported: Yes
> > CPU: 0 Not tainted 3.0.13-0.5-default #1
> > Process kworker/0:1 (pid: 51750, task: 0000000008450138, ksp:
> > 0000000007323620)
> > Krnl PSW : 0704200180000000 000003c001953750 (dm_done+0x44/0x188
> > [dm_mod])
> >            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
> > Krnl GPRS: 000000002adb5e80 000003c001762100 0000000037de9e80
> > 0000000000000000
> >            0000000000000400 000003c00195e178 0000000000000380
> > 0000000000000000
> >            0000000000000100 0000000000000001 0000000037de9e80
> > 0000000037de9e68
> >            000003c00194f000 000003c00195e168 000000007ef97d30
> > 000000007ef97cd8
> > Krnl Code: 000003c001953740: e3b021580004       lg     %r11,344(%r2)
> >            000003c001953746: e310b0080004       lg     %r1,8(%r11)
> >            000003c00195374c: bf4fb180           icm %r4,15,384(%r11)
> >           >000003c001953750: e32010080004       lg      %r2,8(%r1)
> >            000003c001953756: e38020500004       lg      %r8,80(%r2)
> >            000003c00195375c: a7740062           brc    7,3c001953820
> >            000003c001953760: b9020099           ltgr    %r9,%r9
> >            000003c001953764: a7840049           brc    8,3c0019537f6
> > 
> > r11 is struct dm_rq_target_io *tio = clone->end_io_data;
> > r1 is tio->ti (ie struct dm_target), which is invalid.
> > r2 is tio->ti->type, likewise.
> > 
> > Apparently the table got replaced between map_io() and dm_done(),
> > causing this invalid pointer.
> > While we do hold a reference on the mapped_device in map_request(),
> > we only take a _single_ reference to the table in dm_request_fn(),
> > which is dropped again at the end.
> 
> > And as the table holds the pointer to the targets, they'll be
> > invalidated upon table swapping, causing dm_done() accessing an
> > invalid pointer.
> 
> The last paragraph is not correct.
> If any requests are in-flight, dm does not swap table.
> 
> I.e., in dm_suspend(), for request-based dm, we do:
>   1) stop request_queue processing
>      <from this point, no new request becomes in-flight>
>   2) wait for completion of in-flight I/Os
>      <from this point, no requests are in-flight>
> and only after that, we can swap tables.
> 
> Existence of in-flight I/O is checked by "pending" counter of md.
> 
> The counter is increased in dm_request_fn()
> and decreased in rq_completed(), which is called either
> when the original request is requeued or completed.
> I.e. after dm_done() processing.
> 
> 
> > I can't really believe that is the case, so please do correct me if
> > the above analysis is wrong.
> 
> Just guessing...
> Such a mysterious crash could occur if there are bugs like:
>   - somebody start the queue while dm stopped it in dm_suspend()
>   - somebody submit/complete/requeue request with
>     wrong function and corrupt pending counter
>   - lower-level driver completes a request twice
> 
> If you can recreate the crash, try attached debug patch.
> It should raise warnings when cases like above happen
> and might help hunting down the problem.

There was also that earlier thread about a crash in dm_done(), where
dereferencing clone->end_io_data caused the crash:
https://lkml.org/lkml/2011/10/31/97

Heiko said that Hannes' patch:
http://www.redhat.com/archives/dm-devel/2011-November/msg00176.html

... actually helped:
https://lkml.org/lkml/2011/11/29/168

But we never did get to the bottom of _why_, and Jun'ichi pointed out
a NULL pointer check is missing:
http://www.redhat.com/archives/dm-devel/2011-December/msg00022.html

Anyway, Hannes, if you can reproduce it'd also be interesting to see if
your patch (updated with NULL pointer check?) makes any difference.

Mike
