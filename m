From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [2.6.24 PATCH 02/25] dm io:ctl use constant struct
	size
Date: Mon, 15 Oct 2007 02:26:21 +0100
Message-ID: <20071015012621.GD10006@agk.fab.redhat.com>
References: <20071012170509.GM24157@agk.fab.redhat.com>
	<200710130016.29937.arnd@arndb.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200710130016.29937.arnd@arndb.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Corry <kevcorry@us.ibm.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
List-Id: dm-devel.ids

On Sat, Oct 13, 2007 at 12:16:29AM +0200, Arnd Bergmann wrote:
> This change seems rather bogus, you're changing the ABI just to work
> around a bug in the compat_ioctl layer. Why not just do the compat
> code the right way, like the patch below?

The underlying ABI is not changing, I hope - the trailing padding in the
struct should not affect the processing of the data by dm, and I see no
reason to continue maintaining the fiction that the 32-bit and 64-bit
ioctls are in some way incompatible with each other when they aren't
AFAIK.

And yes, a follow-up patch can clean up our use of the compatibility
mechanism, going a little bit further than the patch you attached, I
hope.

Alasdair
-- 
agk@redhat.com
