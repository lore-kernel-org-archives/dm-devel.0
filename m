From: thornber@redhat.com
Subject: Re: About function bio_detain in file dm-cache-target.c
Date: Tue, 12 Mar 2013 13:23:22 +0000
Message-ID: <20130312132321.GA6000@raspberrypi>
References: <513EDD90.6090305@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <513EDD90.6090305@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, Mar 12, 2013 at 03:47:28PM +0800, majianpeng wrote:
> Hi all,
>     I think bio_detain(in dm-cache-target.c) may cause some bug.

Hi Jianpeng,

I don't really see what you're getting at, but will try and explain
bio_detain a bit.

The bio prison contains a bunch of cells.  When you call bio_detain
the following steps are performed:

    i) look up the cell
    ii) if the cell exists add the bio to that cell
    iii) if there is no cell create it and insert the bio as the holder

It does do more than I'd like a single function to do, but we need
this group of operations to be atomic to avoid race conditions.

Now if you look at cache_map() where bio_detain is used:

        r = bio_detain(cache, block, bio, cell,
                       (cell_free_fn) free_prison_cell,
                       cache, &cell);
        if (r) {
                if (r < 0)
                        defer_bio(cache, bio);

                return DM_MAPIO_SUBMITTED;
        }

We call bio_detain checking the return value, there are 3 cases:

   0 - this bio has been inserted as the holder, we try and process it
       immediately and do not pass it to the worker thread.

   1 - the bio has been inserted into the cell, but it's not the
       holder.  When the holder of that particular cell completes it will
       release all bios in the cell, putting them on the deferred list for
       processing by the worker thread.

   < 0 - we couldn't complete, hand over to the worker thread who has
         a bit more leeway regarding memory allocation etc.

In typical use, a cell is only held while we decide what to do with the
bio (see calls to cell_defer in cache_map).  But sometimes we decide
to move a block from/to the cache, in which case the bio_prison
prevents any io going to that block while the migration is pending.

I hope that helps,

- Joe
