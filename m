From: "Rik Snel" <rsnel@cube.dyndns.org>
Subject: ABL-{32,*}-AES
Date: Sun,  3 Dec 2006 13:48:20 +0100
Message-ID: <11651501031841-git-send-email-rsnel@cube.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: herbert@gondor.apana.org.au
List-Id: dm-devel.ids


Hello list,

I'm working on an ABL-32-AES (and a more general ABL-*-AES) implementation
for the Linux kernel as proposed by John Viega and David McGrew in
http://grouper.ieee.org/groups/1619/email/rtf00000.rtf (October 28, 2004) and
http://grouper.ieee.org/groups/1619/email/pdf00005.pdf (April 15, 2004).
The spec is not sufficiently reviewed and the two documents seem to 
contradict eachother in a few places. Therefore the implementation
of the ABL blockcipher mode itself is preliminary.

ABL allows to turn a blockcipher with a blocksize of 16 bytes into a 
blockcipher of arbitrary block size (for example 512 (dm sector size) 
and 4k (x86 page size)). The mode is (according to it's creators)
unencumbered by patents (other well known modes, CMC, EME, EME* and
XCB, are).

To get ABL-32-AES to work, a new IV is needed: 'bewbi' ('big-endian' wide 
block count'). It counts the number of wide blocks in bigendian format
starting at 1. The first patch adds this IV mode.

For 4k blocks (cipherblocksize equal to PAGE_SIZE and ext3fs max blocksize
on x86) another change is needed to dm-crypt, it adds an optional argument
to dm-crypt (the extra shift, eg extra_shift=1 gives cipherblocks of 1k).
It works for me, but I don't know if my implementation is correct.

For completeness I include the patch that introduces the ABL blockcipher 
mode itself.

The patches are against the current cryptodev-2.6 tree, and if no-one objects
the dm-crypt patches will probably go there. 

Greetings,

Rik.
