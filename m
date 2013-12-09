From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: Kernel oops with dm-cache
Date: Mon, 9 Dec 2013 11:42:33 +0100
Message-ID: <20131209104233.GC15782@samfundet.no>
References: <20131208105930.GA3763@sesse.net>
	<20131208120152.GA4096@samfundet.no>
	<CAMM=eLcZdULJZaAfwct1Bnj4KjNxOBrBumeb_vM+PtdjErQ5fA@mail.gmail.com>
	<20131209092807.GA4323@samfundet.no>
	<20131209103813.GD26971@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131209103813.GD26971@debian>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Dec 09, 2013 at 10:38:14AM +0000, Joe Thornber wrote:
> My gut feel is you're running out of metadata space for some reason.
> How big is your metadata device?  (Obviously this is no excuse for the
> crashing).

It's 512MB.

> I'm really surprised that cache_dump is giving wrong information;
> saying everything is clean, saying you were using the cleaner policy
> etc.  Are you sure you're passing it the right metadata dev?

Yes, I'm positive. There's only one metadata device on the system.

I've sent you a link off-list where you can get a dump of it. If needed,
I might be able to give you remote access to the system, but it's via
serial console and might be a bit painful. (I doubt you'd want to use the
IPMI in the server unless you should happen to be a fan of Internet Explorer.)

/* Steinar */
-- 
Homepage: http://www.sesse.net/
