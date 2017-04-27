From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/13] dm-mpath: Avoid that path removal can
 trigger an infinite loop
Date: Thu, 27 Apr 2017 17:13:31 +0200
Message-ID: <87938548-937c-004d-741b-ef3bd8c4ccc0@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
	<20170426183728.10821-3-bart.vanassche@sandisk.com>
	<fabbb802-5743-1193-3d4e-841404db2372@suse.de>
	<1493305901.2625.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1493305901.2625.1.camel@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "hare@suse.com" <hare@suse.com>
List-Id: dm-devel.ids

On 04/27/2017 05:11 PM, Bart Van Assche wrote:
> On Thu, 2017-04-27 at 07:46 +0200, Hannes Reinecke wrote:
>> On 04/26/2017 08:37 PM, Bart Van Assche wrote:
>>> +	clone =3D blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
>>>  	if (IS_ERR(clone)) {
>>>  		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
>>> -		return r;
>>> +		pr_debug("blk_get_request() returned %ld%s - requeuing\n",
>>> +			 PTR_ERR(clone), blk_queue_dying(q) ?
>>> +			 " (path offline)" : "");
>>> +		if (blk_queue_dying(q)) {
>>> +			atomic_inc(&m->pg_init_in_progress);
>>> +			activate_path(pgpath);
>>> +			return DM_MAPIO_REQUEUE;
>>> +		}
>>> +		return DM_MAPIO_DELAY_REQUEUE;
>>>  	}
>>>  	clone->bio =3D clone->biotail =3D NULL;
>>>  	clone->rq_disk =3D bdev->bd_disk;
>>
>> At the very least this does warrant some inline comments.
>> Why do we call activate_path() here, seeing that the queue is dying?
> =

> Hello Hannes,
> =

> activate_path() is not only able to activate a path but can also change
> the state of a path to offline. The body of the activate_path() function
> makes that clear and that is why I had not added a comment above the
> activate_path() call:
> =

> static void activate_path(struct pgpath *pgpath)
> {
> 	struct request_queue *q =3D bdev_get_queue(pgpath->path.dev->bdev);
> =

> 	if (pgpath->is_active && !blk_queue_dying(q))
> 		scsi_dh_activate(q, pg_init_done, pgpath);
> 	else
> 		pg_init_done(pgpath, SCSI_DH_DEV_OFFLINED);
> }
> =

So why not call 'pg_init_done()' directly and avoid the confusion?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
