From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: Tree for Jun 27 (dm-thin.c)
Date: Wed, 27 Jun 2012 09:13:33 -0700
Message-ID: <4FEB312D.5020608@xenotime.net>
References: <20120627132217.f8bbdd1f467711419123d188@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120627132217.f8bbdd1f467711419123d188@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Joe Thornber <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 06/26/2012 08:22 PM, Stephen Rothwell wrote:

> Hi all,
> 
> This tree was not built between each merge, but only after merging all
> the trees.
> 
> Changes since 20120626:
> 
> The device-mapper tree gained a build failure for which I reverted a
> commit.


on x86_64:

drivers/md/dm-thin.c: In function 'pool_preresume':
drivers/md/dm-thin.c:2129:3: warning: format '%llu' expects type 'long long unsigned int', but argument 2 has type 'sector_t'


CONFIG_LBDAF is not enabled.


-- 
~Randy
