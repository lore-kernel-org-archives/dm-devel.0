From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: multipathd configuration for Sun StorageTek 2510
Date: Wed, 24 Jun 2009 11:30:30 -0700
Message-ID: <1245868230.26915.22.camel@chandra-ubuntu>
References: <Pine.LNX.4.64.0906231512040.18393@e-smith.charlieb.ott.istop.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0906231512040.18393@e-smith.charlieb.ott.istop.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi Charlie,

I see "SUN" "LCSM100_F" in hwtable.c Christophe's tree
(http://git.kernel.org/?p=linux/storage/multipath-tools/.git)

If it matches your config (I think it does), you can cut-n-paste that 
and submit a patch.

regards,

chandra
On Tue, 2009-06-23 at 15:15 -0400, Charlie Brady wrote:
> I've added this to my multipath.conf:
> 
> devices {
>      device {
>          vendor                  "SUN"
>          product                 "LCSM100_I"
>          getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>          prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
>          features                "0"
>          hardware_handler        "1 rdac"
>          path_grouping_policy    group_by_prio
>          failback                immediate
>          rr_weight               uniform
>          no_path_retry           queue
>          rr_min_io               1000
>          path_checker            rdac
>      }
> }
> 
> If anyone sees any errors, please let me know. If not, could this 
> information be added to multipath.conf.defaults and 
> the equivalent to libmultipath/hwtable.c?
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
