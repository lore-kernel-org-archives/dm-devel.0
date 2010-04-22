From: San Mehat <san@google.com>
Subject: Re: [PATCH] md: dm-crypt: Add option to re-use a new
	global work-queue.
Date: Thu, 22 Apr 2010 11:08:29 -0700
Message-ID: <q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
References: <1271958538-11193-1-git-send-email-san@google.com>
	<4BD08F78.4000701@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BD08F78.4000701@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: Brian Swetland <swetland@google.com>, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

On Thu, Apr 22, 2010 at 11:03 AM, Milan Broz <mbroz@redhat.com> wrote:
> On 04/22/2010 07:48 PM, San Mehat wrote:
>> Typically, dm-crypt instances each have their own set of kcrypt/kcrypt_io
>> work-queues. This patch adds an option which will create one set of
>> work-queues on init, and re-uses them for all dm-crypt target instances.
>
> Hi,
>
> I'll take a look, but you are basically re-introducing previous
> logic and it was removed because of deadlock possibility.
>
> (Imagine stacked dm-crypt - Truecrypt uses that - and low memory situatio=
n.
> The mempool is exhausted and only possibility to free memory is finishing=
 some
> request in another queue - which is the same (blocked) queue with your pa=
tch!
>
> We must allocate bio clones there and using per-device mempools and queues
> to avoid these problems.
>
> And how this will work with asynchronous crypto processing when weh
> must wait if crypto queue is full? (In the same device stacked situation.)
>
> Can you explain the real reason for this patch?
>

Sure, I'd be happy to explain.

  Upcoming versions of android are about to start using dm/dm-crypt
heavily, having
a large number of small dm-crypt instances running on the device (hard
to tell just
how many, but i've seen cases where up to 50 or 60 instances may be
running). This ends up creating 100 - 120 kernel threads, and I was
simply trying to cut that down.

I'd be more than happy to discuss alternatives; but do we *really*
need 2 work-queue threads per instance?

> (cc: Alasdair - I think he will not accept the patch anyway.)

Probably not, but at least we can get the discussion going :)

>
> Milan
>
>
>>
>> Cc: Milan Broz <mbroz@redhat.com>
>> Cc: Brian Swetland <swetland@google.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Christophe Saout <christophe@saout.de>
>> Signed-off-by: San Mehat <san@google.com>
>> ---
>> =A0drivers/md/Kconfig =A0 =A0| =A0 10 ++++++++++
>> =A0drivers/md/dm-crypt.c | =A0 42 ++++++++++++++++++++++++++++++++++++++=
+---
>> =A02 files changed, 49 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
>> index 2158377..8d82dfc 100644
>> --- a/drivers/md/Kconfig
>> +++ b/drivers/md/Kconfig
>> @@ -244,6 +244,16 @@ config DM_CRYPT
>>
>> =A0 =A0 =A0 =A0 If unsure, say N.
>>
>> +config DM_CRYPT_GLOBAL_WORKQUEUES
>> + =A0 =A0 boolean "Use global instead of per-device work-queues"
>> + =A0 =A0 depends on DM_CRYPT
>> + =A0 =A0 ---help---
>> + =A0 =A0 =A0 Normally 2 kernel work-queue threads are created for every
>> + =A0 =A0 =A0 dm-crypt target. This option creates only 1 set of work-qu=
eues
>> + =A0 =A0 =A0 on init, and re-uses them.
>> +
>> + =A0 =A0 =A0 If unsure, say N.
>> +
>> =A0config DM_SNAPSHOT
>> =A0 =A0 =A0 =A0 tristate "Snapshot target"
>> =A0 =A0 =A0 =A0 depends on BLK_DEV_DM
>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>> index 959d6d1..875ad9a 100644
>> --- a/drivers/md/dm-crypt.c
>> +++ b/drivers/md/dm-crypt.c
>> @@ -104,8 +104,10 @@ struct crypt_config {
>> =A0 =A0 =A0 mempool_t *page_pool;
>> =A0 =A0 =A0 struct bio_set *bs;
>>
>> +#ifndef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
>> =A0 =A0 =A0 struct workqueue_struct *io_queue;
>> =A0 =A0 =A0 struct workqueue_struct *crypt_queue;
>> +#endif
>>
>> =A0 =A0 =A0 /*
>> =A0 =A0 =A0 =A0* crypto related data
>> @@ -148,6 +150,10 @@ struct crypt_config {
>> =A0#define MIN_BIO_PAGES =A08
>>
>> =A0static struct kmem_cache *_crypt_io_pool;
>> +#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
>> +static struct workqueue_struct *_io_queue;
>> +static struct workqueue_struct *_crypt_queue;
>> +#endif
>>
>> =A0static void clone_init(struct dm_crypt_io *, struct bio *);
>> =A0static void kcryptd_queue_crypt(struct dm_crypt_io *io);
>> @@ -730,7 +736,11 @@ static void kcryptd_queue_io(struct dm_crypt_io *io)
>> =A0 =A0 =A0 struct crypt_config *cc =3D io->target->private;
>>
>> =A0 =A0 =A0 INIT_WORK(&io->work, kcryptd_io);
>> +#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
>> + =A0 =A0 queue_work(_io_queue, &io->work);
>> +#else
>> =A0 =A0 =A0 queue_work(cc->io_queue, &io->work);
>> +#endif
>> =A0}
>>
>> =A0static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io,
>> @@ -914,7 +924,11 @@ static void kcryptd_queue_crypt(struct dm_crypt_io =
*io)
>> =A0 =A0 =A0 struct crypt_config *cc =3D io->target->private;
>>
>> =A0 =A0 =A0 INIT_WORK(&io->work, kcryptd_crypt);
>> +#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
>> + =A0 =A0 queue_work(_crypt_queue, &io->work);
>> +#else
>> =A0 =A0 =A0 queue_work(cc->crypt_queue, &io->work);
>> +#endif
>> =A0}
>>
>> =A0/*
>> @@ -1165,6 +1179,7 @@ static int crypt_ctr(struct dm_target *ti, unsigne=
d int argc, char **argv)
>> =A0 =A0 =A0 } else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cc->iv_mode =3D NULL;
>>
>> +#ifndef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
>> =A0 =A0 =A0 cc->io_queue =3D create_singlethread_workqueue("kcryptd_io");
>> =A0 =A0 =A0 if (!cc->io_queue) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Couldn't create kcryptd io qu=
eue";
>> @@ -1174,15 +1189,15 @@ static int crypt_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
>> =A0 =A0 =A0 cc->crypt_queue =3D create_singlethread_workqueue("kcryptd");
>> =A0 =A0 =A0 if (!cc->crypt_queue) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ti->error =3D "Couldn't create kcryptd queue=
";
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto bad_crypt_queue;
>> + =A0 =A0 =A0 =A0 =A0 =A0 destroy_workqueue(cc->io_queue);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto bad_io_queue;
>> =A0 =A0 =A0 }
>> +#endif
>>
>> =A0 =A0 =A0 ti->num_flush_requests =3D 1;
>> =A0 =A0 =A0 ti->private =3D cc;
>> =A0 =A0 =A0 return 0;
>>
>> -bad_crypt_queue:
>> - =A0 =A0 destroy_workqueue(cc->io_queue);
>> =A0bad_io_queue:
>> =A0 =A0 =A0 kfree(cc->iv_mode);
>> =A0bad_ivmode_string:
>> @@ -1210,8 +1225,10 @@ static void crypt_dtr(struct dm_target *ti)
>> =A0{
>> =A0 =A0 =A0 struct crypt_config *cc =3D (struct crypt_config *) ti->priv=
ate;
>>
>> +#ifndef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
>> =A0 =A0 =A0 destroy_workqueue(cc->io_queue);
>> =A0 =A0 =A0 destroy_workqueue(cc->crypt_queue);
>> +#endif
>>
>> =A0 =A0 =A0 if (cc->req)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_free(cc->req, cc->req_pool);
>> @@ -1399,6 +1416,21 @@ static int __init dm_crypt_init(void)
>> =A0{
>> =A0 =A0 =A0 int r;
>>
>> +#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
>> + =A0 =A0 _io_queue =3D create_singlethread_workqueue("kcryptd_io");
>> + =A0 =A0 if (!_io_queue) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 DMERR("couldn't create kcryptd io queue");
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 _crypt_queue =3D create_singlethread_workqueue("kcryptd");
>> + =A0 =A0 if (!_crypt_queue) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 DMERR("couldn't create kcryptd queue");
>> + =A0 =A0 =A0 =A0 =A0 =A0 destroy_workqueue(_io_queue);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 }
>> +#endif
>> +
>> =A0 =A0 =A0 _crypt_io_pool =3D KMEM_CACHE(dm_crypt_io, 0);
>> =A0 =A0 =A0 if (!_crypt_io_pool)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> @@ -1416,6 +1448,10 @@ static void __exit dm_crypt_exit(void)
>> =A0{
>> =A0 =A0 =A0 dm_unregister_target(&crypt_target);
>> =A0 =A0 =A0 kmem_cache_destroy(_crypt_io_pool);
>> +#ifdef CONFIG_DM_CRYPT_GLOBAL_WORKQUEUES
>> + =A0 =A0 destroy_workqueue(_io_queue);
>> + =A0 =A0 destroy_workqueue(_crypt_queue);
>> +#endif
>> =A0}
>>
>> =A0module_init(dm_crypt_init);
>



-- =

San Mehat =A0| =A0Staff Software Engineer =A0| =A0Android =A0| =A0Google In=
c.
415.366.6172 (san@google.com)
