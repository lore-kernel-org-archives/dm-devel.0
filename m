From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-mpath: requeue I/O during pg_init
Date: Tue, 05 Nov 2013 14:10:55 +0100
Message-ID: <5278EE5F.9070208@suse.de>
References: <1380620996-110162-1-git-send-email-hare@suse.de>
	<20131105130221.GC27505@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131105130221.GC27505@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 11/05/2013 02:02 PM, Alasdair G Kergon wrote:
> On Tue, Oct 01, 2013 at 11:49:56AM +0200, Hannes Reinecke wrote:
>> --- a/drivers/md/dm-mpath.c
>> +++ b/drivers/md/dm-mpath.c
>> @@ -390,7 +390,11 @@ static int map_io(struct multipath *m, struct reque=
st *clone,
>>  	if (was_queued)
>>  		m->queue_size--;
>>  =

>> -	if ((pgpath && m->queue_io) ||
>> +	if (m->pg_init_required) {
>> +		if (!m->pg_init_in_progress)
>> +			queue_work(kmultipathd, &m->process_queued_ios);
>> +		r =3D DM_MAPIO_REQUEUE;
>> +	} else if ((pgpath && m->queue_io) ||
>>  	    (!pgpath && m->queue_if_no_path)) {
>>  		/* Queue for the daemon to resubmit */
>>  		list_add_tail(&clone->queuelist, &m->queued_ios);
> =

> This sequence if...else if... is becoming more and more unreadable!
> - Two cases now return REQUEUE; two cases now queue_work().
> =

> If it really can't be simplified, could we at least add some explanatory
> comments inline?
> =

Well, _actually_ this was more an RFC on where would be the point of
having multipath queueing I/Os internally.
This patch remove internal queueing for during pg_init.
I do have a second patch for removing the internal queueing
altogether and drop the entire queue_io stuff.

However, prior to doing so I would like to inquire on the original
design goals. There must have been a reason for implementing the
internal queueing.
If this is just a left-over from the original port to request-based
(for bio-based we _have_ to queue internally as there's no request
queue to be had), fine, we should be removing it.
But the _might_ be some corner cases which require us to do internal
queueing. Junichi should know.

Junichi, could you share some light here?

Cheers,

Hannes
---
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
