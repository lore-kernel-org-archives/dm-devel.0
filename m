From: "Penguin Lin" <penguin.taiwan@gmail.com>
Subject: Some questions in dm-riad1.c
Date: Tue, 17 Apr 2007 22:54:39 +0800
Message-ID: <f535b83b0704170754t31abd62dn619cb1e796949927@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dear all :

I have some(or lots, more precisely) questions when tracing the mirror code!

file : dm-raid.c
function : mirror_map

1.===================================

Dose there any better solution to test the performance of the device-mapper core
and all target type module ?

====================================


2. ===================================

First is the kcopyd necessary in dm-mirror (in previous mail)?
Because dm-mirror will submit each writing bio to all mirror block devices.
It seems kcopyd does not have any works to do in mirror_map().

More precisely :

In log ctr, all region will be logged as non-sync(core-log) or
previous setting(disk-log).
When starting mirror, mirror daemon will recovery these non-sync
region by invoking kcopyd daemon
accroding to the dirty log object. But after these regions are all in
synchronous.... kcopyd has nothing to do... Is that right ?

Here are some problems that confuses me for a log time...

1. The only work of kcopyd is only available in configure time  (after
log->ctr, since all in-sync bits are set to 0, whatever core-log or
disk-log) ?
    On the other hand, Does kcopyd work nothing after the mirror
configure time ?
1-1. We have to re-sync all regions after re-booting if we use core-log ?
1-2. Even for disk-log...... kcopyd wroks only in configure time
(first time to construct a disk log) ?

2. There seems a lack for dm-mirror interface (dm-raid1.c)
    to set/clear the sync state for a region.

Under what other conditions the kcopyd will work ?

Whould we implement as following :
s1. write bio to default mirror device.
s2. set the corresponding region to non-sync state
s3. invoke kcopyd to recovery this region to all mirror devices (set
the region in recovering.)
s4. kcopyd callback function set the region in-sync.

Is this better ? Any issue (like read/write race in default mirror device) ?
In my option, it would make the use of kcopyd more, and determine the
region state
(in-sync, non-sync) more precisely...
But any racing condition occurs (read/write race...etc)?

====================================


In mirror_map function

3. =====================
        r = ms->rh.log->type->in_sync(ms->rh.log,
                                      bio_to_region(&ms->rh, bio), 0);

        /*
          *   *********** HERE ***********
          *   When does the in_sync() return  < 1  ?
          *   It is strange here since in_sync(core_in_sync) return
          *   either 0(non-sync) or 1(in-sync).
          */
        if (r < 0 && r != -EWOULDBLOCK)
                return r;

        /* Simply return -EIO ? */
        if (r == -EWOULDBLOCK)  /* FIXME: ugly */
                r = DM_MAPIO_SUBMITTED;

        /*
         * We don't want to fast track a recovery just for a read
         * ahead.  So we just let it silently fail.
         * FIXME: get rid of this.
         */
        if (!r && rw == READA)
                return -EIO;

4.  =============================================

        /*
          *    *********** HERE ***********
          *    What followed seems duplicate in do_read().
          *    Why not implemented as follows as simple:
          *
          *    queue_bio(ms, bio, rw);
           *    return DM_MAPIO_SUBMITTED;
          *
          *    and let daemon to process reading ? Any performance issue ?
          */
        if (!r) {
                /* Pass this io over to the daemon */
                queue_bio(ms, bio, rw);
                return DM_MAPIO_SUBMITTED;
        }

        m = choose_mirror(ms, bio->bi_sector);
        if (!m)
                return -EIO;

        map_bio(ms, m, bio);
        return DM_MAPIO_REMAPPED;

===================================================


regard.

By Penguin, Kaohsiung, Taiwan.
