From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: StorageWorks multipath support
Date: Wed, 15 Jun 2005 16:07:40 +0200
Message-ID: <20050615140740.GD16446@averon.dyndns.org>
References: <20050615085634.GA16446@averon.dyndns.org>
	<20050615131520.GC11423@marowsky-bree.de>
	<20050615134536.GC16446@averon.dyndns.org>
	<20050615135337.GG11423@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050615135337.GG11423@marowsky-bree.de>
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

On Wed, Jun 15, 2005 at 03:53:37PM +0200, Lars Marowsky-Bree wrote:
> 
> Well, before, those paths were simply kept as "active" / "healthy" (and
> from the point of view of the kernel code they are, just that the PG
> they are in might not be enabled).
> 
Mmm, not anymore.

It was true till 0.4.4, but in HEAD there are patches to implement to proactive DM-failing of checker-failed paths. This was a request from Tran if I remember.

> But it makes the status output look nicer of course if those paths are
> listed as "ghost" in the user-space.
> 
Agreed

> 
> BTW, backporting uevent is a bit more annoying then I thought. How about
> a way to manually prod the daemon? That might be useful in general, for
> example if a hotplug event was lost due to whatever reason...
> 
Too bad.

Can you elaborate on what you have in mind ?

Regards,
cvaroqui
