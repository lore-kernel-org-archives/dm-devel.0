From: "Merla, ShivaKrishna" <ShivaKrishna.Merla@netapp.com>
Subject: Re: [PATCH] multipath: Fix some minor issues in path
	reordering code
Date: Wed, 21 May 2014 19:39:14 +0000
Message-ID: <dd82e03eb62941518f9ca19d6b9ffdf7@hioexcmbx08-prd.hq.netapp.com>
References: <20140521190247.GM1716@dhcp80-209.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140521190247.GM1716@dhcp80-209.msp.redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: Benjamin Marzinski [mailto:bmarzins@redhat.com]
> Sent: Wednesday, May 21, 2014 2:03 PM
> To: device-mapper development
> Cc: Christophe Varoqui; Merla, ShivaKrishna
> Subject: [PATCH] multipath: Fix some minor issues in path reordering code
> 
> There were a couple of small issues with the path reordering code.
> 
> Since you may fail to get the adapter name at any time while looping
> through the paths, you need to clean up when this fails, instead of
> just exitting group_by_host_adapter().
> 
> I've looked at a couple kernels, and I don't see any sysfs file named:
> /sys/class/iscsi_host/host<n>/ip_address
> It's always:
> /sys/class/iscsi_host/host<n>/ipaddress
> 
> Also /sys/class/iscsi_host/host<n>/ipaddress could be an IPv6 address,
> in which case we need 40 bytes to hold is, so SLOT_NAME_SIZE needs to
> be 40 bytes large.
> 
Ben, thanks for identifying and fixing these. I think I overlooked the ipaddress
part as we were majorly testing on FC/SAS.
