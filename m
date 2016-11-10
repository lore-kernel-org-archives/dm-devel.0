From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipathd: deferred device adding
Date: Thu, 10 Nov 2016 16:19:24 +0100
Message-ID: <5a8c5ffb-2dae-0e5c-3341-1f02ab3cd4dc@suse.de>
References: <1478790321-8539-1-git-send-email-gi-oh.kim@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1478790321-8539-1-git-send-email-gi-oh.kim@profitbricks.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gioh Kim <gi-oh.kim@profitbricks.com>, christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com, benjamin.drung@profitbricks.com
List-Id: dm-devel.ids

On 11/10/2016 04:05 PM, Gioh Kim wrote:
> Current multipathd always receives events from udev
> and add devices to topology immediately. For example,
> if sdb is added, multipathd receives the event from sdb
> and add sdb into the topology.
> But some platform needs to defer adding new device
> until user adds device manually, for instance, with "multipathd add sdb".
> =

> I tested this patch to disable ueventloop.
> There was no problem on my platform.
> =

> Is there a configuration for multipath.conf or udev rule
> for deferred device adding?
> Or what about adding new configuration for that?
> =

> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> ---
>  multipathd/main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> =

Please elaborate.

Which platforms would be needing that?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
