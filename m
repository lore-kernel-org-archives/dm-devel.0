From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-ioctl on amd64 with 32bit userspace
Date: Thu, 20 Sep 2007 02:24:48 +0100
Message-ID: <20070920012448.GL18444@agk.fab.redhat.com>
References: <20070917165726.GA11958@bogon.ms20.nix>
	<20070919172650.72df609f.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070919172650.72df609f.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>, Guido Guenther <agx@sigxcpu.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 19, 2007 at 05:26:50PM -0700, Andrew Morton wrote:
> I don't understand why people aren't running around with their hair on fire
> over this bug.    Is everyone running 64-bit dmsetup, or what?
 
1) There probably aren't many users in a mixed 32/64 environment;
2) The operations triggering the problem are fairly uncommon.

It's still a surprise nobody noticed this before (with lvrename) as it looks
like this has always been broken.

This particular patch looks inadequate though - fixes it for some people
but breaks it for others?  Other parts of this code call alignment
functions and store offsets explicitly and probably something similar
should be happening here - with userspace libdevmapper changes too.
Let me consider the alternatives and their consequences.

> This looks like 2.6.22 and 2.6.23 material to me.  Alasdair?

When we have a complete fix, yes.

Alasdair
-- 
agk@redhat.com
