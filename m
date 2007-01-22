From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: bug in dm-loop? - was:Re: Re: device mapper
 integrated loops - and one more year !
Date: Mon, 22 Jan 2007 22:10:29 +0000
Message-ID: <45B53655.1040209@redhat.com>
References: <1574903375@web.de> <45B48B50.8070009@redhat.com>
	<083901c73e70$ccd85f60$eeeea8c0@aldipc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <083901c73e70$ccd85f60$eeeea8c0@aldipc>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: roland <devzero@web.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

roland wrote:
> Hi Bryn,
> 
>> I'll also get the version on kernel.org updated - thanks for catching
>> this!
> 
> thanks very much for that quick patch - it works as expected and the
> kernel oops went away!

Your very welcome! I'm glad it addressed the problem & it's good to get
some feedback on dm-loop.

> since i want to use dm-loop for having a large number of loop-devices, i
> did some more "hardcore testing". ;)
> 
> so, i wrote a little test script which created a lot of dummy-files and
> turning them into a dm-loop target.
> 
> this worked very well - must have been around 3000 loop-targets when i
> got this one:

That's useful to know - this is a known limitation of the current code.

It simply allocates one big area of memory to store the lookup table for
the device. These kind of large, contiguous allocations are a "bad
thing" in the kernel, as you get failures of the kind you noted when
memory gets tight/fragmented.

> this was on a system with 256 MB of ram.
> 
> i assume, that i ran out of some kernel-buffer memory.
> 
> ok, not a real problem for me since i don`t expect having that much
> number of iso images on my cd-roms server to be loopback mounted, but -
> anyway - could you probably give a comment on this ?
> 
> is this some "natural limitation" due to dm-loop or device mapper
> consuming kernel-memory, or could this be another bug ?
> 

The current development version allocates these structures piecemeal, so
there isn't a single large allocation, rather many small allocations -
this will make problems like this go away (unless you really are out of
memory!).

You're particularly likely to see these problems with large images such
as DVD ISOs, as the number of entries in the lookup table is
proportional to the size of the image and the degree of fragmentation of
the filesystem on which it is stored.

Thanks again for testing!

Bryn.




-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFtTZV6YSQoMYUY94RAhpAAJ46Bqw+qBEVzapdKZh2V2nbx4AzHACePfsV
ttYf/s/ed3z/cBeCHEE09FY=
=ds+L
-----END PGP SIGNATURE-----
