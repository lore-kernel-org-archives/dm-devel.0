From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V11 07/19] fs/buffer.c: use bvec iterator to truncate
 the bio
Date: Thu, 22 Nov 2018 11:58:49 +0100
Message-ID: <20181122105849.GA30066@lst.de>
References: <20181121032327.8434-1-ming.lei@redhat.com> <20181121032327.8434-8-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181121032327.8434-8-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <oo>
List-Id: dm-devel.ids

Btw, given that this is the last user of bvec_last_segment after my
other patches I think we should kill bvec_last_segment and do something
like this here:


diff --git a/fs/buffer.c b/fs/buffer.c
index fa37ad52e962..af5e135d2b83 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2981,6 +2981,14 @@ static void end_bio_bh_io_sync(struct bio *bio)
 	bio_put(bio);
 }
 
+static void zero_trailing_sectors(struct bio_vec *bvec, unsigned bytes)
+{
+	unsigned last_page = (bvec->bv_offset + bvec->bv_len - 1) >> PAGE_SHIFT;
+
+	zero_user(nth_page(bvec->bv_page, last_page),
+		  bvec->bv_offset % PAGE_SIZE + bvec->bv_len, bytes);
+}
+
 /*
  * This allows us to do IO even on the odd last sectors
  * of a device, even if the block size is some multiple
@@ -3031,13 +3039,8 @@ void guard_bio_eod(int op, struct bio *bio)
 	bvec->bv_len -= truncated_bytes;
 
 	/* ..and clear the end of the buffer for reads */
-	if (op == REQ_OP_READ) {
-		struct bio_vec bv;
-
-		bvec_last_segment(bvec, &bv);
-		zero_user(bv.bv_page, bv.bv_offset + bv.bv_len,
-				truncated_bytes);
-	}
+	if (op == REQ_OP_READ)
+		zero_trailing_sectors(bvec, truncated_bytes);
 }
 
 static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
