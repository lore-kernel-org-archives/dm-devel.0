From: zensonic@zensonic.dk (Thomas S. Iversen)
Subject: Re: Help tracking down problem --- endless loop in
	__find_get_block_slow
Date: Wed, 23 Feb 2005 14:02:51 +0100
Message-ID: <20050223130251.GA31851@zensonic.dk>
References: <4219BC1A.1060007@zensonic.dk>
	<20050222011821.2a917859.akpm@osdl.org>
	<20050223120013.GA28169@zensonic.dk>
	<20050223041036.5f5df2ff.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050223041036.5f5df2ff.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

> OK, so we're looking for the buffer_head for block 101 and the first
> buffer_head which is attached to the page represents block 100.  So the
> next buffer_head _should_ represent block 101.  Please print it out:

Not quite the same, but simelar:

Feb 23 14:50:24 localhost kernel: __find_get_block_slow() failed. block=102,
b_blocknr=128, next=129
Feb 23 14:50:24 localhost kernel: b_state=0x00000013, b_size=2048
Feb 23 14:50:24 localhost kernel: device blocksize: 2048
Feb 23 14:50:24 localhost kernel: ------------[ cut here ]------------

> Could be UFS.  But what does "transparent block encryption and sector
> shuffling" mean?  How is the sector shuffling implemented?

GDBE is a block level encrypter. It encrypts the actual sectors
transparently via the GEOM API (corresponds to the devicemapper api in linux).

GBDE assigns a key for each block, thereby introducing keysectors.
Furthermore the sectors are remapped so that one can not guess where e.g.
metadata is located on the physical disk. It is a rather simple remap:

Taken from GDBE:

/*
 * Convert an unencrypted side offset to offsets on the encrypted side.
 *
 * Security objective:  Make it harder to identify what sectors contain what
 * on a "cold" disk image.
 *
 * We do this by adding the "keyoffset" from the lock to the physical sector
 * number modulus the available number of sectors.  Since all physical sectors
 * presumably look the same cold, this will do.
 *
 * As part of the mapping we have to skip the lock sectors which we know
 * the physical address off.  We also truncate the work packet, respecting
 * zone boundaries and lock sectors, so that we end up with a sequence of
 * sectors which are physically contiguous.
 *
 * Shuffling things further is an option, but the incremental frustration is
 * not currently deemed worth the run-time performance hit resulting from the
 * increased number of disk arm movements it would incur.
 *
 * This function offers nothing but a trivial diversion for an attacker able
 * to do "the cleaning lady attack" in its current static mapping form.
 */"
  
Further reading:

	http://phk.freebsd.dk/pubs/bsdcon-03.gbde.paper.pdf

Regards Thomas
