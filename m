From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Getting device-mapper failure notifications
Date: Wed, 24 Feb 2016 13:12:47 +0000
Message-ID: <20160224131246.GF26964@hex.redhat.com>
References: <CAHph7JrC0pU+Wy7DsHeCAhz7FWuJa29qGsdv+jD3OQq4aJ1bTA@mail.gmail.com>
	<56CD38FD.9010209@redhat.com> <56CD8527.5000702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56CD8527.5000702@suse.de>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 24, 2016 at 06:25:43PM +0800, Hannes Reinecke wrote:
> On 02/24/2016 01:00 PM, Andy Grover wrote:
> > On 02/01/2016 11:07 PM, Avishay Traeger wrote:
> >> Hi all,
> >> I have a system where various configurations are possible - iSCSI/FC,
> >> single paths and multiple.  For multiple I of course use device-mapper.
> >> I was wondering if it was possible to:
> >> 1. use it for cases where I have a single path.
> >> 2. create a monitoring process that can take some action (e.g., send a
> >> notification via message queue) in the case of some failure that would
> >> normally cause failover.
> > 
> > Does dm-multipath support a single path? I don't know...
> > 
> Pshaw.
> Of course it does.
> 
> (Might be that RH has some magic disallowing that, but certainly there's
> nothing in the source which forbids it. In fact I recommend it when
> using iSCSI)

No but find_multipaths is enabled by default so maps are only created
automatically when we see at least two devices with the same WWID.

> So I recommend to always use dm-multipath and listen to uevents.

Ack.

Regards,
Bryn.
 
