From: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: Re: RAID5 support ?
Date: Thu, 03 Nov 2005 09:04:11 +0000
Message-ID: <1131008651.6239.10.camel@jetpack.demon.co.uk>
References: <1129981242.7217.6.camel@jetpack.demon.co.uk>
	<17242.17266.315175.852854@cse.unsw.edu.au>
	<1129996688.7217.9.camel@jetpack.demon.co.uk>
	<17244.8868.117125.78408@cse.unsw.edu.au>
	<1130157973.6046.11.camel@jetpack.demon.co.uk>
	<17257.33116.12284.159992@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <17257.33116.12284.159992@cse.unsw.edu.au>
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

On Thu, 2005-11-03 at 14:17 +1100, Neil Brown wrote:
> On Monday October 24, alanh@fairlite.demon.co.uk wrote:
> > > 'md' has all the meta-data operations reasonably well factored out, so
> > > working with new formats shouldn't be difficult.
> > 
> > That to me still doesn't resolve the bootloader problems.
> > 
> > Regardless of the md understanding the meta-data operations, it deals
> > with partitions and therefore the boot sector of each drive in an md
> > setup is outside the scope of it's operation.
> 
> md doesn't work with partitions.  It works with devices which may be
> partitions or may be the whole device.
> I often make raid5 arrays out of a set of devices, none of them
> partitioned. 

O.k. Can you explain to me how to do that and still boot from the md
device ?

Alan.
