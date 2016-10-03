From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 2/4] multipath-tools: replace GROUP_BY_SERIAL
 with MULTIBUS for IBM 3542 and 2105
Date: Mon, 3 Oct 2016 15:04:04 +0200
Message-ID: <e3d21de2-1b56-1ca7-1bf5-9af5a903fe9e@gmail.com>
References: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
	<1471543096-11441-2-git-send-email-xose.vazquez@gmail.com>
	<CABr-GndoWMoFD898RPci4yJxFDvtwmhQTERH7QZqLk0Qm5mCuQ@mail.gmail.com>
	<bd26cdfd-2b48-69de-cf4a-55f5e75c8c01@suse.de>
	<CABr-GndK4pBmKUgsmjpuYvNH6xgj2R4O4p=jhRQAtT2B+LWg3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GndK4pBmKUgsmjpuYvNH6xgj2R4O4p=jhRQAtT2B+LWg3g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/03/2016 02:06 PM, Christophe Varoqui wrote:

> Thanks.
> Patch pushed.

>     >                     /* DS4200 / FAStT200 */
>     >                     .vendor        = "IBM",
>     >                     .product       = "^3542",
>     >     -               .pgpolicy      = GROUP_BY_SERIAL,
>     >     +               .pgpolicy      = MULTIBUS,
>     >                     .pgfailback    = FAILBACK_UNDEF,
>     >             },
>     This is the IBM FAStT 200, which is IIRC an RDAC machine. So multibus
>     will be wrong here, and it should be using the RDAC entry instead.

A patch is needed also in the kernel side(drivers/scsi/scsi_dh.c).
