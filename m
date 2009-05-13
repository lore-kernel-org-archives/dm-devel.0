From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: no_path_retry configurable per device basis?
Date: Wed, 13 May 2009 17:19:33 +0100
Message-ID: <1242231573.13505.571.camel@breeves.fab.redhat.com>
References: <561c252c0905130851q221e9febq61cc37f9fe9cee3@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <561c252c0905130851q221e9febq61cc37f9fe9cee3@mail.gmail.com>
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

On Wed, 2009-05-13 at 17:51 +0200, Gianluca Cecchi wrote:
> But my storage configuration
> features                "1 queue_if_no_path"
> is equivalent to no_path_retry queue" .......

Correct; setting the feature at the device level forces the
queue_if_no_path behavior for the device-mapper multipath target for all
multipath maps for this device type. This means that all maps behave as
though the no_path_retry option was set to "queue" (queue I/O forever).

> In this case, reading multipath.conf.annotated it seems I can set
> no_path_retry per device and so I put this in my multipath.conf
> (mpath6 is the quorum disk):
> 
>         multipath {
>                 wwid                    3600507630efe0b0c0000000000000610
>                 alias                   mpath6
>                 no_path_retry           3
>         }

This will still enable queue_if_no_path when creating a multipath map
for this device but the daemon will maintain a retry counter. If all
paths to the device go down and none return within three checks then the
daemon will disable the queue_if_no_path feature in the kernel and allow
outstanding I/Os to fail.

You'll still see a delay of 3 x polling_interval though and will need to
set your qdisk timeouts appropriately to accommodate this. There is a
Kbase article here that may help you selecting the appropriate values:

http://kbase.redhat.com/faq/docs/DOC-2882

> mpath6 (3600507630efe0b0c0000000000000610) dm-12 IBM,1750500
> [size=1.0G][features=1 queue_if_no_path][hwhandler=0][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 1:0:1:12 sday 67:32  [active][undef]
>  \_ 0:0:1:12 sdaz 67:48  [active][undef]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 1:0:0:12 sdy  65:128 [active][undef]
>  \_ 0:0:0:12 sdz  65:144 [active][undef]
> mpath12 (3600507630efe0b0c0000000000000705) dm-11 IBM,1750500
> [size=10G][features=1 queue_if_no_path][hwhandler=0][rw]
> \_ round-robin 0 [prio=0][active]
>  \_ 1:0:0:11 sdv  65:80  [active][undef]
>  \_ 0:0:0:11 sdx  65:112 [active][undef]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 1:0:1:11 sdaw 67:0   [active][undef]
>  \_ 0:0:1:11 sdax 67:16  [active][undef]

What do you get if you remove the 'features "1 queue_if_no_path"' line
from your device block? You can still set no_path_retry to queue or to
some value >3 in your defaults section for the other LUNs.

Remember that when testing this you'll still see queue_if_no_path in the
output of multipath/dmsetup until you have exceeded the configured retry
count so you'll need a way to introduce errors on the paths to the
quorum disk in order to test this.

Regards,
Bryn.
