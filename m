From: Hannes Reinecke <hare@suse.de>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
 dm-multipath
Date: Mon, 26 May 2014 14:44:32 +0200
Message-ID: <53833730.50509@suse.de>
References: <5368ABE8.9050909@acm.org>
	<536B1CC1.6080709@suse.de>	<53832919.8080500@acm.org>
	<53832F2B.9060808@suse.de>	<53833183.7080106@acm.org>
	<538333AC.60103@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <538333AC.60103@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/26/2014 02:29 PM, Hannes Reinecke wrote:
> On 05/26/2014 02:20 PM, Bart Van Assche wrote:
>> On 05/26/14 14:10, Hannes Reinecke wrote:
>>> Mike Snitzer had a patch in his device-mapper tree:
>>>
>>> dm mpath: fix lock order inconsistency in multipath_ioctl
>>> (2014-05-14
>>> 16:12:17 -0400)
>>>
>>> I was sort of hoping that would address this issue.
>>> Can you check?
>>
>> Hello Hannes,
>>
>> Is it possible that that patch already got included in v3.15-rc6 and
>> hence that that patch was included in my test ?
>>
>> $ git log v3.15-rc5..v3.15-rc6 | grep 'dm mpath: fix lock order
>> inconsistency in multipath_ioctl'
>>        dm mpath: fix lock order inconsistency in multipath_ioctl
>>      dm mpath: fix lock order inconsistency in multipath_ioctl
>>
> Could be.
>
> Okay, I'll be cross-checking.
>
Can you check if this makes lockdep happy?

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aa009e8..40b3036 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -445,11 +445,11 @@ static int queue_if_no_path(struct multipath =

*m, unsigned
queue_if_no_path,
         else
                 m->saved_queue_if_no_path =3D queue_if_no_path;
         m->queue_if_no_path =3D queue_if_no_path;
-       if (!m->queue_if_no_path)
-               dm_table_run_md_queue_async(m->ti->table);
-
         spin_unlock_irqrestore(&m->lock, flags);

+       if (!queue_if_no_path)
+               dm_table_run_md_queue_async(m->ti->table);
+
         return 0;
  }

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
