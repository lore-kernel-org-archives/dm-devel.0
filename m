From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Data corruption on large, multi-device filesystem
Date: Fri, 28 Jan 2005 14:01:55 +0000
Message-ID: <20050128140155.GC14093@agk.surrey.redhat.com>
References: <20050118091059.GC27553@pcnocjb.dlan.cinetic.de>
	<1106172883.41eedbd386498@www.eiler.net>
	<41EFBAF4.5030403@svs.gsfc.nasa.gov>
	<20050120175900.GE14093@agk.surrey.redhat.com>
	<20050121150913.GA16975@pcnocjb.dlan.cinetic.de>
	<1106674648.41f683d80ea75@www.eiler.net>
	<20050128092317.GA22682@pcnocjb.dlan.cinetic.de>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-lvm-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050128092317.GA22682@pcnocjb.dlan.cinetic.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: LVM general discussion and development <linux-lvm@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Jan 28, 2005 at 10:23:17AM +0100, Jens Beyer wrote:
> since the two patches (stripe_width and sector_t cast) didnt help, 

Indeed - you need a version of Kevin's patch too; but I've widened
the scope of this to looking into why these functions are being
called.  (Now down to three 64/32 divisions.)

Alasdair
-- 
agk@redhat.com

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
