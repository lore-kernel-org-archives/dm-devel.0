From: Joe Thornber <thornber@redhat.com>
Subject: Re: Kernel oops with dm-cache
Date: Mon, 9 Dec 2013 10:38:14 +0000
Message-ID: <20131209103813.GD26971@debian>
References: <20131208105930.GA3763@sesse.net>
	<20131208120152.GA4096@samfundet.no>
	<CAMM=eLcZdULJZaAfwct1Bnj4KjNxOBrBumeb_vM+PtdjErQ5fA@mail.gmail.com>
	<20131209092807.GA4323@samfundet.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131209092807.GA4323@samfundet.no>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 09, 2013 at 10:28:07AM +0100, Steinar H. Gunderson wrote:
> On Sun, Dec 08, 2013 at 10:13:05PM -0500, Mike Snitzer wrote:
> > This was fixed with this commit:
> > http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=47821767d26af4073fcfdfb3b96704f24a23416f
> > 
> > I'll be sending it to Linus at some point this coming week (along with
> > other DM fixes that are staged in the 'for-next' branch of
> > linux-dm.git).
> 
> OK. Will applying this actually make my machine boot again, too? check_cache
> says there's nothing wrong with it, just like last time; dump-cache says
> everything's clean, just like last time. But I'm not nuking it once more,
> the backup restore process was too painful last time :-)

My gut feel is you're running out of metadata space for some reason.
How big is your metadata device?  (Obviously this is no excuse for the
crashing).

I'm really surprised that cache_dump is giving wrong information;
saying everything is clean, saying you were using the cleaner policy
etc.  Are you sure you're passing it the right metadata dev?

- Joe
