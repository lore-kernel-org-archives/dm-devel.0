From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: LVM on dmraid breakage
Date: Wed, 01 Aug 2007 15:12:08 -0700
Message-ID: <1186006328.17399.118.camel@linuxchandra>
References: <46B0EAEF.6090305@cfl.rr.com>
	<0EAFEA7F-BC32-4256-9C8E-3086756293C8@redhat.com>
	<46B0F8E9.5000609@cfl.rr.com>
	<140BA4BE-4B0E-472B-8E4C-29AF02D475C5@redhat.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <140BA4BE-4B0E-472B-8E4C-29AF02D475C5@redhat.com>
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

On Wed, 2007-08-01 at 16:44 -0500, Jonathan Brassow wrote:
> On Aug 1, 2007, at 4:19 PM, Phillip Susi wrote:
> 
> > Jonathan Brassow wrote:
> >> I'm not aware of a mechanism that LVM used to skip over owned  
> >> devices... there may exist one.  However, you could use lvm  
> >> filters to skip those underlying devices.
> >>  brassow
> >
> > LVM filters?
> 
> Look in /etc/lvm/lvm.conf for "filter".  There are some examples  
> there.  Be careful though, if you exclude your root partion you may  
> be in for future pain.
> 

To avoid this problem, put your root disk at the start of the filter
with a "a" (like "a|/dev/sda.*|"), and have the "r"ejects after it.

Basically, when a device is found, the filter is walked from left to
write and action is taken when the first match happen. IOW, all your
scsi disks will be "r"ejected with the following filter,

["r|/dev/sd.*|", "a|/dev/sdgp.*|", "a|/dev/sdgo.*|", "a|/dev/sda.*" ]

in effect the later "a"ccepts are useless.

>   brassow
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
