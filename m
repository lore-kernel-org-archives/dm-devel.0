From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: Re: device mapper integrated loops - and one more
	year !
Date: Wed, 22 Nov 2006 21:37:43 +0000
Message-ID: <4564C327.1080101@redhat.com>
References: <1439173022@web.de>	<45636B89.7080407@redhat.com>	<456375CF.10006@rolandpj.com>	<456389C4.9000902@redhat.com>
	<45640A4E.9090509@rolandpj.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <45640A4E.9090509@rolandpj.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Roland Paterson-Jones wrote:
> We very much need sparse files for our use-case (fairly dynamically
> setting up (fake) devices on demand). Sparse files save time to copy,
> for example.
> 
> Would you do this by using file ops to lazily fill holes on first write?
> Is this compatible with S_SWAPFILE? For read purposes, holes can be
> mapped to zero device, I presume.

That's what I figured - lazy allocation seems to be the main reason that
sparse files are desirable.

The problem with sparse files is that they make us do something that
dm-loop is explicitly trying to avoid - calling into the filesystem at
I/O time.

There are two ways we can address this. The dm-loop target needs a
non-bmap based fallback for filesystems that can't use direct mapping
anyway (e.g. network filesystems).

We can either revert to this mechanism entirely for sparse files (means
we get many of the drawbacks of regular /dev/loopN), or try to support
mixed extent types. That's had some thought & discussion but we don't
have an implementation ready yet.

> Ah. I did see that - should have made the connection. So which file
> systems support (obey?) S_SWAPFILE?

Currently this is handled in the VFS. Currently the only filesystem that
explicitly checks for S_SWAPFILE is NFS. Filesystems that support online
defragmentation will need to be aware of this flag.

> I much prefer the approach of mapping to underlying device, cos it
> sidesteps the file/page cache (loopback causes OOM!). The other annoying
> thing about loopback is that it re-nices itself to super-low (should
> that be high?) priority, so we can starve other system daemons by
> banging on the loopback device.

This is really the motivation for dm-loop: avoiding unpredictable memory
allocation at I/O time and the need for a per-device kernel thread. It
also ends up simplifying the code a great deal. Early figures on
performance are also suggesting wins in that area.

>> There are patches to dmsetup that allow it to be called as "losetup" or
>> "dmlosetup", providing the same options as the regular version, so it
>> should be straightforward to compare.
>>  
>>
> Cool. Where can I get a patch to play with? I presume device-mapper
> plug-ins can be compiled as modules?

The patch currently on kernel.org uses a table format like this:
<start> <len> loop <path> <offset>

So losetup /dev/loop0 /tmp/file
  becomes roughly
dmsetup create loop0 --table "0 N loop /tmp/file 0"
  --table option is now in cvs; else use stdin
  N is the <filesize_in_bytes>/512
  make file a multiple of your page size & fs block size

If your dmsetup is recent enough to have the --table option.

I was just digging out the dmlosetup patch when I noticed it's already
present in recent CVS - if you build dmsetup from there, you should be
able to symlink dmsetup as losetup/dmlosetup and call it like the
regular version.

Regards,
Bryn.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFZMMn6YSQoMYUY94RAvkPAKCWNrp2VghDpu1qd7nC2J/OgwQF+gCcCjvV
3PbJcCxOqZIpteMsNKht3Js=
=B/b2
-----END PGP SIGNATURE-----
