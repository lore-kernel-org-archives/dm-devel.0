From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] 2.6.12-rc6: fix rh_dec()/rh_inc() race in
	dm-raid1.c
Date: Mon, 27 Jun 2005 13:34:11 -0400
Message-ID: <42C03893.4040105@ce.jp.nec.com>
References: <42B2027D.7040807@ce.jp.nec.com>	<5d3aa9a8d94cf891a9a4b86c8f506379@redhat.com>
	<42BC2A9B.6090304@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050205060200070601050102"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42BC2A9B.6090304@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050205060200070601050102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I revised the patch based on comments from Jon.
Attached patch should work on the version of mark_region which may block.

Thanks,

Jun'ichi Nomura wrote:
> Jonathan E Brassow wrote:
>  > could this be solved by doing your patch in rh_dec and just moving the
>  > atomic_inc in rh_inc?  The reason I ask is that the mark_region log
>  > call can block.
> 
> No.
> Unless they are serialized, it's possible that rh_inc() will see the
> state RH_DIRTY, while rh_dec change it to RH_CLEAN.
> As a result, the region which has I/O in-flight may be freed.
> 
> Is it reasonable to call mark_region() unconditionally?
> Then we can call it outside of the lock.
> 
>  >>    CPU0                                   CPU1
>  >>
>  >> -----------------------------------------------------------------------
>  >> -------
>  >>    rh_dec()
>  >>      if (atomic_dec_and_test(pending))
>  >>         <the region is still marked dirty>
>            if (atomic_read(pending)==0)
>  >>                                           rh_inc()
>  >>                                             atomic_inc(pending)
>  >>                                             if the region is clean
>  >>                                                mark the region dirty
>  >>                                                and remove from clean 
> list
>                                                else do nothing
>  >>         mark the region clean
>  >>         and move to clean list

--------------050205060200070601050102
Content-Type: text/x-patch;
 name="dm-raid1-race2.new.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-raid1-race2.new.patch"

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -375,6 +375,9 @@ static void rh_inc(struct region_hash *r
 
 	read_lock(&rh->hash_lock);
 	reg = __rh_find(rh, region);
+	spin_lock_irq(&rh->region_lock);
+	atomic_inc(&reg->pending);
+	spin_unlock_irq(&rh->region_lock);
 	if (reg->state == RH_CLEAN) {
 		rh->log->type->mark_region(rh->log, reg->key);
 
@@ -384,7 +387,6 @@ static void rh_inc(struct region_hash *r
 		spin_unlock_irq(&rh->region_lock);
 	}
 
-	atomic_inc(&reg->pending);
 	read_unlock(&rh->hash_lock);
 }
 
@@ -408,6 +410,10 @@ static void rh_dec(struct region_hash *r
 
 	if (atomic_dec_and_test(&reg->pending)) {
 		spin_lock_irqsave(&rh->region_lock, flags);
+		if (atomic_read(&reg->pending)) { /* check race */
+			spin_unlock_irqrestore(&rh->region_lock, flags);
+			return;
+		}
 		if (reg->state == RH_RECOVERING) {
 			list_add_tail(&reg->list, &rh->quiesced_regions);
 		} else {

--------------050205060200070601050102
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050205060200070601050102--
