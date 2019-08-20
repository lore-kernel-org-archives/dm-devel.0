From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Backport request for bcb44433bba5 ("dm: disable DISCARD if the
 underlying storage no longer supports it")
Date: Tue, 20 Aug 2019 09:23:25 -0700
Message-ID: <20190820162325.GB8214@kroah.com>
References: <20190818155941.GA26766@eldamar.local>
 <20190818183305.GA1181@kroah.com>
 <20190818204436.GA27437@eldamar.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190818204436.GA27437@eldamar.local>
Sender: stable-owner@vger.kernel.org
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Sasha Levin <sashal@kernel.org>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Chris Hofstaedtler <zeha@debian.org>, David Jeffery <djeffery@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
List-Id: dm-devel.ids

On Sun, Aug 18, 2019 at 10:44:36PM +0200, Salvatore Bonaccorso wrote:
> hi Greg,
> 
> On Sun, Aug 18, 2019 at 08:33:05PM +0200, Greg Kroah-Hartman wrote:
> > On Sun, Aug 18, 2019 at 05:59:41PM +0200, Salvatore Bonaccorso wrote:
> > > Hi
> > > 
> > > In Debian bug https://bugs.debian.org/934331 ran into issues which
> > > match the upstream commit bcb44433bba5 ("dm: disable DISCARD if the
> > > underlying storage no longer supports it").
> > > 
> > > This commit was CC'ed to stable, but only got applied in v5.0.8 (and
> > > later on backported by Ben Hutchings to v3.16.72).
> > > 
> > > Mike, I have not checked how easily that would be for older stable
> > > versions, but can the backport be considered for versions down to 4.9?
> > > Apparently Ben did succeed with some changes needed. To 4.19 it should
> > > apply with a small conflict in drivers/md/dm-core.h AFAICS.
> > 
> > If someone sends the backports to the list, I will be glad to queue them
> > up.
> 
> Here is the one for 4.19 on top of 4.19.67. It's my first contribution
> on this regard. Given the change to be applied was only about the
> context change in drivers/md/dm-core.h I'm unsure if the Signed-off-by
> is the right addition to do as well.

Yes it is!

Now queued up, thanks.

greg k-h
