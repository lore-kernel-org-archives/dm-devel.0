From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Fri, 10 Jul 2009 17:23:23 +0200
Message-ID: <1247239403.27788.28.camel@o>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org> <1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o> <19000.8388.899607.749942@notabene.brown>
	<19002.60755.876186.489524@notabene.brown>
	<1245407630.12264.66.camel@o>
	<19006.8756.925105.737041@notabene.brown> <1245697837.7390.456.camel@o>
	<1246539130.20207.12.camel@o>
	<19025.28110.236108.810671@notabene.brown>
	<83EE3995-729F-47B6-A03E-768A97D8031E@redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-yvmlKsyBcG7eXJxMKoDc"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <83EE3995-729F-47B6-A03E-768A97D8031E@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids


--=-yvmlKsyBcG7eXJxMKoDc
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2009-07-07 at 14:38 -0400, Doug Ledford wrote:
> On Jul 5, 2009, at 11:21 PM, Neil Brown wrote:
> > Here your code seems to be 2-3 times faster!
> > Can you check which function xor_block is using?
> > If it is :
> >  xor: automatically using best checksumming function: ....
> > then it might be worth disabling that test in calibrate_xor_blocks and
> > see if it picks one that ends up being faster.
> >
> > There is still the fact that by using the cache for data that will be
> > accessed once, we are potentially slowing down the rest of the system.
> > i.e. the reason to avoid the cache is not just because it won't
> > benefit the xor much, but because it will hurt other users.
> > I don't know how to measure that effect :-(
> > But if avoiding the cache makes xor 1/3 the speed of using the cache
> > even though it is cold, then it would be hard to justify not using the
> > cache I think.
> 
> So, Heinz and I are actually both looking at xor speed issues, but  
> from two different perspectives.  While he's comparing some of the  
> dmraid45 xor stuff to the xor_blocks routine in crypto/, I'm  
<SNIP>
> So if the error was to not test and optimize these routines under  
> load, then the right course of action would be to do the opposite.   
> And that leads me to believe that the best way to quantify the  
> difference between cache polluting and non-cache polluting should  
> likewise not be done on a quiescent system with a micro benchmark.   
> Instead, we need a holistic performance test to get the truly best xor  
> algorithm.  In my current setup, the disks are so much faster than the  
> single threaded xor thread that the bottleneck is the xor speed.  So,  
> what does it matter if the xor routine doesn't pollute cache if the  
> raid is so slow that programs are stuck in I/O wait all the time as  
> the raid5 thread runs non-stop?  Likewise, who cares what the top  
> speed of a cache polluting xor routine is if in the process it evicts  
> so many cache pages belonging to the processes doing real work on the  
> system that now cache reload becomes the bottleneck.  The ultimate  
> goal of either approach is overall *system* speed, not micro benchmark  
> speed.  I would suggest a specific, system wide workload test that  
> involves a filesystem on a device that uses the particular raid level  
> and parity routine you want to test, and then you need to run that  
> system workload and get a total time required to perform that specific  
> work set, CPU time versus idle+I/O wait time in completing that work  
> set, etc.  Repeat the test for the various algorithms you wish to  
> test, then analyze the results and go from there.  I don't think  
> you're going to get a valid run time test for this, instead we would  
> likely need to create a few heuristic rules that, combined with  
> specific CPU properties, cause us to choose the right routine for the  
> machine.

Dough,

I extended dm-raid45's message interface to support changing the xor
algorithm and # of chunks, allowing for changes of the algorithm being
used at runtime.

This I used to perform a bunch of mkfs write intensive tests on the
Intel Core i7 system as an initial write load test case. The tests have
been run on 8 disks faked onto one SSD using LVM (~200MB sustained
writes throughput):

for a in xor_blocks
do
	for c in $(seq 2 6)
	do
		echo -e "$a $c\n---------------"
		dmsetup message r5 0 xor $a $c
		for i in $(seq 6)do
			time mkfs -t ext3 /dev/mapper/r5
		done
	done
done > xor_blocks.out 2>&1

for a in xor_8 xor_16 xor_32 xor_64
do
	for c in $(seq 2 8)
	do
		echo -e "$a $c\n---------------"
		dmsetup message r5 0 xor $a $c
		for i in $(seq 6)
		do
			time mkfs -t ext3 /dev/mapper/r5
		done
	done
done > xor_8-64.out 2>&1

Mapping table for r5:
0 146800640 raid45 core 2 8192 nosync  raid5_la 7 64 128 8 -1 10 nosync 1  8 -1 \
/dev/tst/raiddev_1 0 /dev/tst/raiddev_2 0 /dev/tst/raiddev_3 0 /dev/tst/raiddev_4 0 \
/dev/tst/raiddev_5 0 /dev/tst/raiddev_6 0 /dev/tst/raiddev_7 0 /dev/tst/raiddev_8 0

I attached filtered output files xor_blocks_1.txt and xor_8-64_1.txt,
which contain the time information for all the above algorithm/#chunks
settings.


Real time minima:

# egrep '^real' xor_blocks_1.txt|sort|head -1
real    0m14.508s
# egrep '^real' xor_8-64_1.txt|sort|head -1
real    0m14.430s


System time minima:

[root@a4 dm-tests]# egrep '^sys' xor_blocks_1.txt|sort|head -1
sys     0m0.460s
# egrep '^sys' xor_8-64_1.txt|sort|head -1
sys     0m0.444s

User time is negligible.


This mkfs test case indicates better performance for certain dm-raid45
xor() settings vs. xor_blocks(). I can get to dbench etc. after my
vacation in week 31.


Heinz


> 
> --
> 
> Doug Ledford <dledford@redhat.com>
> 
> GPG KeyID: CFBFF194
> http://people.redhat.com/dledford
> 
> InfiniBand Specific RPMS
> http://people.redhat.com/dledford/Infiniband
> 
> 
> 
> 

--=-yvmlKsyBcG7eXJxMKoDc
Content-Disposition: attachment; filename="xor_blocks_1.txt"
Content-Type: text/plain; name="xor_blocks_1.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

xor_blocks 2
---------------
real	0m14.513s
user	0m0.000s
sys	0m0.568s
real	0m14.721s
user	0m0.012s
sys	0m0.476s
real	0m14.792s
user	0m0.016s
sys	0m0.568s
real	0m15.037s
user	0m0.008s
sys	0m0.512s
real	0m14.514s
user	0m0.016s
sys	0m0.564s
real	0m14.508s
user	0m0.024s
sys	0m0.512s
xor_blocks 3
---------------
real	0m14.786s
user	0m0.008s
sys	0m0.504s
real	0m14.538s
user	0m0.004s
sys	0m0.504s
real	0m14.738s
user	0m0.012s
sys	0m0.516s
real	0m14.704s
user	0m0.016s
sys	0m0.520s
real	0m14.767s
user	0m0.016s
sys	0m0.500s
real	0m14.510s
user	0m0.020s
sys	0m0.556s
xor_blocks 4
---------------
real	0m14.643s
user	0m0.004s
sys	0m0.536s
real	0m14.647s
user	0m0.032s
sys	0m0.512s
real	0m14.748s
user	0m0.020s
sys	0m0.552s
real	0m14.825s
user	0m0.024s
sys	0m0.520s
real	0m14.829s
user	0m0.008s
sys	0m0.512s
real	0m14.515s
user	0m0.004s
sys	0m0.536s
xor_blocks 5
---------------
real	0m14.764s
user	0m0.008s
sys	0m0.524s
real	0m14.593s
user	0m0.012s
sys	0m0.540s
real	0m14.783s
user	0m0.012s
sys	0m0.504s
real	0m14.632s
user	0m0.008s
sys	0m0.512s
real	0m14.806s
user	0m0.008s
sys	0m0.488s
real	0m14.780s
user	0m0.012s
sys	0m0.528s
xor_blocks 6
---------------
real	0m14.813s
user	0m0.012s
sys	0m0.512s
real	0m14.725s
user	0m0.008s
sys	0m0.524s
real	0m14.518s
user	0m0.016s
sys	0m0.460s
real	0m14.784s
user	0m0.028s
sys	0m0.548s
real	0m14.994s
user	0m0.012s
sys	0m0.516s
real	0m14.803s
user	0m0.012s
sys	0m0.512s

--=-yvmlKsyBcG7eXJxMKoDc
Content-Disposition: attachment; filename="xor_8-64_1.txt"
Content-Type: text/plain; name="xor_8-64_1.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

xor_8 2
---------------
real	0m14.518s
user	0m0.024s
sys	0m0.504s
real	0m14.611s
user	0m0.016s
sys	0m0.508s
real	0m14.838s
user	0m0.020s
sys	0m0.500s
real	0m14.837s
user	0m0.008s
sys	0m0.512s
real	0m14.652s
user	0m0.024s
sys	0m0.460s
real	0m14.954s
user	0m0.016s
sys	0m0.556s
xor_8 3
---------------
real	0m14.866s
user	0m0.004s
sys	0m0.560s
real	0m14.736s
user	0m0.008s
sys	0m0.560s
real	0m14.643s
user	0m0.012s
sys	0m0.444s
real	0m14.817s
user	0m0.012s
sys	0m0.556s
real	0m14.644s
user	0m0.008s
sys	0m0.496s
real	0m14.747s
user	0m0.008s
sys	0m0.568s
xor_8 4
---------------
real	0m14.504s
user	0m0.000s
sys	0m0.568s
real	0m14.889s
user	0m0.012s
sys	0m0.516s
real	0m14.813s
user	0m0.020s
sys	0m0.500s
real	0m14.781s
user	0m0.020s
sys	0m0.496s
real	0m14.657s
user	0m0.012s
sys	0m0.500s
real	0m14.810s
user	0m0.020s
sys	0m0.488s
xor_8 5
---------------
real	0m14.805s
user	0m0.016s
sys	0m0.524s
real	0m14.956s
user	0m0.024s
sys	0m0.520s
real	0m14.619s
user	0m0.012s
sys	0m0.468s
real	0m14.902s
user	0m0.008s
sys	0m0.484s
real	0m14.800s
user	0m0.008s
sys	0m0.512s
real	0m14.866s
user	0m0.008s
sys	0m0.516s
xor_8 6
---------------
real	0m14.834s
user	0m0.032s
sys	0m0.476s
real	0m14.661s
user	0m0.008s
sys	0m0.560s
real	0m14.809s
user	0m0.016s
sys	0m0.528s
real	0m14.828s
user	0m0.016s
sys	0m0.568s
real	0m14.801s
user	0m0.008s
sys	0m0.516s
real	0m14.811s
user	0m0.012s
sys	0m0.524s
xor_8 7
---------------
real	0m14.889s
user	0m0.020s
sys	0m0.520s
real	0m14.525s
user	0m0.012s
sys	0m0.548s
real	0m14.767s
user	0m0.008s
sys	0m0.560s
real	0m14.803s
user	0m0.012s
sys	0m0.584s
real	0m14.641s
user	0m0.016s
sys	0m0.608s
real	0m14.810s
user	0m0.016s
sys	0m0.500s
xor_8 8
---------------
real	0m14.719s
user	0m0.016s
sys	0m0.540s
real	0m14.825s
user	0m0.016s
sys	0m0.572s
real	0m14.842s
user	0m0.008s
sys	0m0.552s
real	0m14.811s
user	0m0.016s
sys	0m0.508s
real	0m14.518s
user	0m0.012s
sys	0m0.544s
real	0m14.768s
user	0m0.024s
sys	0m0.500s
xor_16 2
---------------
real	0m14.839s
user	0m0.008s
sys	0m0.576s
real	0m14.517s
user	0m0.020s
sys	0m0.528s
real	0m14.810s
user	0m0.008s
sys	0m0.532s
real	0m14.888s
user	0m0.028s
sys	0m0.520s
real	0m14.811s
user	0m0.012s
sys	0m0.544s
real	0m14.794s
user	0m0.012s
sys	0m0.472s
xor_16 3
---------------
real	0m14.766s
user	0m0.008s
sys	0m0.512s
real	0m14.809s
user	0m0.020s
sys	0m0.488s
real	0m14.582s
user	0m0.008s
sys	0m0.500s
real	0m14.767s
user	0m0.008s
sys	0m0.552s
real	0m14.899s
user	0m0.008s
sys	0m0.528s
real	0m14.812s
user	0m0.004s
sys	0m0.524s
xor_16 4
---------------
real	0m14.827s
user	0m0.004s
sys	0m0.528s
real	0m14.769s
user	0m0.008s
sys	0m0.588s
real	0m14.541s
user	0m0.012s
sys	0m0.572s
real	0m14.788s
user	0m0.016s
sys	0m0.592s
real	0m15.482s
user	0m0.004s
sys	0m0.568s
real	0m14.780s
user	0m0.020s
sys	0m0.524s
xor_16 5
---------------
real	0m14.686s
user	0m0.024s
sys	0m0.500s
real	0m14.782s
user	0m0.012s
sys	0m0.468s
real	0m14.802s
user	0m0.008s
sys	0m0.456s
real	0m14.896s
user	0m0.008s
sys	0m0.548s
real	0m14.821s
user	0m0.004s
sys	0m0.532s
real	0m14.806s
user	0m0.028s
sys	0m0.492s
xor_16 6
---------------
real	0m14.735s
user	0m0.004s
sys	0m0.576s
real	0m14.926s
user	0m0.024s
sys	0m0.564s
real	0m14.912s
user	0m0.016s
sys	0m0.528s
real	0m14.830s
user	0m0.016s
sys	0m0.492s
real	0m14.751s
user	0m0.020s
sys	0m0.524s
real	0m14.492s
user	0m0.012s
sys	0m0.500s
xor_16 7
---------------
real	0m14.821s
user	0m0.016s
sys	0m0.444s
real	0m14.714s
user	0m0.012s
sys	0m0.476s
real	0m14.956s
user	0m0.008s
sys	0m0.544s
real	0m14.755s
user	0m0.012s
sys	0m0.552s
real	0m14.605s
user	0m0.004s
sys	0m0.488s
real	0m14.750s
user	0m0.012s
sys	0m0.564s
xor_16 8
---------------
real	0m14.702s
user	0m0.012s
sys	0m0.460s
real	0m14.797s
user	0m0.012s
sys	0m0.472s
real	0m14.629s
user	0m0.016s
sys	0m0.572s
real	0m14.841s
user	0m0.012s
sys	0m0.488s
real	0m14.768s
user	0m0.020s
sys	0m0.472s
real	0m14.483s
user	0m0.008s
sys	0m0.532s
xor_32 2
---------------
real	0m19.783s
user	0m0.004s
sys	0m0.528s
real	0m14.670s
user	0m0.012s
sys	0m0.448s
real	0m14.913s
user	0m0.020s
sys	0m0.496s
real	0m14.816s
user	0m0.012s
sys	0m0.524s
real	0m14.874s
user	0m0.016s
sys	0m0.560s
real	0m14.815s
user	0m0.004s
sys	0m0.572s
xor_32 3
---------------
real	0m14.751s
user	0m0.016s
sys	0m0.512s
real	0m14.605s
user	0m0.008s
sys	0m0.508s
real	0m14.699s
user	0m0.004s
sys	0m0.576s
real	0m14.674s
user	0m0.004s
sys	0m0.512s
real	0m14.872s
user	0m0.012s
sys	0m0.540s
real	0m14.801s
user	0m0.024s
sys	0m0.504s
xor_32 4
---------------
real	0m14.780s
user	0m0.028s
sys	0m0.504s
real	0m14.802s
user	0m0.008s
sys	0m0.500s
real	0m14.624s
user	0m0.008s
sys	0m0.516s
real	0m14.779s
user	0m0.028s
sys	0m0.536s
real	0m14.953s
user	0m0.012s
sys	0m0.544s
real	0m14.571s
user	0m0.016s
sys	0m0.500s
xor_32 5
---------------
real	0m14.843s
user	0m0.008s
sys	0m0.544s
real	0m14.822s
user	0m0.016s
sys	0m0.540s
real	0m14.583s
user	0m0.016s
sys	0m0.520s
real	0m15.138s
user	0m0.008s
sys	0m0.508s
real	0m14.718s
user	0m0.012s
sys	0m0.548s
real	0m14.547s
user	0m0.012s
sys	0m0.552s
xor_32 6
---------------
real	0m14.744s
user	0m0.012s
sys	0m0.488s
real	0m14.856s
user	0m0.016s
sys	0m0.532s
real	0m14.717s
user	0m0.024s
sys	0m0.552s
real	0m14.777s
user	0m0.008s
sys	0m0.564s
real	0m14.761s
user	0m0.016s
sys	0m0.496s
real	0m14.706s
user	0m0.012s
sys	0m0.560s
xor_32 7
---------------
real	0m14.790s
user	0m0.004s
sys	0m0.568s
real	0m14.797s
user	0m0.016s
sys	0m0.488s
real	0m14.708s
user	0m0.012s
sys	0m0.512s
real	0m14.838s
user	0m0.016s
sys	0m0.512s
real	0m14.748s
user	0m0.008s
sys	0m0.476s
real	0m14.507s
user	0m0.008s
sys	0m0.512s
xor_32 8
---------------
real	0m15.055s
user	0m0.004s
sys	0m0.468s
real	0m14.839s
user	0m0.016s
sys	0m0.564s
real	0m14.551s
user	0m0.020s
sys	0m0.468s
real	0m14.789s
user	0m0.020s
sys	0m0.488s
real	0m14.495s
user	0m0.004s
sys	0m0.556s
real	0m14.852s
user	0m0.032s
sys	0m0.552s
xor_64 2
---------------
real	0m14.749s
user	0m0.028s
sys	0m0.472s
real	0m14.576s
user	0m0.016s
sys	0m0.544s
real	0m14.880s
user	0m0.004s
sys	0m0.496s
real	0m14.789s
user	0m0.016s
sys	0m0.588s
real	0m14.504s
user	0m0.020s
sys	0m0.568s
real	0m14.847s
user	0m0.016s
sys	0m0.548s
xor_64 3
---------------
real	0m14.812s
user	0m0.012s
sys	0m0.492s
real	0m23.521s
user	0m0.012s
sys	0m0.552s
real	0m14.580s
user	0m0.004s
sys	0m0.552s
real	0m14.711s
user	0m0.028s
sys	0m0.524s
real	0m14.817s
user	0m0.016s
sys	0m0.544s
real	0m14.773s
user	0m0.008s
sys	0m0.468s
xor_64 4
---------------
real	0m14.722s
user	0m0.008s
sys	0m0.516s
real	0m14.881s
user	0m0.008s
sys	0m0.520s
real	0m14.821s
user	0m0.012s
sys	0m0.520s
real	0m15.190s
user	0m0.020s
sys	0m0.456s
real	0m14.780s
user	0m0.016s
sys	0m0.448s
real	0m14.762s
user	0m0.004s
sys	0m0.564s
xor_64 5
---------------
real	0m14.688s
user	0m0.016s
sys	0m0.488s
real	0m14.559s
user	0m0.004s
sys	0m0.528s
real	0m14.829s
user	0m0.020s
sys	0m0.520s
real	0m14.818s
user	0m0.016s
sys	0m0.500s
real	0m14.812s
user	0m0.008s
sys	0m0.500s
real	0m14.804s
user	0m0.004s
sys	0m0.480s
xor_64 6
---------------
real	0m14.742s
user	0m0.024s
sys	0m0.476s
real	0m14.882s
user	0m0.020s
sys	0m0.528s
real	0m14.589s
user	0m0.012s
sys	0m0.512s
real	0m14.832s
user	0m0.004s
sys	0m0.504s
real	0m14.638s
user	0m0.012s
sys	0m0.444s
real	0m14.767s
user	0m0.008s
sys	0m0.536s
xor_64 7
---------------
real	0m14.790s
user	0m0.012s
sys	0m0.560s
real	0m14.749s
user	0m0.016s
sys	0m0.476s
real	0m14.430s
user	0m0.016s
sys	0m0.540s
real	0m14.694s
user	0m0.012s
sys	0m0.556s
real	0m14.567s
user	0m0.016s
sys	0m0.488s
real	0m14.753s
user	0m0.016s
sys	0m0.536s
xor_64 8
---------------
real	0m14.816s
user	0m0.008s
sys	0m0.544s
real	0m14.704s
user	0m0.020s
sys	0m0.516s
real	0m14.613s
user	0m0.012s
sys	0m0.548s
real	0m14.900s
user	0m0.008s
sys	0m0.532s
real	0m14.586s
user	0m0.012s
sys	0m0.464s
real	0m14.692s
user	0m0.016s
sys	0m0.520s

--=-yvmlKsyBcG7eXJxMKoDc
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-yvmlKsyBcG7eXJxMKoDc--
