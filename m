From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: Re: bug in dm-loop? - was:Re: Re: device mapper
Date: Wed, 24 Jan 2007 18:38:26 +0000
Message-ID: <45B7A7A2.9000106@redhat.com>
References: <1581640279@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1581640279@web.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: devzero@web.de
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

devzero@web.de wrote:
>> Again, to keep things simple in the prototype, we grab the biggest
>> possible table size when we create a new device and then re-allocate it
>> to the correct size when we finish building the map - that's what the
>> "Finalized extent map of 56 bytes, 2 entries." messages refer to.
> 
> may this be a reason why dmlosetup seems to be much slower than traditional losetup?
> i did some tests with some larger images (100m, 1gig and 2,5gig) and dmlosetting them up took quite a while.....
> 

Unfortunately, this is a more fundamental aspect of dm-loop. The way the
code achieves better performance than the regular loop driver is by
doing much of the work upfront when a device is first created. This does
mean that initial setup for a loop device takes longer with dm-loop, and
that time is again proportional to the size/fragmentation of the file.

For many filesystems, you can make 'guesses' that will speed things up,
but this comes at a heavy price. Guess wrong and it leads to data
corruption, so this isn't something we'd feel happy about implementing.

>> the code will fail if it needs >2048 table entries to describe the file
>> - - depending on the filesystem used and how fragmented it is this will
>> limit you to files of a few gigabytes. This is another arbitrary limit
>> in this version that will go away in later dm-loop releases.
> 
> indeed, it looks like there is a real hard 2gb limit - i wasn`t able to dmlosetup the 2,5gig files i created

It's not so much a  hard 2gb limit, but on a cleanly created ext3 or
similar fs, it tends to be around that number. Different filesystem
types or fragmentation levels change that number but they all stem from
the same limitation.

Kind regards,

Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFt6ei6YSQoMYUY94RAu6VAJ0fOkdxJFs2bYZQspfDyJcFxxphLQCgiQN0
6VUI4+o6h/NtJ+bvAbnMjR0=
=aIWR
-----END PGP SIGNATURE-----
