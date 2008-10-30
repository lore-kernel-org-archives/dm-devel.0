From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/9] dm snapshot: make chunk_io handle any
	buffer
Date: Thu, 30 Oct 2008 15:06:50 +0900
Message-ID: <20081030150646L.fujita.tomonori@lab.ntt.co.jp>
References: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20081029234852.GM31233@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081029234852.GM31233@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 29 Oct 2008 23:48:52 +0000
Alasdair G Kergon <agk@redhat.com> wrote:

> On Mon, Oct 27, 2008 at 09:07:48PM +0900, FUJITA Tomonori wrote:
> > chunk_io() can perform I/Os only with ps->area. This patch adds a new
> > argument (a pointer to a buffer) to chunk_io() so that it can performs
> > I/Os with the buffer.
>  
> > +static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata,
> > +		    void *data)
> 
> data is part of ps so should not need passing in as it's already accessible!

The later patches uses chunk_io() to I/O for any data buffer (that is,
buffers are not in pstore).


> It's looking like struct pstore is acquiring fields that apply to only one
> type of snapshot:  IOW More-invasive refactoring of that struct is needed.
> - Which fields apply to both?  Which apply only to one type of snapshot?

The 7/9 patch adds the following fields to struct pstore:

 struct disk_exception {
@@ -131,6 +146,27 @@ struct pstore {
 	struct dm_io_client *io_client;
 
 	struct workqueue_struct *metadata_wq;
+
+	/*
+	 * for shared exception
+	 */
+	u64 root_tree_chunk;
+	u64 snapmask;
+	u32 tree_level;
+
+	u32 nr_snapshots;
+
+	unsigned long nr_chunks;
+	unsigned long nr_bitmap_chunks;
+	unsigned long *bitmap;
+	unsigned long cur_bitmap_chunk;
+	unsigned long cur_bitmap_index;
+
+	struct list_head chunk_buffer_list;
+	struct list_head chunk_buffer_dirty_list;
+
+	int header_dirty;
+	int nr_chunk_buffers;


The new snapshot code uses the following existing fields in struct
pstore:

	void *zero_area;
	chunk_t current_area;
	chunk_t next_free;
	uint32_t current_committed;


Do you want to split struct pstore?


Thanks,
