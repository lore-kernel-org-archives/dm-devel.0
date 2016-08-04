From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-mq and end_clone_request()
Date: Thu, 4 Aug 2016 12:09:48 +0200
Message-ID: <c4c7a8d4-206e-f9a0-af5a-447e993f99de@suse.de>
References: <536022978.7668211.1470060125271.JavaMail.zimbra@redhat.com>
	<931235537.7668834.1470060339483.JavaMail.zimbra@redhat.com>
	<1264951811.7684268.1470065187014.JavaMail.zimbra@redhat.com>
	<17da3ab0-233a-2cec-f921-bfd42c953ccc@sandisk.com>
	<20160801175948.GA6685@redhat.com>
	<f9e71e1d-54ca-40fe-a5ea-ae2863c94ff9@sandisk.com>
	<20160801204628.GA94704@redhat.com>
	<8e265fcc-8021-830e-ffcb-23a8a28ec247@sandisk.com>
	<20160802174533.GA18714@redhat.com>
	<1a460c29-1530-d3e1-25ba-736d86aff12e@sandisk.com>
	<20160803004013.GA19956@redhat.com>
	<eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com>
	<e2749805-00fe-a5f0-157c-66d6d0910dd4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e2749805-00fe-a5f0-157c-66d6d0910dd4@suse.de>
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

On 08/04/2016 11:53 AM, Hannes Reinecke wrote:
> On 08/03/2016 06:55 PM, Bart Van Assche wrote:
>> On 08/02/2016 05:40 PM, Mike Snitzer wrote:
>>> But I asked you to run the v4.7 kernel patches I
>>> pointed to _without_ any of your debug patches.
>>
>> I need several patches to fix bugs that are not related to the device
>> mapper, e.g. "sched: Avoid that __wait_on_bit_lock() hangs"
>> (https://lkml.org/lkml/2016/8/3/289).
>>
> Hmm. Can you test with this patch?
> =

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 7790a70..9daed03 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -439,8 +439,7 @@ static int must_push_back(struct multipath *m)
>  {
>         return (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) ||
>                 ((test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) !=3D
> -                 test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) &&
> -                dm_noflush_suspending(m->ti)));
> +                 test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)));
>  }
> =

>  /*
> =

> Reasoning:
> The original check for dm_noflush_suspending() was for bio-based
> drivers, which needed to queue I/O within the device-mapper core.
> So during suspend this I/O would keep a reference to the device-mapper
> core and the table couldn't be swapped.
> For request-based multipathing, however, the I/O is _never_ held within
> the device-mapper core but rather pushed back to the request queue.
> IE even for pushback the I/O will never hold a reference to the
> device-mapper core, and the tables can be swapped irrespective of the
> 'dm_noflush_suspend()' setting.
> =

> Or that's the idea, at least :-)
> =

> Yes Mike, I know, it's not going to work with bio-based multipathing.
> But this is just for figuring out where the real issue is.
> =

And indeed.

multipathd is calling DM_SUSPEND _without_ the noflush_suspending flag.
(On the grounds that originally it needed to flush all I/O from the
device-mapper core).
Which will be causing I/O errors if any I/O is executed after
->presuspend has been called.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
