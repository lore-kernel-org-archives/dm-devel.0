From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/6] dm raid45 target: export region hash
	functions and add a needed one
Date: Sat, 11 Jul 2009 08:44:05 -0400
Message-ID: <4E23AE19-2E8A-460D-8DE6-7E23A06775BC@redhat.com>
References: <4a368301.KBrCZcokAm87BF/S%heinzm@redhat.com>
	<20090616140914.GA3348@infradead.org>
	<1245163906.28257.113.camel@o>
	<e9c3a7c20906161055g6434ffd8uc7fc1ca53950556@mail.gmail.com>
	<1245179467.4278.11.camel@o>
	<19000.8388.899607.749942@notabene.brown>
	<19002.60755.876186.489524@notabene.brown>
	<1245407630.12264.66.camel@o>
	<19006.8756.925105.737041@notabene.brown>
	<1245697837.7390.456.camel@o> <1246539130.20207.12.camel@o>
	<19025.28110.236108.810671@notabene.brown>
	<83EE3995-729F-47B6-A03E-768A97D8031E@redhat.com>
	<1247239403.27788.28.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: multipart/mixed; boundary="===============1528842328=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1247239403.27788.28.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============1528842328==
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg=pgp-sha1; boundary="Apple-Mail-71-573590222"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-71-573590222
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Jul 10, 2009, at 11:23 AM, Heinz Mauelshagen wrote:
> Dough,
>
> I extended dm-raid45's message interface to support changing the xor
> algorithm and # of chunks, allowing for changes of the algorithm being
> used at runtime.

Very useful indeed.  I may send you some routines to be tested at some  
point in the future if you don't mind ;-)

> This I used to perform a bunch of mkfs write intensive tests on the
> Intel Core i7 system as an initial write load test case. The tests  
> have
> been run on 8 disks faked onto one SSD using LVM (~200MB sustained
> writes throughput):

That's a little slower than I think you need for a good test.  I'm not  
even sure I'm satisfied that my current SATA array is sufficient and I  
can get at least 500MB/s of write throughput to the disks using a  
raid0, possibly more if I can get a better eSATA port.

> for a in xor_blocks
> do
> 	for c in $(seq 2 6)
> 	do
> 		echo -e "$a $c\n---------------"
> 		dmsetup message r5 0 xor $a $c
> 		for i in $(seq 6)do
> 			time mkfs -t ext3 /dev/mapper/r5
> 		done
> 	done
> done > xor_blocks.out 2>&1
>
> for a in xor_8 xor_16 xor_32 xor_64
> do
> 	for c in $(seq 2 8)
> 	do
> 		echo -e "$a $c\n---------------"
> 		dmsetup message r5 0 xor $a $c
> 		for i in $(seq 6)
> 		do
> 			time mkfs -t ext3 /dev/mapper/r5
> 		done
> 	done
> done > xor_8-64.out 2>&1
>
> Mapping table for r5:
> 0 146800640 raid45 core 2 8192 nosync  raid5_la 7 64 128 8 -1 10  
> nosync 1  8 -1 \
> /dev/tst/raiddev_1 0 /dev/tst/raiddev_2 0 /dev/tst/raiddev_3 0 /dev/ 
> tst/raiddev_4 0 \
> /dev/tst/raiddev_5 0 /dev/tst/raiddev_6 0 /dev/tst/raiddev_7 0 /dev/ 
> tst/raiddev_8 0
>
> I attached filtered output files xor_blocks_1.txt and xor_8-64_1.txt,
> which contain the time information for all the above algorithm/#chunks
> settings.
>
>
> Real time minima:
>
> # egrep '^real' xor_blocks_1.txt|sort|head -1
> real    0m14.508s
> # egrep '^real' xor_8-64_1.txt|sort|head -1
> real    0m14.430s
>
>
> System time minima:
>
> [root@a4 dm-tests]# egrep '^sys' xor_blocks_1.txt|sort|head -1
> sys     0m0.460s
> # egrep '^sys' xor_8-64_1.txt|sort|head -1
> sys     0m0.444s
>
> User time is negligible.
>
>
> This mkfs test case indicates better performance for certain dm-raid45
> xor() settings vs. xor_blocks(). I can get to dbench etc. after my
> vacation in week 31.

Thanks.  This isn't too far off from what I would expect.  I would say  
that real world loads fall all along a spectrum from "create lots of  
writes, but do little to no work" to "does lots of work, and only  
sporadically writes".  It's the later end of this spectrum that is  
most likely to be helped by the cache avoiding routines, while the  
former is not.  So, one of the tests I had in mind was to use  
something like timing a complete kernel build, or doing a database  
load/report cycle, or some other things like that.  Things that do  
actual work in the foreground while the raid is kept busy in the  
background.  Of course, testing all the various points along the  
spectrum is needed, so this test gets us the first.


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-71-573590222
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkpYiRwACgkQQ9aEs6Ims9gf1gCfVz/AQncWstvsashX5IkZiO9C
PGoAnjw//5tUf24wZAh73yy6jcGmavaU
=XJe6
-----END PGP SIGNATURE-----

--Apple-Mail-71-573590222--


--===============1528842328==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1528842328==--
