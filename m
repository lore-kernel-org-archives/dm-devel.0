From: Hannes Reinecke <hare@suse.de>
Subject: Re: 3.15-rc4: circular locking dependency triggered by
 dm-multipath
Date: Mon, 26 May 2014 14:51:33 +0200
Message-ID: <538338D5.4080804@suse.de>
References: <5368ABE8.9050909@acm.org>
	<536B1CC1.6080709@suse.de>	<53832919.8080500@acm.org>
	<53832F2B.9060808@suse.de>	<53833183.7080106@acm.org>
	<538333AC.60103@suse.de> <53833730.50509@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090206030006020806020502"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53833730.50509@suse.de>
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

This is a multi-part message in MIME format.
--------------090206030006020806020502
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx6-phx2.redhat.com id s4QCpcaB028080

On 05/26/2014 02:44 PM, Hannes Reinecke wrote:
> On 05/26/2014 02:29 PM, Hannes Reinecke wrote:
>> On 05/26/2014 02:20 PM, Bart Van Assche wrote:
>>> On 05/26/14 14:10, Hannes Reinecke wrote:
>>>> Mike Snitzer had a patch in his device-mapper tree:
>>>>
>>>> dm mpath: fix lock order inconsistency in multipath_ioctl
>>>> (2014-05-14
>>>> 16:12:17 -0400)
>>>>
>>>> I was sort of hoping that would address this issue.
>>>> Can you check?
>>>
>>> Hello Hannes,
>>>
>>> Is it possible that that patch already got included in v3.15-rc6 and
>>> hence that that patch was included in my test ?
>>>
>>> $ git log v3.15-rc5..v3.15-rc6 | grep 'dm mpath: fix lock order
>>> inconsistency in multipath_ioctl'
>>>        dm mpath: fix lock order inconsistency in multipath_ioctl
>>>      dm mpath: fix lock order inconsistency in multipath_ioctl
>>>
>> Could be.
>>
>> Okay, I'll be cross-checking.
>>
> Can you check if this makes lockdep happy?
>
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index aa009e8..40b3036 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -445,11 +445,11 @@ static int queue_if_no_path(struct multipath
> *m, unsigned
> queue_if_no_path,
>          else
>                  m->saved_queue_if_no_path =3D queue_if_no_path;
>          m->queue_if_no_path =3D queue_if_no_path;
> -       if (!m->queue_if_no_path)
> -               dm_table_run_md_queue_async(m->ti->table);
> -
>          spin_unlock_irqrestore(&m->lock, flags);
>
> +       if (!queue_if_no_path)
> +               dm_table_run_md_queue_async(m->ti->table);
> +
>          return 0;
>   }
>
Or, better still, try the attached patch.
There's one more instance where lockdep might complain.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)

--------------090206030006020806020502
Content-Type: text/x-patch;
	name="0001-dm-multipath-Fixup-lockdep-warning.patch"
Content-Disposition: attachment;
	filename="0001-dm-multipath-Fixup-lockdep-warning.patch"
Content-Transfer-Encoding: 7bit

From 44bd0601e47f5cc5d26b679550f0a5a2f2c3f487 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Mon, 26 May 2014 14:45:39 +0200
Subject: [PATCH] dm-multipath: Fixup lockdep warning

lockdep complains about a circular locking.
And indeed, we need to release the lock before calling
dm_table_run_md_queue_asycn().

Reported-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aa009e8..ebfa411 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -445,11 +445,11 @@ static int queue_if_no_path(struct multipath *m, unsigned queue_if_no_path,
 	else
 		m->saved_queue_if_no_path = queue_if_no_path;
 	m->queue_if_no_path = queue_if_no_path;
-	if (!m->queue_if_no_path)
-		dm_table_run_md_queue_async(m->ti->table);
-
 	spin_unlock_irqrestore(&m->lock, flags);
 
+	if (!queue_if_no_path)
+		dm_table_run_md_queue_async(m->ti->table);
+
 	return 0;
 }
 
@@ -954,7 +954,7 @@ out:
  */
 static int reinstate_path(struct pgpath *pgpath)
 {
-	int r = 0;
+	int r = 0, run_queue = 0;
 	unsigned long flags;
 	struct multipath *m = pgpath->pg->m;
 
@@ -978,7 +978,7 @@ static int reinstate_path(struct pgpath *pgpath)
 
 	if (!m->nr_valid_paths++) {
 		m->current_pgpath = NULL;
-		dm_table_run_md_queue_async(m->ti->table);
+		run_queue = 1;
 	} else if (m->hw_handler_name && (m->current_pg == pgpath->pg)) {
 		if (queue_work(kmpath_handlerd, &pgpath->activate_path.work))
 			m->pg_init_in_progress++;
@@ -991,6 +991,8 @@ static int reinstate_path(struct pgpath *pgpath)
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
+	if (run_queue)
+		dm_table_run_md_queue_async(m->ti->table);
 
 	return r;
 }
-- 
1.7.12.4


--------------090206030006020806020502
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--------------090206030006020806020502--
