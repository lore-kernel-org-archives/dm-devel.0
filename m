From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: DM MULTIPATH: Allow dm to send larger request if
 underlying device set to larger max_sectors value
Date: Mon, 9 Jul 2012 09:16:11 -0400
Message-ID: <20120709131611.GD30048@redhat.com>
References: <F200AD42A082BC4088B232D13A916A8907E5DD64@SACEXCMBX02-PRD.hq.netapp.com>
	<20120709130052.GC30048@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120709130052.GC30048@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "Moger,
	Babu" <Babu.Moger@netapp.com>, "Stankey,
	Robert" <Robert.Stankey@netapp.com>
List-Id: dm-devel.ids

On Mon, Jul 09 2012 at  9:00am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Sun, Jul 08 2012 at  1:59pm -0400,
> Chauhan, Vijay <Vijay.Chauhan@netapp.com> wrote:
> 
> > Even though underlying paths are set with larger value for max_sectors, dm 
> > sets 1024(i.e 512KB) for max_sectors as default. max_sectors for dm 
> > device can be reset through sysfs but any time map is updated, max_sectors
> > is again set back to default. This patch gets the minimum of max_sectors from 
> > physical paths and sets it to dm device.
> 
> There shouldn't be any need for additional DM overrides for max_sectors.
> 
> DM will stack the limits for all underlying devices each table reload
> (via dm_calculate_queue_limits).  And max_sectors is properly stacked in
> the block layer's bdev_stack_limits (called by dm_set_device_limits).
> 
> So is something resetting max_sectors with sysfs?  multipathd?

BLK_DEF_MAX_SECTORS = 1024
blk_set_stacking_limits: lim->max_sectors = BLK_DEF_MAX_SECTORS

But that just establishes the default, the stacking done by
blk_stack_limits will reduce 'max_sectors' accordingly based on the
underlying paths' max_sectors.

I can clearly see that max_sectors is reduced according to the
underlying device(s):

# multipath -ll
mpathe (36003005700ec1890167a7e5953effb87) dm-5 LSI,RAID 5/6 SAS 6G
size=465G features='0' hwhandler='0' wp=rw
`-+- policy='round-robin 0' prio=1 status=active
  `- 0:2:4:0 sde 8:64 active ready running

# cat /sys/block/sde/queue/max_sectors_kb 
240

# cat /sys/block/dm-5/queue/max_sectors_kb 
240
