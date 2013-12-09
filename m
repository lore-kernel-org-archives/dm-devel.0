From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Kernel oops with dm-cache
Date: Mon, 9 Dec 2013 14:44:30 -0500
Message-ID: <20131209194430.GA15196@redhat.com>
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
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Dec 09 2013 at  4:28am -0500,
Steinar H. Gunderson <sgunderson@bigfoot.com> wrote:

> On Sun, Dec 08, 2013 at 10:13:05PM -0500, Mike Snitzer wrote:
> > This was fixed with this commit:
> > http://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=47821767d26af4073fcfdfb3b96704f24a23416f
> > 
> > I'll be sending it to Linus at some point this coming week (along with
> > other DM fixes that are staged in the 'for-next' branch of
> > linux-dm.git).
> 
> OK. Will applying this actually make my machine boot again, too?

No, it'll just fix the kernel so it doesn't crash when the metadata
operation fails.  We need to understand why your metadata operations are
failing.  Hopefully Joe can sort it out with the metdata you've provided
to him off-list.
