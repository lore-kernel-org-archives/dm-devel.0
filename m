From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: 4k block LUN problem
Date: Wed, 13 Jun 2007 20:34:33 +0100
Message-ID: <20070613193433.GG18457@agk.fab.redhat.com>
References: <20070613185651.GF18457@agk.fab.redhat.com>
	<3DB43EBAF77555449D828440C12F8E7E034406D1@usbmaxms02.am.sony.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3DB43EBAF77555449D828440C12F8E7E034406D1@usbmaxms02.am.sony.com>
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

On Wed, Jun 13, 2007 at 03:17:25PM -0400, Vassar, Bob wrote:
> I have used tur and this allows the system to boot. When I run "ll
> /dev/mpath* I see the dm device created. All appears to be working OK. 

So use tur then.  First problem solved.

> Fdisk also reports the same number of devices as paths to the device.  

Fdisk?  Don't partition it: use logical volumes instead:
pvcreate/vgcreate/lvcreate.
- You'd need parted (gpt) rather than fdisk to partition large devices
and then kpartx.


Now run 'blockdev --getss' to check whether or not the sector size gets
propagated correctly from the underlying device to the multipath device.

Alasdair
-- 
agk@redhat.com
