From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Patch] multipath-tools: Check if multipathd is
 running or not and print a warning
Date: Thu, 28 Jul 2016 16:35:21 +0200
Message-ID: <d46dea9f-5b9d-4ffe-7c44-47603d580eca@suse.de>
References: <ebce9048-140b-b217-6438-8f2370026cc8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ebce9048-140b-b217-6438-8f2370026cc8@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mgandhi@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 07/28/2016 01:48 PM, Milan P. Gandhi wrote:
> Hello,
> =

> With this patch dm-multipath commands e.g. multipath -v2,
> multipath -ll etc. now checks if there are multipath
> device maps created, and multipathd service is running =

> or not? If the multipath devices are created, but multipathd =

> service is not running then there will be a warning =

> message displayed to inform the user that IO failover/
> failback may not work as expected without multipathd =

> process running.
> =

> I have tested this patch with Fedora 23, and latest =

> upstream multipath-tools
> =

> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
No, this won't work.

You cannot guarantee that by the time 'multipath' is called the daemon
was already able to create any maps (the daemon might still be
processing events, without it being able to start creating maps).

So the best we can do is to check if the daemon is running
and continue from there.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
