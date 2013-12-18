From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Wed, 18 Dec 2013 15:25:10 +0100
Message-ID: <52B1B046.3040301@suse.de>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131218140858.GC17730@redhat.com>
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
Cc: dm-devel@redhat.com, Sean Stewart <sean.stewart@netapp.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 12/18/2013 03:08 PM, Mike Snitzer wrote:
> On Wed, Dec 18 2013 at  2:52am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> =

>> The multipath kernel module is rejecting any map with an invalid
>> device. However, as the multipathd is processing the events serially
>> it will try to push a map with invalid devices if more than one
>> device failed at the same time.
>> So we can as well accept those maps and make sure to mark the
>> paths as down.
> =

> Why is it so desirable to do this?  Reduced latency to restore at least
> one valid path when a bunch of paths go down?
> =

Without this patch multipathd cannot update the map as long is
hasn't catched up with udev.
During that time any scheduling decisions by the kernel part are
necessarily wrong, as it has to rely on the old map.

> Why can't we just rely on userspace eventually figuring out which paths
> are failed and pushing a valid map down?
> =

Oh, you can. This is what we're doing now :-)

But it will lead to spurious error during failover when multipathd
is trying to push down maps with invalid devices.

You are also running into a race window between checking the path in
multipathd and pushing down the map; if the device disappears during
that time you won't be able to push down the map.
If that happens during boot multipathd won't be able to create the
map at all, so you might not be able to boot here.
With that patch you at least have the device-mapper device, allowing
booting to continue.

> Are there favorable reports that this new behavior actually helps?
> Please quantify how.
> =

NetApp will have; they've been pushing me to forward this patch.
Sean?

BTW, SUSE / SLES is running happily with this patch for years now.
So it can't be at all bad ...

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
