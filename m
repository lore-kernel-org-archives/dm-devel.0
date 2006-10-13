From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Re: New read-balancing patch for dm-raid1.c
Date: Fri, 13 Oct 2006 07:48:28 -0400
Message-ID: <FB07FE26-5ECC-460B-99A9-612870CCBE79@mac.com>
References: <1160580794.15980.2.camel@hydrogen.msp.redhat.com>
	<20061012144614.GY17654@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061012144614.GY17654@agk.surrey.redhat.com>
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

On Oct 12, 2006, at 10:46:14, Alasdair G Kergon wrote:
> On Wed, Oct 11, 2006 at 10:33:14AM -0500, Jon Brassow wrote:
>> This patch adds read balancing.  The round-robin method is the  
>> first to be implemented, but provisions are made for others to be  
>> implemented in the future.
>
> My first thought in looking over this is that it ought to share the  
> existing dm-round-robin module used by multipath (which is already  
> more flexible than this as paths can be weighted).  It looks fairly  
> straightforward to do this. (And we certainly shouldn't confuse  
> people by having 'roundrobin' in one part of dm and 'round-robin'  
> in another!)
>
> When we implement more complex load balancing policies, there seems  
> little point doing everything twice, once for multipath and once  
> for mirroring:-)

Well, actually it would seem to me that mirroring and multi-path are  
both special-cases of a "multi-device" design.  If you can specify  
differing device selection algorithms for read and write paths, then  
you can implement the above as follows:

multipath:
   read  = round-robin
   write = round-robin

mirroring:
   read  = round-robin
   write = all devices

Then new read or write algorithms can be written for different  
situations.  If you need real-time verification of mirrored data, you  
could do "read = all devices".  If you have a 5-disk mirror you might  
write an algorithm which reads all disks and choses the "correct"  
data by voting (then rewrites the sector if any device was wrong).

Cheers,
Kyle Moffett
