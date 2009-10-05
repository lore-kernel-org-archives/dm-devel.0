From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: clustered snapshots
Date: Mon, 5 Oct 2009 09:38:41 -0400
Message-ID: <20091005133841.GA30122@redhat.com>
References: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
	<20091002172656.GA13491@redhat.com>
	<20091004034843.GC25374@redhat.com>
	<Pine.LNX.4.64.0910042214530.12074@hs20-bc2-1.build.redhat.com>
	<20091005043334.GA27758@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091005043334.GA27758@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 05 2009 at 12:33am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Sun, Oct 04 2009 at 10:25pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > I don't understand the purpose of this patch. I think it's useless.
> 
> You don't understand it, so you think it's useless.. nice to know where
> I'm starting.
> 
> > - during merge, nothing except the merge process reads the on-disk 
> > exceptions. So it doesn't matter when you clean them. You must clean them 
> > before dropping the interlock, but the order is not important.
> 
> Sure, I thought the same but quickly realized that in practice order
> does matter if you'd like to avoid failing the in-core exception cleanup
> (IFF we allow chunks to be inserted before existing chunks; aka
> "back-merges").
> 
> Your original approach to cleaning all on-disk exceptions then all
> in-core has no hope of working for "back-merges".  Your original
> snapshot-merge completely eliminated insertions before existing chunks.

<snip - my long-winded defensiveness>

> Lesson I learned is that the in-core dm_snap_exception's consecutive
> chunk accounting is _really_ subtle.  And while I agree there should be
> no relation between the proper cleanup of on-disk and in-core
> exceptions; doing the cleanup of each in lock-step appears to be the
> only way forward (that I found).

If I just judge the location of the chunk within the in-core exception
support for back-merges works just as well.  Here is a minimalist patch
the accomplishes the same:

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index bcfbe85..b271f56 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -790,17 +790,25 @@ static void merge_callback(int read_err, unsigned long write_err, void *context)
         * so that dm_consecutive_chunk_count_dec() accounting works
         */
        for (i = s->merge_write_interlock_n - 1; i >= 0; i--) {
-               e = lookup_exception(&s->complete,
-                                    s->merge_write_interlock + i);
+               chunk_t old_chunk = s->merge_write_interlock + i;
+               e = lookup_exception(&s->complete, old_chunk);
                if (!e) {
                        DMERR("exception for block %llu is on "
                              "disk but not in memory",
-                             (unsigned long long)
-                             s->merge_write_interlock + i);
+                             (unsigned long long)old_chunk);
                        up_write(&s->lock);
                        goto shut;
                }
                if (dm_consecutive_chunk_count(e)) {
+                       if (old_chunk == e->old_chunk) {
+                               e->old_chunk++;
+                               e->new_chunk++;
+                       } else if (old_chunk != e->old_chunk +
+                                  dm_consecutive_chunk_count(e)) {
+                               DMERR("merge from the middle of a chunk range");
+                               up_write(&s->lock);
+                               goto shut;
+                       }
                        dm_consecutive_chunk_count_dec(e);
                } else {
                        remove_exception(e);
