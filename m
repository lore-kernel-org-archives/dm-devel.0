From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-mpath: do not change SCSI device handler
Date: Thu, 04 Apr 2013 08:47:07 +0200
Message-ID: <515D21EB.8010701@suse.de>
References: <Pine.LNX.4.64.1304022000390.27554@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1304022000390.27554@file.rdu.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 04/03/2013 02:04 AM, Mikulas Patocka wrote:
> Hi
> =

> This fixes BZ 912245 and 902595.
> =

> Mikulas
> =

> ---
> =

> dm-mpath: do not change SCSI device handler
> =

> This patch prevents the multipath target from changing the device handler.
> This fixes a kernel crash that can happen when changing the device
> handler.
> =

> When we reload a multipath device, there are two instances of the
> multipath target - the first instance that is active and the second
> instance that is being constructed with "ctr" method.
> =

> If the multipath constructor finds out that the device is using a
> different device handler, it detaches the existing handler and attaches a
> new handler. However, the first instance of the multipath target still
> exists and processes requests. If the first instance sends some
> path-management request with scsi_dh_activate and the second instance
> detaches the device handler while the path-management request is in
> flight, a crash happens. The reason for the crash is that the endio
> routine for the path-management request is working with structures that
> were freed when the handler was detached.
> =

> There is no practical need to change device handlers on an active device,
> so this patch disables it.
> =

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> =


NACK.

This kills multipath startup when scsi_dh_* modules are already loaded.
After boot scsi_dh_* modules might already be loaded without
multipath running.
Multipath might have defined other hardware handlers in the
configuration file, and will re-attach them on startup.

With this patch multipath cannot configure the devices properly and
will abort.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
