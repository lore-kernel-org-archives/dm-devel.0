From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: bug in dm-loop? - was:Re: Re: device mapper
 integrated loops - and one more year !
Date: Mon, 22 Jan 2007 23:20:06 +0000
Message-ID: <45B546A6.3030608@redhat.com>
References: <1574903375@web.de> <45B48B50.8070009@redhat.com>
	<083901c73e70$ccd85f60$eeeea8c0@aldipc>
	<45B53655.1040209@redhat.com>
	<087b01c73e76$9ccf68d0$eeeea8c0@aldipc>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <087b01c73e76$9ccf68d0$eeeea8c0@aldipc>
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
>> You're particularly likely to see these problems with large images such
>> as DVD ISOs, as the number of entries in the lookup table is
>> proportional to the size of the image and the degree of fragmentation of
>> the filesystem on which it is stored.
> uuuhhhhh - mhhhh - this sounds bad, since the testfiles i created were
> all sized 100k each.

With ~3000 of them active concurrently on a machine with 256M of RAM,
I'm not that surprised that you hit this limit!

Again, to keep things simple in the prototype, we grab the biggest
possible table size when we create a new device and then re-allocate it
to the correct size when we finish building the map - that's what the
"Finalized extent map of 56 bytes, 2 entries." messages refer to.

If debugging was enabled when the module was built, you should also see
messages like:

 loop: [DEBUG] setup_loop_extents:Allocated initial extent map of 57352
bytes, 2048 entries.

It's these initial large allocations that are causing the errors you see.

The code's pretty dumb in this area at the moment - improving memory
allocation and the time spent looking up entries in the table are our
current goals for dm-loop.

> i think i need to attach a big disk and create some more big files to
> test with....

The code will fail if it needs >2048 table entries to describe the file
- - depending on the filesystem used and how fragmented it is this will
limit you to files of a few gigabytes. This is another arbitrary limit
in this version that will go away in later dm-loop releases.

Kind regards,

Bryn.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFtUam6YSQoMYUY94RAlMnAJ9C3fivcmwgcWiA8G5UIULB1BwnPgCgyrIO
n1QfreVTGUNfMHA6bRWdzwI=
=AV8G
-----END PGP SIGNATURE-----
