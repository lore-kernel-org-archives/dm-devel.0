From: Tejun Heo <tj@kernel.org>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Thu, 3 Nov 2011 08:54:16 -0700
Message-ID: <20111103153835.GF4417@google.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: dm-devel@redhat.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
List-Id: dm-devel.ids

Hello,

(cc'ing dm-devel)

On Thu, Nov 03, 2011 at 01:02:37AM +0000, Hawrylewicz Czarnowski, Przemyslaw wrote:
> Recently we have encountered a problem with unlocking of HPA on disks belonging to RAID array.
> The scenario in the simplest form is as follows:
> * take HPA resized drives
> * use SW Raid solution with metadata located at the end of disk (eg. md v1.0, IMSM)
> * create raid0/10/5 using whole devices (eg. /dev/sda) (raid size must extend capacity of single device; raid1 is not the case here) 
> * create any partition with size exceeding HPA limit of single component
> 
> According to the code of rescan_partitions(), if disk has capacity limit enabled (HPA) and boundary of partition extends beyond that limit, it is bypassed/unlocked (regardless of libata.ignore_hpa state).
> As for single block device it is proper action - for raid using whole block device it is not. The partition table despite the fact it is read from single disk belongs to raid array. Values in RAID context are set properly. But from the point of view of single device - they are not.
> Problem is that in general rescan_partition() has no knowledge of any raid array using that block device. Moreover, that raid is not assembled yet.
> And the result: as HPA limit is unlocked and metadata on this device in not recognizable anymore - in worst case raid is not assembled or failed.
> 
> The simplest resolution is to conditionally forbid HPA unlocking (eg. extending ignore_hpa parameter) but I suppose a better and more 'intelligent' solution can be found.

This has come up a couple times and I think the proper solution is to
always unlock HPA and expose both sizes - locked and unlocked and let
dm, md or whatever do whatever is approriate.  Block or driver layer
doesn't have any way to determine which one is the right bet - it
simply doesn't have enough information.  I tried to bounce this idea
off people who whould actually be using this (dm/md) but haven't heard
back yet.

Thanks.

-- 
tejun
