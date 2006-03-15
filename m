From: David Wysochanski <davidw@netapp.com>
Subject: Re: default value for rr_min_io too high?
Date: Wed, 15 Mar 2006 11:19:19 -0500
Message-ID: <44183E87.1050902@netapp.com>
References: <43CEB625.9000503@netapp.com>
	<1137623400.15100.11.camel@zezette><1137801470.18191.16.camel@zezette>
	<43E0FE3E.3050402@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43E0FE3E.3050402@netapp.com>
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
Cc: christophe.varoqui@free.fr
List-Id: dm-devel.ids

Wysochanski, David wrote:
>
> Christophe Varoqui wrote:
> > On mer, 2006-01-18 at 23:29 +0100, Christophe Varoqui wrote:
> >  > On mer, 2006-01-18 at 16:41 -0500, David Wysochanski wrote:
> >  > > I'm wondering where the value of 1000 came from, and
> >  > > whether that's really a good default.
> >  > >
> >  > > Some preliminary tests I've run with iSCSI seem to indicate
> >  > > something lower (say 100) might be a better default, but
> >  > > perhaps others have a differing opinion.  I searched the
> >  > > list but couldn't find any discussion on it.
> >  > >
> >  > I'm not really focused on performance, but this seems to be an
> >  > io-pattern dependant choice.
> >  >
> >  > Higher values may help the elevators, (right ?) thus help the seeky
> >  > workloads. Lower values may certainly benefit from lower values to
> >  > really get the paths summed bandwidth.
> >  >
> >  > Anyway, I can not back this with numbers. Any value will be fine 
> with me
> >  > as a default, and I highlight that now you can also set per device
> >  > defaults like rr_min_io in hwtable.c
> >  >
> > Replying to myself,
> >
> > I finally got the chance to challenge my sayings, and I'm proven badly
> > wrong :/
> >
> > On a StorageWorks EVA110 FC array, 2 active 2Gb/s paths to 2 2Gb/s
> > target ports. 1 streaming read (sg_dd dio=1 if=/dev/mapper/mpath0
> > of=/dev/null bs=1M count=100k) :
> >
> > rr_min_io = 1000 => aggregated throughput = 120 Mo/s
> > rr_min_io =  100 => aggregated throughput = 130 Mo/s
> > rr_min_io =   50 => aggregated throughput = 200 Mo/s
> > rr_min_io =   20 => aggregated throughput = 260 Mo/s
> > rr_min_io =   10 => aggregated throughput = 300 Mo/s
> >
>
> What I seemed to see what the larger the I/O size the lower
> I needed to go with rr_min_io to get best throughput.  Did
> you run it with a smaller block size, say 4k?
>
> I will try to get some more definitive #'s and post.
>
> -- 
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
As promised, here's some data I ran on a netapp filer with iscsi and
dm-multipath with a tool that is similar to iometer (multithreaded
and generates direct IOs, one per thread).  In general, I agree
about needing to tune for a given configuration as there's multiple
levels of queuing, and rr_min_io should make sense with all of that,
the workload, etc.

DISCLAIMER: This shouldn't be viewed as official perf numbers for
netapp filers but was just done to tune rr_min_io.  Also, the
test had a very small # of disk spindles so don't read too much
into things like low overall throughput on 100% WRITEs.

Initiator:
- rhel4 u3, 2 GigE NICs

Target:
- netapp filer, 2 iSCSI ports
- single lun exported to host via both ports

                                        rr_min_io
I/O size          8       16      32      64      128     256     
512     1024
------------------------------------------------------------------------------
512byte           9       9       9.6     9.3     9.3     9.7      
10      10
4k               53      54      57      58      63      61        
58      56
8k               85      85      87      86      85      77        
75      73
64k             109     110     111     109     109      94        
93      93
256k            134     136     135     134     133     134       
135     126
------------------------------------------------------------------------------
Throughput (MB/s) for a given I/O size and rr_min_io value
128 threads, 60/40 read/write, 100% random


                                        rr_min_io
I/O size          8       16      32      64      128     256     
512     1024
------------------------------------------------------------------------------
512byte          12       12      12      12       11      11      
11      11
4k               67       70      69      70       73      75      
74      75
8k              107      108     107     109      109     101      
90      95
64k             167      168     168     168      168     153     
129     120
256k            175      174     175     174      175     177     
174     156
------------------------------------------------------------------------------
Throughput (MB/s) for a given I/O size and rr_min_io value
128 threads, 100% read, 100% sequential, 100MB working set (cached reads)



                                        rr_min_io
I/O size          8       16      32      64      128     256     
512     1024
------------------------------------------------------------------------------
512byte           7.8      8       8       8        9       9       
9       9
4k               44       44      44      45       44      41      
40      40
8k               65       65      64      63       62      57      
55      53
64k              69       70      70      70       69      66      
62      58
256k             92       95      93      94       93      94      
93      84
------------------------------------------------------------------------------
Throughput (MB/s) for a given I/O size and rr_min_io value
128 threads, 100% write, 100% sequential


                                        rr_min_io
I/O size          8       16      32      64      128     256     
512     1024
------------------------------------------------------------------------------
512byte          11.5     12      12      11.7     11      11      
11       11
4k               66       70      70      71       74      75      
73       75
8k              107      108     108     109      109     100      
89       95
64k             167      168     169     169      170     154     
128      120
256k            172      173     174     171      173     174     
168      153
------------------------------------------------------------------------------
Throughput (MB/s) for a given I/O size and rr_min_io value
128 threads, 100% read, 100% random


                                        rr_min_io
I/O size          8       16      32      64      128     256     
512     1024
------------------------------------------------------------------------------
512byte           7.6      8       8       8        9       9       
8.7    8.5
4k               45       45      45      46       45      42      40     38
8k               66       67      65      65       64      59      55     52
64k              71       71      71      71       70      65      61     58
256k             93       93      95      95       95      94      94     85
------------------------------------------------------------------------------
Throughput (MB/s) for a given I/O size and rr_min_io value
128 threads, 100% write, 100% random
