From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v5 0/4] block/dm: allow DM to defer
 blk_register_queue() until ready
Date: Mon, 15 Jan 2018 18:13:32 -0500
Message-ID: <20180115231331.GA18564@redhat.com>
References: <20180112150606.6037-1-snitzer@redhat.com>
 <1516036612.10386.2.camel@wdc.com>
 <20180115221511.GA25858@redhat.com>
 <1516056697.3951.30.camel@wdc.com>
 <20180115231010.GA26447@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180115231010.GA26447@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "djeffery@redhat.com" <djeffery@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: dm-devel.ids

On Mon, Jan 15 2018 at  6:10P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Jan 15 2018 at  5:51pm -0500,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Mon, 2018-01-15 at 17:15 -0500, Mike Snitzer wrote:
> > > sysfs write op calls kernfs_fop_write which takes:
> > > of->mutex then kn->count#213 (no idea what that is)
> > > then q->sysfs_lock (via queue_attr_store)
> > > 
> > > vs 
> > > 
> > > blk_unregister_queue takes:
> > > q->sysfs_lock then
> > > kernfs_mutex (via kernfs_remove)
> > > seems lockdep thinks "kernfs_mutex" is "kn->count#213"?
> > > 
> > > Feels like lockdep code in fs/kernfs/file.c and fs/kernfs/dir.c is
> > > triggering false positives.. because these seem like different kernfs
> > > locks yet they are reported as "kn->count#213".
> > > 
> > > Certainly feeling out of my depth with kernfs's locking though.
> > 
> > Hello Mike,
> > 
> > I don't think that this is a false positive but rather the following traditional
> > pattern of a potential deadlock involving sysfs attributes:
> > * One context obtains a mutex from inside a sysfs attribute method:
> >   queue_attr_store() obtains q->sysfs_lock.
> > * Another context removes a sysfs attribute while holding a mutex:
> >   blk_unregister_queue() removes the queue sysfs attributes while holding
> >   q->sysfs_lock.
> > 
> > This can result in a real deadlock because the code that removes sysfs objects
> > waits until all ongoing attribute callbacks have finished.
> > 
> > Since commit 667257e8b298 ("block: properly protect the 'queue' kobj in
> > blk_unregister_queue") modified blk_unregister_queue() such that q->sysfs_lock
> > is held around the kobject_del(&q->kobj) call I think this is a regression
> > introduced by that commit.
> 
> Sure, of course it is a regression.
> 
> Aside from moving the mutex_unlock(&q->sysfs_lock) above the
> kobject_del(&q->kobj) I don't know how to fix it.
> 
> Though, realistically that'd be an adequate fix (given the way the code
> was before).

Any chance you apply this and re-run your srp_test that triggered the
lockdep splat?

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4a6a40ffd78e..c50e08e9bf17 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -952,10 +952,10 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (q->request_fn || (q->mq_ops && q->elevator))
 		elv_unregister_queue(q);
 
+	mutex_unlock(&q->sysfs_lock);
+
 	kobject_uevent(&q->kobj, KOBJ_REMOVE);
 	kobject_del(&q->kobj);
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 	kobject_put(&disk_to_dev(disk)->kobj);
-
-	mutex_unlock(&q->sysfs_lock);
 }
