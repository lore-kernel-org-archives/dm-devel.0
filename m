From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [Patch] multipath-tools: Check if multipathd is
 running or not and print a warning
Date: Fri, 29 Jul 2016 11:02:52 -0500
Message-ID: <20160729160252.GD26062@octiron.msp.redhat.com>
References: <ebce9048-140b-b217-6438-8f2370026cc8@redhat.com>
	<d46dea9f-5b9d-4ffe-7c44-47603d580eca@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d46dea9f-5b9d-4ffe-7c44-47603d580eca@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, mgandhi@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 28, 2016 at 04:35:21PM +0200, Hannes Reinecke wrote:
> On 07/28/2016 01:48 PM, Milan P. Gandhi wrote:
> > Hello,
> > =

> > With this patch dm-multipath commands e.g. multipath -v2,
> > multipath -ll etc. now checks if there are multipath
> > device maps created, and multipathd service is running =

> > or not? If the multipath devices are created, but multipathd =

> > service is not running then there will be a warning =

> > message displayed to inform the user that IO failover/
> > failback may not work as expected without multipathd =

> > process running.
> > =

> > I have tested this patch with Fedora 23, and latest =

> > upstream multipath-tools
> > =

> > Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> > ---
> No, this won't work.
> =

> You cannot guarantee that by the time 'multipath' is called the daemon
> was already able to create any maps (the daemon might still be
> processing events, without it being able to start creating maps).
> =

> So the best we can do is to check if the daemon is running
> and continue from there.

I'm a little confused here.  All that this is assuming is that
multipathd has user event listener thread started. This happens before
it has even run the initial configure to pick up already existing
devices. The other way of checking if the multipathd daemon is running
would be to look at the pidfile, right? Are you really worried that
people will often be creating devices with the multipath command in the
window between when multipathd locks the pidfile, and when it can
receive user commands? Otherwise, I don't see your how your suggestion
would make a difference. Perhaps, I'm misunderstanding you. =


It seems like, in most cases, multipathd should have been started during
bootup, long before the multipath command would ever get called to
create a device, and these checks are only happening when multipath is
actually creating a device, so the calls to see if a device is a valid
path device (-c or -u) won't trigger this warning. Or am I missing
something here?

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
