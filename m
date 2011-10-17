From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 12:11:28 +0100
Message-ID: <20111017111128.GF13963@ubuntu>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
@@ -493,8 +500,10 @@ static void use_inline_bio(struct dm_buf
 static void submit_io(struct dm_buffer *b, int rw, sector_t block,
                      bio_end_io_t *end_io)
 {
-       if (b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE &&
-           b->data_mode != DATA_MODE_VMALLOC)
+       if (rw == WRITE && b->c->write_callback)
+               b->c->write_callback(b);
        if (likely(b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE) &&
            likely(b->data_mode != DATA_MODE_VMALLOC))
                use_inline_bio(b, rw, block, end_io);
        else
                use_dmio(b, rw, block, end_io);
@@ -550,8 +559,6 @@ static void __write_dirty_buffer(struct
        clear_bit(B_DIRTY, &b->state);
        wait_on_bit_lock(&b->state, B_WRITING,
                         do_io_schedule, TASK_UNINTERRUPTIBLE);
-       if (b->c->write_callback)
-               b->c->write_callback(b);
        submit_io(b, WRITE, b->block, write_endio);
 }


This doesn't seem an improvement.  Except ... it changes the behaviour
of dm_bufio_release_move().  So was there a preexisting bug in
dm_bufio_release_move() that you're trying to fix with this patch?
