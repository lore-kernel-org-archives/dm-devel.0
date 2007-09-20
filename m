From: Guido Guenther <agx@sigxcpu.org>
Subject: Re: dm-ioctl on amd64 with 32bit userspace
Date: Thu, 20 Sep 2007 09:07:20 +0200
Message-ID: <20070920070720.GA25369@bogon.ms20.nix>
References: <20070917165726.GA11958@bogon.ms20.nix>
	<20070919172650.72df609f.akpm@linux-foundation.org>
	<20070920012448.GL18444@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070920012448.GL18444@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,
On Thu, Sep 20, 2007 at 02:24:48AM +0100, Alasdair G Kergon wrote:
> On Wed, Sep 19, 2007 at 05:26:50PM -0700, Andrew Morton wrote:
> > I don't understand why people aren't running around with their hair on fire
> > over this bug.    Is everyone running 64-bit dmsetup, or what?
>  
> 1) There probably aren't many users in a mixed 32/64 environment;
> 2) The operations triggering the problem are fairly uncommon.
> 
> It's still a surprise nobody noticed this before (with lvrename) as it looks
> like this has always been broken.
> 
> This particular patch looks inadequate though - fixes it for some people
> but breaks it for others?  Other parts of this code call alignment
Well at least it shouldn't break things for others, it just makes the
comparision a bit less strict - I agree that the code doesn't look nice
though.
Cheers,
 -- Guido
