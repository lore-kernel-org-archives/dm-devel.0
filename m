From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/30] multipath: Increase dev_loss_tmo prior
 to fast_io_fail
Date: Mon, 22 Jul 2013 09:19:42 +0200
Message-ID: <51ECDD0E.5060802@suse.de>
References: <1373958801-103613-1-git-send-email-hare@suse.de>
	<1373958801-103613-5-git-send-email-hare@suse.de>
	<20130719211719.GA2113@dhcp80-209.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130719211719.GA2113@dhcp80-209.msp.redhat.com>
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

On 07/19/2013 11:17 PM, Benjamin Marzinski wrote:
> On Tue, Jul 16, 2013 at 09:12:55AM +0200, Hannes Reinecke wrote:
>> There are several constraints when setting fast_io_fail and
>> dev_loss_tmo.
>> dev_loss_tmo will be capped automatically when fast_io_fail is
>> not set. And fast_io_fail can not be raised beyond dev_loss_tmo.
>>
>> So to increase dev_loss_tmo and fast_io_fail we first need
>> to increase dev_loss_tmo to the given fast_io_fail
>> setting, then set fast_io_fail, and then set dev_loss_tmo
>> to the final setting.
> =

> This patch seems kind of convoluted to me, and even with the fix to
> temporarily set dev_loss_tmo to one greater than fast_io_fail_tmo,
> there is still a broken case
> =

> If you currently have:
> fast_io_fail_tmo off
> dev_loss_tmo <something_less_than_600>
> =

> and you want
> =

> fast_io_fail_tmo 600
> dev_loss_tmo <something_greater_than_600>
> =

> This will fail, since it will try to set dev_loss_tmo to 601 with
> fast_io_fail_tmo set to off (Granted, I doubt that 600 is a
> popular fast_io_fail_tmo value).
> =

> But in the general case, If you aren't turning off fast_io_fail_tmo and
> the current dev_loss_tmo is greater than the target fast_io_fail_tmo
> (this seems like it is the most common case), you unecessarily go through
> the work of first setting dev_loss_tmo to its current value.
> =

>         if (mpp->fast_io_fail !=3D MP_FAST_IO_FAIL_UNSET &&
>             mpp->fast_io_fail !=3D MP_FAST_IO_FAIL_ZERO &&
>             mpp->fast_io_fail !=3D MP_FAST_IO_FAIL_OFF) {
>                 /* Check if we need to temporarily increase dev_loss_tmo
>  * */
>                 ret =3D sysfs_attr_get_value(rport_dev, "dev_loss_tmo",
>                                            value, 16);
> =

> <SNIP>
> =

>         }
>         if (strlen(value)) {
>                 ret =3D sysfs_attr_set_value(rport_dev, "dev_loss_tmo",
>                                            value, strlen(value));
> =

> I have a patch that solves this issue differently.  It still checks
> dev_loss_tmo, but it always sets fast_io_fail_tmo first.  If the target
> fast_io_fail_tmo is greater than or equal to the current dev_loss_tmo,
> it sets fast_io_fail_tmo to one less than the current dev_loss_tmo.
> This always works, since the lowest value possible for dev_loss_tmo is 1
> and the lowest value possible for fast_io_fail_tmo is 0. Then it sets
> dev_loss_tmo. Finally, if necessary, it sets fast_io_fail_tmo to its
> final value.
> =

Ah.

So you're doing (worst case)
-> set fast_io_fail
-> set dev_loss_tmo
-> set fast_io_fail


and I'm doing
-> set dev_loss_tmo
-> set fast_io_fail
-> set dev_loss_tmo

So the only difference here is the '+- 1' offset to fast_io_fail or
dev_loss_tmo ...

Whatever.
Waiting for your patch.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
