From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: Help tracking down problem --- endless loop in __find_get_block_slow
Date: Tue, 22 Feb 2005 17:46:55 -0500
Message-ID: <421BB65F.7040306@suse.com>
References: <4219BC1A.1060007@zensonic.dk> <20050222011821.2a917859.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050222011821.2a917859.akpm@osdl.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Thomas S. Iversen" <zensonic@zensonic.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andrew Morton wrote:
> "Thomas S. Iversen" <zensonic@zensonic.dk> wrote:
> 
>>But if I do
>>
>> dd if=/dev/zero of=/mnt/testfile count=N, N>6
>>
>> I get into an endless loop in __find_get_block_slow. 
> 
> 
> The only way in which __find_get_block_slow() can loop is if something
> wrecked the buffer_head ring at page->private: something caused an internal
> loop via bh->b_this_page.
> 
> Are you sure that's where things are hanging?  That it's not stuck on a
> spinlock?
> 
> A sysrq-P trace might help.

I've observed similar effects without DM involved at all. I've been able
to reproduce using subfs (it brings out umount races nicely) on kernels
from 2.6.5 to 2.6.11-rc4, it's platform and device independent.

In my experience, the loop is actually outside of
__find_get_block_slow(), in __getblk_slow(). I've been using xmon to
interrupt the kernel, and the results vary but are all rooted in the
for(;;) loop in __getblk_slow. It appears as though grow_buffers is
finding/creating the page, but then __find_get_block can't locate the
buffer it needs.

- -Jeff

- --
Jeff Mahoney
SuSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCG7ZeLPWxlyuTD7IRAixHAJsHORHEMfFtTIozqwUOkk9WGFxCggCgiSfn
V3kCyFn/X87Mw4laVsJLUp4=
=YNSw
-----END PGP SIGNATURE-----
