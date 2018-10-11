From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [git pull] device mapper fix for 4.19 final
Date: Thu, 11 Oct 2018 07:40:38 +0200
Message-ID: <20181011054038.GA18271@kroah.com>
References: <20181010164643.GA10173@redhat.com>
	<20181010203502.GC6979@kroah.com>
	<20181011033711.GA12723@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181011033711.GA12723@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Damien Le Moal <damien.lemoal@wdc.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 10, 2018 at 11:37:11PM -0400, Mike Snitzer wrote:
> On Wed, Oct 10 2018 at  4:35P -0400,
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > On Wed, Oct 10, 2018 at 12:46:44PM -0400, Mike Snitzer wrote:
> > > Hi Greg,
> > > 
> > > The following changes since commit 0238df646e6224016a45505d2c111a24669ebe21:
> > > 
> > >   Linux 4.19-rc7 (2018-10-07 17:26:02 +0200)
> > > 
> > > are available in the Git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.19/dm-fixes-3
> > 
> > Now merged, thanks.
> 
> Hey Greg,
> 
> Sadly the previous DM pull request had a stupid oversight on my part.
> Damien was quick to correct it and I've now made it available.  Sorry
> for the noise, that's what I get for requesting you pull the same day I
> stage a commit, I'll be more careful!
> 
> The following changes since commit beb9caac211c1be1bc118bb62d5cf09c4107e6a5:
> 
>   dm linear: eliminate linear_end_io call if CONFIG_DM_ZONED disabled (2018-10-10 12:11:09 -0400)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.19/dm-fixes-4

Now merged, thanks.

greg k-h
