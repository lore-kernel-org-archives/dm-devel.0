From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 support ?
Date: Thu, 3 Nov 2005 14:17:48 +1100
Message-ID: <17257.33116.12284.159992@cse.unsw.edu.au>
References: <1129981242.7217.6.camel@jetpack.demon.co.uk>
	<17242.17266.315175.852854@cse.unsw.edu.au>
	<1129996688.7217.9.camel@jetpack.demon.co.uk>
	<17244.8868.117125.78408@cse.unsw.edu.au>
	<1130157973.6046.11.camel@jetpack.demon.co.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: message from Alan Hourihane on Monday October 24
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

On Monday October 24, alanh@fairlite.demon.co.uk wrote:
> > 'md' has all the meta-data operations reasonably well factored out, so
> > working with new formats shouldn't be difficult.
> 
> That to me still doesn't resolve the bootloader problems.
> 
> Regardless of the md understanding the meta-data operations, it deals
> with partitions and therefore the boot sector of each drive in an md
> setup is outside the scope of it's operation.

md doesn't work with partitions.  It works with devices which may be
partitions or may be the whole device.
I often make raid5 arrays out of a set of devices, none of them
partitioned. 

NeilBrown
