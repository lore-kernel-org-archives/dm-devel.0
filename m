From: Suresh Babu Kandukuru <suresh.babu.kandukuru@oracle.com>
Subject: Re: Device mapper target driver for Write tracking or
 Write split
Date: Fri, 9 Jan 2015 07:51:08 -0800 (PST)
Message-ID: <932defdc-db0a-4f1d-9812-1685199aed3a@default>
References: <e1aa69e2-7af2-4003-8b8c-5a2b6987a3e2@default>
	<20150109142313.GB24745@redhat.com>
	<a6164707-a0dc-426d-9324-a5fba2170682@default>
	<20150109151337.GA17009@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150109151337.GA17009@localhost.localdomain>
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
Cc: bmr@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

Bryn, Thanks for quick reply. Below items helps to do mirroring and replication . I am looking for something which  can track writes( device mapper based block level filter driver)   as explained in the below diagram in Linux open source community .

http://www.ryussi.com/ryucorp/uploads/2014/11/Block-level-filter-driver_jitu.png?723184


Thanks again

/Suresh


-----Original Message-----
From: Bryn M. Reeves [mailto:bmr@redhat.com] 
Sent: Friday, January 09, 2015 8:44 PM
To: device-mapper development
Cc: vgoyal@redhat.com
Subject: Re: [dm-devel] Device mapper target driver for Write tracking or Write split

On Fri, Jan 09, 2015 at 06:51:28AM -0800, Suresh Babu Kandukuru wrote:
>   1) Basically we map the LUN from storage arrary to one of linux host . Linux host sees that  LUN with mutlipath ( dm-multipath) abstact device /dev/mapper/LUNID . Linux host can mount that lun and do some read and write operation  on that . We want to cature those writes and send those writes  to another appliance . we will use that appilance for CDP( continues data protection)  of that LUN . 

The closest to this is probably dm-replicator:

  http://people.redhat.com/heinzm/sw/dm/dm-replicator/src/linux/Documentation/device-mapper/replicator.txt

However it's not upstream and is not currently under development.

In addition to the single device write replication you discuss it supports a range of device and link counts and types (e.g. the README above shows an example with multiple local and remote devices and inter site links).
 
> 2) My idea is To track writes  on the mapped lun  in Linux,  Can we  instantiate a write tracking Device Mapper device stacked on top of the mapped lun device ( /dev/mapper/LUIN) ?. Then, whenever the write tracking Device Mapper device receives  write request, it tracks the write. After that, it passes the  write request down to the underlying  lun device. In addition, to track writes to a Lun device, Linux host needs to be told to access the write tracking device instead of the LUN device itself. 

In terms of targets that are upstream and supported currently this has some similarity to the mirroring modes now offered via the dm-raid target.

This exposes the Linux MD RAID personalities as device-mapper targets.
Some combination of RAID1 and write-behind behaviour for the replicated device may give you what you're looking for.

Regards,
Bryn.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
