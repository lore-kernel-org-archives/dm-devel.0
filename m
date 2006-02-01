From: David Wysochanski <davidw@netapp.com>
Subject: Re: default value for rr_min_io too high?
Date: Wed, 01 Feb 2006 13:30:22 -0500
Message-ID: <43E0FE3E.3050402@netapp.com>
References: <43CEB625.9000503@netapp.com> <1137623400.15100.11.camel@zezette>
	<1137801470.18191.16.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1137801470.18191.16.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Christophe Varoqui wrote:
> On mer, 2006-01-18 at 23:29 +0100, Christophe Varoqui wrote:
>  > On mer, 2006-01-18 at 16:41 -0500, David Wysochanski wrote:
>  > > I'm wondering where the value of 1000 came from, and
>  > > whether that's really a good default.
>  > >
>  > > Some preliminary tests I've run with iSCSI seem to indicate
>  > > something lower (say 100) might be a better default, but
>  > > perhaps others have a differing opinion.  I searched the
>  > > list but couldn't find any discussion on it.
>  > >
>  > I'm not really focused on performance, but this seems to be an
>  > io-pattern dependant choice.
>  >
>  > Higher values may help the elevators, (right ?) thus help the seeky
>  > workloads. Lower values may certainly benefit from lower values to
>  > really get the paths summed bandwidth.
>  >
>  > Anyway, I can not back this with numbers. Any value will be fine with me
>  > as a default, and I highlight that now you can also set per device
>  > defaults like rr_min_io in hwtable.c
>  >
> Replying to myself,
> 
> I finally got the chance to challenge my sayings, and I'm proven badly
> wrong :/
> 
> On a StorageWorks EVA110 FC array, 2 active 2Gb/s paths to 2 2Gb/s
> target ports. 1 streaming read (sg_dd dio=1 if=/dev/mapper/mpath0
> of=/dev/null bs=1M count=100k) :
> 
> rr_min_io = 1000 => aggregated throughput = 120 Mo/s
> rr_min_io =  100 => aggregated throughput = 130 Mo/s
> rr_min_io =   50 => aggregated throughput = 200 Mo/s
> rr_min_io =   20 => aggregated throughput = 260 Mo/s
> rr_min_io =   10 => aggregated throughput = 300 Mo/s
> 

What I seemed to see what the larger the I/O size the lower
I needed to go with rr_min_io to get best throughput.  Did
you run it with a smaller block size, say 4k?

I will try to get some more definitive #'s and post.
