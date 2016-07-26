From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-mq and end_clone_request()
Date: Tue, 26 Jul 2016 08:02:31 +0200
Message-ID: <08a1e048-8191-08bc-a39b-4c04a89ee2d4@suse.de>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
	<20160720140815.GA19045@redhat.com> <20160720142727.GA57399@redhat.com>
	<1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
	<20160720183321.GA20223@redhat.com>
	<84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
	<20160725175344.GA23000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160725175344.GA23000@redhat.com>
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

On 07/25/2016 07:53 PM, Mike Snitzer wrote:
> On Thu, Jul 21 2016 at  4:58pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>
>> On 07/20/2016 11:33 AM, Mike Snitzer wrote:
>>> Would be interesting to know the error returned from map_request()'s
>>> ti->type->clone_and_map_rq().  Really should just be DM_MAPIO_REQUEUE.
>>> But the stack you've provided shows map_request calling
>>> dm_complete_request(), which implies dm_kill_unmapped_request() is being
>>> called due to ti->type->clone_and_map_rq() returning < 0.
>>
>> Hello Mike,
>>
>> Apparently certain requests fail with -EIO because DM_DEV_SUSPEND
>> ioctls are being submitted to the same multipath target. As you know
>> DM_DEV_SUSPEND changes QUEUE_IF_NO_PATH from 1 into 0. A WARN_ON()
>> statement that I added in driver dm-mpath statement learned me that
>> multipathd is submitting these DM_DEV_SUSPEND ioctls. In the output
>> of strace -fp$(pidof multipathd) I found the following:
>>
>> [pid 13927] ioctl(5, DM_TABLE_STATUS, 0x7fa1000483f0) =3D 0
>> [pid 13927] write(1, "mpathbe: failed to setup multipa"..., 35) =3D 35
>> [pid 13927] write(1, "dm-0: uev_add_map failed\n", 25) =3D 25
>> [pid 13927] write(1, "uevent trigger error\n", 21) =3D 21
>> [pid 13927] write(1, "sdh: remove path (uevent)\n", 26) =3D 26
>> [pid 13927] ioctl(5, DM_TABLE_LOAD, 0x7fa1000483f0) =3D 0
>> [pid 13927] ioctl(5, DM_DEV_SUSPEND, 0x7fa1000483f0) =3D 0
>>
>> I'm still analyzing these and other messages.
>
> The various ioctls you're seeing is just multipathd responding to the
> failures.  Part of reloading a table (with revised path info, etc) is to
> suspend and then resume the device that is being updated.
>
> But I'm not actually sure on the historic reasoning of why
> queue_if_no_path is disabled (and active setting saved) on suspend.
>
> I'll think about this further but maybe others recall why?
>
Yes, originally multipath was using the device-mapper internal queueing =

mechanism, which meant that queued I/O was holding a reference to the =

table. So you couldn't change the table while I/O was pending/queued, =

and you'd have to unset queue_if_no_path to allow the tables to be swapped.
(Or something. That's the reasoning I gave to myself when seeing that =

construct. And I found myself pretty convincing. Not that I've ever =

tested that.)
So with commit e809917735ebf ("dm mpath: push back requests instead of
queueing") that obviously isn't true anymore, and I'd love to see that
quirk go.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
