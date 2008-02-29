From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Sat, 1 Mar 2008 02:15:51 +0800
Message-ID: <20080229181551.GA28193@gondor.apana.org.au>
References: <200802281924.03996.rrs@researchut.com>
	<20080228232048.51e28c1d.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080228232048.51e28c1d.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ritesh Raj Sarraf <rrs@researchut.com>, Christophe Saout <christophe@saout.de>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Feb 28, 2008 at 11:20:48PM -0800, Andrew Morton wrote:
>
> Now, I'm assuming that it's just unreasonable for a machine to spend a full
> 11 seconds crunching away on crypto in that code path.  Maybe it _is_
> reasonable, and all we need to do is to poke a cond_resched() in there
> somewhere.  Herbert, any thoughts?  What's the speed of that code?

It encryps 512 bytes each time so it should definitely be pretty
quick.  Perhaps the caller is disabling interrupts or something?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
