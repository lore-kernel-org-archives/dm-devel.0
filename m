From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] User-configurable HDIO_GETGEO for dm
	volumes
Date: Sun, 19 Feb 2006 01:25:17 +0000
Message-ID: <20060219012517.GW12169@agk.surrey.redhat.com>
References: <43F38D83.3040702@us.ibm.com>
	<20060217151650.GC12173@agk.surrey.redhat.com>
	<43F6718E.2000908@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43F6718E.2000908@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Chris McDermott <lcm@us.ibm.com>
List-Id: dm-devel.ids

On Fri, Feb 17, 2006 at 04:59:58PM -0800, Darrick J. Wong wrote:
> Actually, I was not aware that a device could exist without a table. 
> However, I suppose that geometry is a property of a device, not its 
> underlying configuration, so the forced_geometry is better off in struct 
> mapped_device.
 
There are 0, 1 or 2 tables associated with a device.  dm 
restricts which of them you can address through the ioctl
interface according to the state of the device.
Things are simpler if you can use this ioctl regardless of the state
of the tables, so a device-level one is more appropriate.

> Here's the third revision, with the geometry pushed into mapped_device 
> as well as fixes for the problems that you pointed out wrt string 
> passing, lack of warning messages, etc.  

Much better: I'll do a complete review now, fix up remaining minor things 
and get it submitted.

> Also, the v2 patch should have had the appropriate entries in 
> include/linux/compat_ioctl.h.  Maybe it fell off?  In any case, it is 
> present in this v3.
 
*32 isn't but the other *32 ones are?

[In the userspace patch where you add the ioctl to the list you need to 
use the version number which first included it i.e. 4, 6, 0 and you also
have to add it to the libdm-compat file for v1.]

Alasdair
-- 
agk@redhat.com
