From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: StorageWorks multipath support
Date: Wed, 15 Jun 2005 16:40:52 +0200
Message-ID: <20050615144052.GE16446@averon.dyndns.org>
References: <20050615085634.GA16446@averon.dyndns.org>
	<20050615131520.GC11423@marowsky-bree.de>
	<20050615134536.GC16446@averon.dyndns.org>
	<20050615135337.GG11423@marowsky-bree.de>
	<20050615140740.GD16446@averon.dyndns.org>
	<20050615141302.GH11423@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050615141302.GH11423@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, Jun 15, 2005 at 04:13:02PM +0200, Lars Marowsky-Bree wrote:
> 
> The emc_clariion checker considers the "ghost" paths to be healthy
> because of that. (Which is true: they haven't failed, they are just
> passive.)
> 
ah ok, I missed that refinement in the emc checker.
Do you want to send the patch to move this checker to a tri-state like hp_sw ?

> > 
> > Can you elaborate on what you have in mind ?
> 
> Well, basically I'd like it if a SIGHUP would still cause the daemon to
> reload the configuration and rescan the mappings. (Which is a common use
> of SIGHUP.) Then we'd get the best of both worlds, we could re-trigger
> it on the old dists and use the more efficient uevent on newer kernels.
> 
Well, seems a reasonable feature indeed. I defered implementing this because you are almost equally served with a daemon restart.

Do you consider Alasdair's proposition (fs-socket) complementary, best, ... ?

Regards,
cvaroqui
