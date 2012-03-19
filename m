From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm-mpath: Track invalid map_context
Date: Mon, 19 Mar 2012 16:36:27 +0100
Message-ID: <4F67527B.9050403@suse.de>
References: <1332170128-30232-1-git-send-email-hare@suse.de>
	<20120319152007.GD4495@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120319152007.GD4495@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 03/19/2012 04:20 PM, Alasdair G Kergon wrote:
> On Mon, Mar 19, 2012 at 04:15:28PM +0100, Hannes Reinecke wrote:
>> -	if (r < 0 || r =3D=3D DM_MAPIO_REQUEUE)
>> +	if (r < 0 || r =3D=3D DM_MAPIO_REQUEUE) {
>>  		mempool_free(mpio, m->mpio_pool);
>> +		map_context->ptr =3D NULL;
>> +	}
> =

> What about the other places that do mempool_free() ?
> Should they clear it too?
> =

Hmm. Probably. It's not strictly speaking required as the other
places will never re-use the context pointer.
But for consistencies sake you are correct.
Will be updating the patch.

> Is it better to swap the statement order - clear it *before*
> freeing i
> =

Doubt that should be required.
I would hope that the map_context pointer is protected by
appropriate locks.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
