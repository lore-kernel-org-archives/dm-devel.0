From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Backport request for bcb44433bba5 ("dm: disable DISCARD if the
 underlying storage no longer supports it")
Date: Sun, 18 Aug 2019 20:33:05 +0200
Message-ID: <20190818183305.GA1181@kroah.com>
References: <20190818155941.GA26766@eldamar.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190818155941.GA26766@eldamar.local>
Sender: stable-owner@vger.kernel.org
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Sasha Levin <sashal@kernel.org>, Mike Snitzer <snitzer@redhat.com>, stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Chris Hofstaedtler <zeha@debian.org>
List-Id: dm-devel.ids

On Sun, Aug 18, 2019 at 05:59:41PM +0200, Salvatore Bonaccorso wrote:
> Hi
> 
> In Debian bug https://bugs.debian.org/934331 ran into issues which
> match the upstream commit bcb44433bba5 ("dm: disable DISCARD if the
> underlying storage no longer supports it").
> 
> This commit was CC'ed to stable, but only got applied in v5.0.8 (and
> later on backported by Ben Hutchings to v3.16.72).
> 
> Mike, I have not checked how easily that would be for older stable
> versions, but can the backport be considered for versions down to 4.9?
> Apparently Ben did succeed with some changes needed. To 4.19 it should
> apply with a small conflict in drivers/md/dm-core.h AFAICS.

If someone sends the backports to the list, I will be glad to queue them
up.

thanks,

greg k-h
