From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [2.6.24 PATCH 02/25] dm io:ctl use constant struct
	size
Date: Mon, 15 Oct 2007 09:34:09 +0200
Message-ID: <200710150934.09842.arnd@arndb.de>
References: <20071012170509.GM24157@agk.fab.redhat.com>
	<200710130016.29937.arnd@arndb.de>
	<20071015012621.GD10006@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071015012621.GD10006@agk.fab.redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>, Guido Guenther <agx@sigxcpu.org>, Kevin Corry <kevcor>
List-Id: dm-devel.ids

On Monday 15 October 2007, Alasdair G Kergon wrote:
> The underlying ABI is not changing, I hope - the trailing padding in the
> struct should not affect the processing of the data by dm, and I see no
> reason to continue maintaining the fiction that the 32-bit and 64-bit
> ioctls are in some way incompatible with each other when they aren't
> AFAIK.

It's a corner case of some sort, as DM uses ioctl numbers differently
from most subsystems by splitting to code from the size argument
during processing. Your change is certainly not an _incompatible_
change to the ABI, but 32 bit binaries compiled against the new
headers will use different ioctl numbers from those built against
older headers.

This may break other code that expects a specific number, even
if your handler does not care. The old compat code handles both
variants (no variable size arguments), but /usr/bin/strace may have
encoded only one set of numbers AFAICT.

> And yes, a follow-up patch can clean up our use of the compatibility
> mechanism, going a little bit further than the patch you attached, I
> hope.

Ok, sounds good. I don't think it's the kind of patch that should go
into stable backports though.

	Arnd <><
