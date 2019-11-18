From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm-thin: wakeup worker only when deferred
	bios exist
Date: Mon, 18 Nov 2019 10:13:30 -0500
Message-ID: <20191118151330.GA9830@redhat.com>
References: <1574041838-92149-1-git-send-email-jefflexu@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1574041838-92149-1-git-send-email-jefflexu@linux.alibaba.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: joseph.qi@linux.alibaba.com, ejt@redhat.com, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Sun, Nov 17 2019 at  8:50pm -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Single thread fio test (read, bs=3D4k, ioengine=3Dlibaio, iodepth=3D128,
> numjobs=3D1) over dm-thin device has poor performance versus bare nvme
> disk.
>=20
> Further investigation with perf indicates that queue_work_on() consumes
> over 20% CPU time when doing IO over dm-thin device. The call stack is
> as follows.
>=20
> - 40.57% thin_map
>     + 22.07% queue_work_on
>     + 9.95% dm_thin_find_block
>     + 2.80% cell_defer_no_holder
>       1.91% inc_all_io_entry.isra.33.part.34
>     + 1.78% bio_detain.isra.35
>=20
> In cell_defer_no_holder(), wakeup_worker() is always called, no matter
> whether the tc->deferred_bio_list list is empty or not. In single thread
> IO model, this list is most likely empty. So skip waking up worker thread
> if tc->deferred_bio_list list is empty.
>=20
> A significant IO performance of single thread can be seen with this patch=
.
> The original IO performance is 448 MiB/s with the fio test previously
> described, while it is 646 MiB/s after applying the patch, which is a
> 44% performance improvement.
>=20
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
> Changes since V1:
> 1. Check whether tc->deferred_bio_list list is empty or not, rather than
> cell->bios as before.
> 2. Retest the performance with the new version of this patch, and update
> the statistics in the commit message.

I've staged this with slight revisions to the header and renamed the
empty variable to has_work, please see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/=
commit/?h=3Ddm-5.5&id=3Dd256d796279de0bdc227ff4daef565aa7e80c898

Thanks.
