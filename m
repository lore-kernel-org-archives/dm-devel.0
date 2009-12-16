From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Shared snapshots
Date: Wed, 16 Dec 2009 03:05:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0912160255370.10656@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I uploaded new shared snapshots here:
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/

changes:

- Broken to separate patches, one patch per file. The last patch adds all 
the files to Makefile and makes it all compile. It allows you to ack 
patches individually. I didn't use stubs to compile intermediate patches, 
the problem is that if multiple patches modify the same file, general 
modifications to the code become harder. With one-patch-per-file I can 
edit it with normal text editor and quilt regenerates the patches.

- Document on-disk format in dm-multisnap-mikulas-struct.h

- More functions are commented

- Removed /*printk ... */ statements. I left some #ifdefed debug routines, 
they are non-trivial to write again

- Fixed a bug on big-endian systems

- Exposed interface for snapshots-of-snapshots, tested that they work

Mikulas
