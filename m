From: Jens Beyer <jbe@webde-ag.de>
Subject: Re: Data corruption on large, multi-device filesystem
Date: Fri, 28 Jan 2005 10:23:17 +0100
Message-ID: <20050128092317.GA22682@pcnocjb.dlan.cinetic.de>
References: <20050118091059.GC27553@pcnocjb.dlan.cinetic.de>
	<1106172883.41eedbd386498@www.eiler.net>
	<41EFBAF4.5030403@svs.gsfc.nasa.gov>
	<20050120175900.GE14093@agk.surrey.redhat.com>
	<20050121150913.GA16975@pcnocjb.dlan.cinetic.de>
	<1106674648.41f683d80ea75@www.eiler.net>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-lvm-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1106674648.41f683d80ea75@www.eiler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: joe@eiler.net
Cc: dm-devel@redhat.com, LVM general discussion and development <linux-lvm@redhat.com>
List-Id: dm-devel.ids


Hi,

since the two patches (stripe_width and sector_t cast) didnt help, 
I started to put printk in the dm-stripe code. 

At a certain point stripe_map() starts to get called with zero data 
(eg bio->bi_sector = 0 or 2^32, 2^31 ). This lead me to put some debugging 
into dm.c especially into max_io_len() where an inline function dm_round_up()
is used. Interpreting my printk's this funktion doesnt work well with 
offsets larger then 2^32. I did some (very) ugly hack to calculate the
boundary in that case and it seems that the error is gone (though the
full check takes a few days).

Maybe someone with insight on what should happen in dm.c can have 
a look at max_io_len and the inlined function?

Jens

-- 
Nur tote Fische schwimmen mit dem Strom

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
