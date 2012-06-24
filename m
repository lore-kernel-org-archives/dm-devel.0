From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] mmotm 2012-06-21-16-20 uploaded (dm-thin)
Date: Sun, 24 Jun 2012 17:55:55 +0100
Message-ID: <20120624165555.GA17647@agk-dp.fab.redhat.com>
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com> <4FE4AAAE.3090803@xenotime.net> <20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Joe Thornber <dm-devel@redhat.com>, linux-next@vger.kernel.org, akpm@linux-foundation.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 25, 2012 at 12:44:25AM +1000, Stephen Rothwell wrote:
> I assume that CONFIG_LDBAF is not set and I think this is caused by
> commit ebf5d9e0425c ("Non power of 2 blocksize support is needed to
> properly align thinp IO") from the device-mapper tree.
 
Ah yes, I'll fix that, and check we handle "too large" devices sensibly.

Alasdair
