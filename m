From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath state between user and kernel space
Date: Fri, 8 Jul 2005 09:15:11 +0200
Message-ID: <20050708071511.GB11598@averon.dyndns.org>
References: <C2EEB4E538D3DC48BF57F391F422779321AB47@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321AB47@SRMANNING.eng.emc.com>
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

On Thu, Jul 07, 2005 at 07:08:13PM -0400, goggin, edward wrote:
> On Sat, 02 Jul 2005 00:07:40 +0200
> christophe varoqui <christophe.varoqui@free.fr> wrote
> 
> > Would printing the "PG-summed path priorities" value for each PG meet
> > your needs/taste ?
> 
> Yes.  I assume that this would be the sum as recorded by multipathd and
> the kernel's active path group would only reflect this under certain
> conditions, (e.g., immediate failback is enabled).
> 
> What about the idea of having device specific display options (and
> device specific plug-ins to manage these) which while they are
> multipathing relevant, they are not managed by multipath(8)?
> Are you trying to stay away from this?
> 
> I'm sure our CLARiiON customers would rather see that the multipath
> display command using terminology which they are familiar with
> already.
> 
I'd rather favor consistency for users changing multipathing hardware, than for users changing OS but keeping the same multipathing hardware.

I guess in the second case, the users already expects changes.

Also I suspect multi-vendor SAN users will appreciate the consistency.

Do you have strong feelings about this plugin idea ?

Regards,
cvaroqui
