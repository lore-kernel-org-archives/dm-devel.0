Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65347C001B0
	for <dm-devel@archiver.kernel.org>; Tue,  8 Aug 2023 19:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691521635;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=BlrOMFJUyVo0lYE6OE1DV/gXju55RPnsjS1HbdkBufI=;
	b=S7C+N33wuudNvIOwpNPDuCDS4MuXUVLOOVaNmWg+KVP6sQjKEKwAAlKPGZ30sfL1Se4TCq
	Kot1qzsjVz3D3R6cQDzu8kxLATUq4nPF+gpZRP1jFFjS5mebp17uOYO3y3hetVyuheEnap
	BEpM2xoTWDjgfTqxlYI/Uk5xhTmvmvU=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-2fLgbnYAM3GJx8aWC8eTLw-1; Tue, 08 Aug 2023 15:07:10 -0400
X-MC-Unique: 2fLgbnYAM3GJx8aWC8eTLw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 812CB3C0ED43;
	Tue,  8 Aug 2023 19:06:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 742264EA54;
	Tue,  8 Aug 2023 19:06:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3F0171946588;
	Tue,  8 Aug 2023 19:06:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E9591946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Aug 2023 19:06:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B9B5D40BC782; Tue,  8 Aug 2023 19:06:44 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B892D40C6F53;
 Tue,  8 Aug 2023 19:06:43 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id E5D1730F66DC; Tue,  8 Aug 2023 19:06:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 D707377D7F; Tue,  8 Aug 2023 21:06:18 +0200 (CEST)
Date: Tue, 8 Aug 2023 21:06:18 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
In-Reply-To: <ZMqFVGX/ZbVABDJ6@redhat.com>
Message-ID: <a508359-734b-35c9-a393-42c27870a1fa@redhat.com>
References: <20221010144123.252329-1-luomeng@huaweicloud.com>
 <Y02zebNyn73/MN1d@redhat.com>
 <eb9e1d80-c62c-c62f-4fc2-5be21fc75472@huawei.com>
 <ZMqFVGX/ZbVABDJ6@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [dm-devel resend] dm mpath: fix UAF in
 multipath_message()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: ejt@redhat.com, Luo Meng <luomeng@huaweicloud.com>, dm-devel@redhat.com,
 luomeng12@huawei.com, yukuai3@huawei.com,
 "lilingfeng \(A\)" <lilingfeng3@huawei.com>, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="185210117-676874237-1691521578=:167887"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185210117-676874237-1691521578=:167887
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Wed, 2 Aug 2023, Mike Snitzer wrote:

> On Thu, May 18 2023 at  8:11P -0400,
> lilingfeng (A) <lilingfeng3@huawei.com> wrote:
> 
> > 
> > 在 2022/10/18 3:56, Mike Snitzer 写道:
> > > On Mon, Oct 10 2022 at 10:41P -0400,
> > > Luo Meng <luomeng@huaweicloud.com> wrote:
> > > 
> > > > From: Luo Meng <luomeng12@huawei.com>
> > > > 
> > > > If dm_get_device() create dd in multipath_message(),
> > > > and then call table_deps() after dm_put_table_device(),
> > > > it will lead to concurrency UAF bugs.
> > > > 
> > > > One of the concurrency UAF can be shown as below:
> > > > 
> > > >           (USE)                        |    (FREE)
> > > >                                        |  target_message
> > > >                                        |    multipath_message
> > > >                                        |      dm_put_device
> > > >                                        |        dm_put_table_device #
> > > >                                        |          kfree(td)  # table_device *td
> > > > ioctl # DM_TABLE_DEPS_CMD             |         ...
> > > >    table_deps                          |         ...
> > > >    dm_get_live_or_inactive_table       |         ...
> > > >      retrieve_dep                      |         ...
> > > >      list_for_each_entry               |         ...
> > > >        deps->dev[count++] =            |         ...
> > > >            huge_encode_dev             |         ...
> > > >            (dd->dm_dev->bdev->bd_dev)  |        list_del(&dd->list)
> > > >                                        |        kfree(dd) # dm_dev_internal
> > > > 
> > > > The root cause of UAF bugs is that find_device() failed in
> > > > dm_get_device() and will create dd and refcount set 1, kfree()
> > > > in dm_put_table() is not protected. When td, which there are
> > > > still pointers point to, is released, the concurrency UAF bug
> > > > will happen.
> > > > 
> > > > This patch add a flag to determine whether to create a new dd.
> > > > 
> > > > Fixes: 8215d6ec5fee(dm table: remove unused dm_get_device range parameters)
> > > > Signed-off-by: Luo Meng <luomeng12@huawei.com>
> > > > ---
> > > >   drivers/md/dm-mpath.c         |  2 +-
> > > >   drivers/md/dm-table.c         | 43 +++++++++++++++++++++--------------
> > > >   include/linux/device-mapper.h |  2 ++
> > > >   3 files changed, 29 insertions(+), 18 deletions(-)
> > > > 
> > > > diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> > > > index 0e325469a252..1f51059520ac 100644
> > > > --- a/drivers/md/dm-mpath.c
> > > > +++ b/drivers/md/dm-mpath.c
> > > > @@ -2001,7 +2001,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv,
> > > >   		goto out;
> > > >   	}
> > > > -	r = dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev);
> > > > +	r = __dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev, false);
> > > >   	if (r) {
> > > >   		DMWARN("message: error getting device %s",
> > > >   		       argv[1]);
> > > > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > > > index d8034ff0cb24..ad18a41f1608 100644
> > > > --- a/drivers/md/dm-table.c
> > > > +++ b/drivers/md/dm-table.c
> > > > @@ -338,12 +338,8 @@ dev_t dm_get_dev_t(const char *path)
> > > >   }
> > > >   EXPORT_SYMBOL_GPL(dm_get_dev_t);
> > > > -/*
> > > > - * Add a device to the list, or just increment the usage count if
> > > > - * it's already present.
> > > > - */
> > > > -int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > > > -		  struct dm_dev **result)
> > > > +int __dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > > > +		    struct dm_dev **result, bool create_dd)
> > > >   {
> > > >   	int r;
> > > >   	dev_t dev;
> > > > @@ -367,19 +363,21 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > > >   	dd = find_device(&t->devices, dev);
> > > >   	if (!dd) {
> > > > -		dd = kmalloc(sizeof(*dd), GFP_KERNEL);
> > > > -		if (!dd)
> > > > -			return -ENOMEM;
> > > > -
> > > > -		if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
> > > > -			kfree(dd);
> > > > -			return r;
> > > > -		}
> > > > +		if (create_dd) {
> > > > +			dd = kmalloc(sizeof(*dd), GFP_KERNEL);
> > > > +			if (!dd)
> > > > +				return -ENOMEM;
> > > > -		refcount_set(&dd->count, 1);
> > > > -		list_add(&dd->list, &t->devices);
> > > > -		goto out;
> > > > +			if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
> > > > +				kfree(dd);
> > > > +				return r;
> > > > +			}
> > > > +			refcount_set(&dd->count, 1);
> > > > +			list_add(&dd->list, &t->devices);
> > > > +			goto out;
> > > > +		} else
> > > > +			return -ENODEV;
> > > >   	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
> > > >   		r = upgrade_mode(dd, mode, t->md);
> > > >   		if (r)
> > > > @@ -390,6 +388,17 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > > >   	*result = dd->dm_dev;
> > > >   	return 0;
> > > >   }
> > > > +EXPORT_SYMBOL(__dm_get_device);
> > > > +
> > > > +/*
> > > > + * Add a device to the list, or just increment the usage count if
> > > > + * it's already present.
> > > > + */
> > > > +int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > > > +		  struct dm_dev **result)
> > > > +{
> > > > +	return __dm_get_device(ti, path, mode, result, true);
> > > > +}
> > > >   EXPORT_SYMBOL(dm_get_device);
> > > >   static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
> > > > diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> > > > index 04c6acf7faaa..ef4031a844b6 100644
> > > > --- a/include/linux/device-mapper.h
> > > > +++ b/include/linux/device-mapper.h
> > > > @@ -178,6 +178,8 @@ dev_t dm_get_dev_t(const char *path);
> > > >   int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > > >   		  struct dm_dev **result);
> > > >   void dm_put_device(struct dm_target *ti, struct dm_dev *d);
> > > > +int __dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
> > > > +		    struct dm_dev **result, bool create_dd);
> > > >   /*
> > > >    * Information about a target type
> > > > -- 
> > > > 2.31.1
> > > > 
> > > This patch is treating the one multipath case like it is only consumer
> > > of dm_get_device() that might have this issue. It feels too focused on
> > > an instance where dm_get_device()'s side-effect of creating the device
> > > is unwelcome. Feels like you're treating the symptom rather than the
> > > problem (e.g. that the "kfree() in dm_put_table() is not protected"?)
> > > 
> > > Mike
> > 
> > In other cases, kfree() in dm_put_table() is protected by srcu.
> > For example:
> >           USE                              FREE
> > table_deps                            dev_remove
> >  dm_get_live_or_inactive_table         dm_sync_table
> >   // lock
> >   srcu_read_lock(&md->io_barrier)
> >                                         // wait for unlock
> >                                         synchronize_srcu(&md->io_barrier)
> >   retrieve_deps
> >  dm_put_live_table
> >   // unlock
> >   srcu_read_unlock(&md->io_barrier...)
> >                                        dm_table_destroy
> >                                         linear_dtr
> >                                          dm_put_device
> >                                           dm_put_table_device
> > 
> > However, in multipath_message(), the dm_dev is created and destroyed
> > under srcu_read_lock, which means destroying dm_dev in this process
> > and using dm_dev in other process will happen at same time since both
> > of them hold srcu_read_lock.
> > 
> > target_message
> >  dm_get_live_table // lock
> >   multipath_message
> >    dm_get_device // created
> >     // may be got by other processes
> >    dm_put_device // destroyed
> >     // may be used by other processes
> >  dm_put_live_table // unlock
> > 
> > We figured out some other solutions:
> > 1) Judge refcount of dd under some lock before using dm_dev;
> > 2) Get dd from list and use dm_dev under rcu;
> > 3) Implement dm_get_device_xxx() with reference to dm_get_device()
> > for dm-mpath to avoid creating dd when find_device() failed.
> > 
> > Compared to solutions above, Luo Meng's patch may be more appropriate.
> > Any suggestions will be appreciated.
> > 
> > Li
> 
> [Cc'ing Mikulas so he can take a look at this too.]

Hi

I suggest this patch (but it's only compile-tested, so please run some 
testsuite on it).

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: fix a race condition in retrieve_deps

There's a race condition in the multipath target when retrieve_deps races
with multipath_message. multipath_message opens and closes a device using
dm_get_device and dm_put_device; retrieve_deps walks the list of open
devices without holding any lock. The end result may be memory corruption
or use-after-free memory access.

multipath_message already holds a mutex that prevents two
multipath_messages from running concurrently - in order to fix this race
condition, we modify retrieve_deps, so that it grabs and frees this mutex
too.

We add an entry "devices_mutex" to "struct dm_table" and we introduce a 
function "dm_table_set_devices_mutex" that sets it. The mutex is set in 
the multipath target contructor.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-core.h          |    5 +++++
 drivers/md/dm-ioctl.c         |    9 ++++++++-
 drivers/md/dm-mpath.c         |    2 ++
 drivers/md/dm-table.c         |    6 ++++++
 include/linux/device-mapper.h |    5 +++++
 5 files changed, 26 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h
+++ linux-2.6/drivers/md/dm-core.h
@@ -214,6 +214,11 @@ struct dm_table {
 
 	/* a list of devices used by this table */
 	struct list_head devices;
+	/*
+	 * The mutex should be set if the target modifies the "devices" list
+	 * outside of the constructor and destructor.
+	 */
+	struct mutex *devices_mutex;
 
 	/* events get handed up using this callback */
 	void (*event_fn)(void *data);
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -2034,6 +2034,12 @@ struct list_head *dm_table_get_devices(s
 	return &t->devices;
 }
 
+void dm_table_set_devices_mutex(struct dm_table *t, struct mutex *m)
+{
+	t->devices_mutex = m;
+}
+EXPORT_SYMBOL(dm_table_set_devices_mutex);
+
 blk_mode_t dm_table_get_mode(struct dm_table *t)
 {
 	return t->mode;
Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1630,6 +1630,9 @@ static void retrieve_deps(struct dm_tabl
 	struct dm_dev_internal *dd;
 	struct dm_target_deps *deps;
 
+	if (table->devices_mutex)
+		mutex_lock(table->devices_mutex);
+
 	deps = get_result_buffer(param, param_size, &len);
 
 	/*
@@ -1644,7 +1647,7 @@ static void retrieve_deps(struct dm_tabl
 	needed = struct_size(deps, dev, count);
 	if (len < needed) {
 		param->flags |= DM_BUFFER_FULL_FLAG;
-		return;
+		goto ret;
 	}
 
 	/*
@@ -1656,6 +1659,10 @@ static void retrieve_deps(struct dm_tabl
 		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
+
+ret:
+	if (table->devices_mutex)
+		mutex_unlock(table->devices_mutex);
 }
 
 static int table_deps(struct file *filp, struct dm_ioctl *param, size_t param_size)
Index: linux-2.6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-mpath.c
+++ linux-2.6/drivers/md/dm-mpath.c
@@ -1268,6 +1268,8 @@ static int multipath_ctr(struct dm_targe
 	else
 		ti->per_io_data_size = sizeof(struct dm_mpath_io);
 
+	dm_table_set_devices_mutex(ti->table, &m->work_mutex);
+
 	return 0;
 
  bad:
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -177,6 +177,11 @@ struct dm_dev {
 int dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
 		  struct dm_dev **result);
 void dm_put_device(struct dm_target *ti, struct dm_dev *d);
+/*
+ * The mutex must be set if we use dm_get_device or dm_put_device outside
+ * of the constructor and destructor.
+ */
+void dm_table_set_devices_mutex(struct dm_table *t, struct mutex *m);
 
 /*
  * Information about a target type
--185210117-676874237-1691521578=:167887
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--185210117-676874237-1691521578=:167887--

