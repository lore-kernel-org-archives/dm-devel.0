From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv2 0/4] blk-mq support for dm multipath
Date: Sat, 6 Dec 2014 00:53:51 -0500
Message-ID: <20141206055351.GA2110@redhat.com>
References: <1413589598-17631-1-git-send-email-keith.busch@intel.com>
	<alpine.LNX.2.00.1410281808390.4225@localhost.lm.intel.com>
	<20141028182627.GA28537@redhat.com>
	<20141205232542.GA1274@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141205232542.GA1274@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 05 2014 at  6:25pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Tue, Oct 28 2014 at  2:26pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Tue, Oct 28 2014 at  2:13pm -0400,
> > Keith Busch <keith.busch@intel.com> wrote:
> > 
> > > No comments this time. Did I totally botch this in the wrong direction,
> > > or was the timing bad with the linux con/plumbers that week?
> > 
> > I've just been busy with other things.  Reviewing this is on my
> > near-term TODO (for 3.19 merge consideration).
> 
> Hi Keith,
> 
> I've found a few issues with your v2.  I've been working through the
> code and fixing things as I see them.  Please see this branch:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.19-blk-mq
> 
> My changes build on your v2 baseline.
> 
> How much testing have you done?  It could be that my changes screwed
> something up but... I just tried simply creating a normal request-based
> DM multipath device (using non blk-mq devices) and hit this crash:
> 
> [ 1179.088841] BUG: unable to handle kernel NULL pointer dereference at 0000000000000378
> [ 1179.097587] IP: [<ffffffff8142091a>] scsi_setup_cmnd+0xea/0x170

map_tio_request -> map_request -> dm_dispatch_request -> blk_insert_cloned_request ->
scsi_setup_cmnd -> scsi_setup_fs_cmnd -> scsi_cmd_to_driver

static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
{
        return *(struct scsi_driver **)cmd->request->rq_disk->private_data;
}

We're crashing because rq_disk is NULL.
This fixed the crash for me:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19-blk-mq&id=0373233d9a9ca72a90394ed1770b21a8b7431abc

But in general this code needs _a lot_ more testing/review.
Sadly I cannot stage it for 3.19 inclusion.
