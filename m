From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] Historical Service Time Path Selector
Date: Thu, 23 Apr 2020 16:59:47 -0400
Message-ID: <20200423205947.GA13657@lobo>
References: <20200416211336.2423618-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200416211336.2423618-1-krisman@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, khazhy@google.com, kernel@collabora.com
List-Id: dm-devel.ids

On Thu, Apr 16 2020 at  5:13P -0400,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> Hello,
> 
> This small series implements a new path selector that leverages
> historical path IO time in order to estimate future path performance.
> Implementation details can be found on Patch 2.
> 
> This selector yields better path distribution, considering the mean
> deviation from the calculated optimal utilization, for small IO depths
> when compared to the Service Time selector with fio benchmarks.  For
> instance, on a multipath setup with 4 paths, where one path is 4 times
> slower than the rest, issuing 500MB of randwrites, we have the following
> path utilization rates:
> 
>       |    depth=1    |    depth=64   |       |
>       |   ST  |   HST |   ST  |   HST |  Best |
> |-----+-------+-------+-------+-------+-------|
> | sda | 0.250 | 0.294 | 0.297 | 0.294 | 0.307 |
> | sdb | 0.250 | 0.297 | 0.296 | 0.297 | 0.307 |
> | sdc | 0.250 | 0.296 | 0.298 | 0.296 | 0.307 |
> | sdd | 0.250 | 0.112 | 0.106 | 0.112 | 0.076 |
> 
> For small depths, HST is much quicker in detecting slow paths and has a
> better selection than ST.  As the iodepth increases, ST gets close to
> HST, which still behaves steadily.
> 
> The raw performance data for different depths types of IO can be found
> at:
> 
>   <https://people.collabora.com/~krisman/GOO0012/hst-vs-st-bench.html>
> 
> This was tested primarily on a Google cloud SAN with real data and usage
> patterns and with artificial benchmarks using fio.
> 
> Khazhismel Kumykov (2):
>   md: Expose struct request to path selector
>   md: Add Historical Service Time Path Selector

Looks like you've put a lot of time to this and I'd be happy to help
you get this to land upstream.

But... (you knew there'd be at least one "but" right? ;) I'm not
liking making this path selector request-based specific.  All other
selectors up to this point are request-based vs bio-based agnostic.

Would you be open to dropping patch 1/2 and replacing it with
something like the following patch?

Then you'd pass 'u64 start_time_ns' into the path_selector_type's
.end_io (and possibly .start_io).

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index df13fdebe21f..50121513227b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -674,6 +674,16 @@ static bool md_in_flight(struct mapped_device *md)
 		return md_in_flight_bios(md);
 }
 
+u64 dm_start_time_ns_from_clone(struct bio *bio)
+{
+	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	struct dm_io *io = tio->io;
+
+	/* FIXME: convert io->start_time from jiffies to nanoseconds */
+	return (u64)jiffies_to_msec(io->start_time) * NSEC_PER_MSEC;
+}
+EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
+
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 475668c69dbc..e2d506dd805e 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -329,6 +329,8 @@ void *dm_per_bio_data(struct bio *bio, size_t data_size);
 struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size);
 unsigned dm_bio_get_target_bio_nr(const struct bio *bio);
 
+u64 dm_start_time_ns_from_clone(struct bio *bio);
+
 int dm_register_target(struct target_type *t);
 void dm_unregister_target(struct target_type *t);
 
