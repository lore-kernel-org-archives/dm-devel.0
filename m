From: Eduard Bloch <edi@gmx.de>
Subject: Re: Strange data corruption with RW snapshots
Date: Wed, 5 Oct 2005 18:16:10 +0200
Message-ID: <20051005161610.GA5696@debian>
References: <20051001112009.GC24685@debian>
	<200510051049.31055.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200510051049.31055.kevcorry@us.ibm.com>
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

#include <hallo.h>
* Kevin Corry [Wed, Oct 05 2005, 10:49:30AM]:

> > # this was expected to be a workaround, mapping the loop device to a
> > # devmapper volume. It did also fail when using pure $COWDEV
> > echo "0 $VOL_SIZE linear $COWDEV 0"    | $DMSETUP create cow
> 
> This also should not be necessary. What kind of failure do you get if you use 
> $COWDEV directly?

As said, I did also use COWDEV directly and got the same errors.

> > #remount
> > /static/mount /dev/mapper/$SNAPSHOT_NAME /KNOPPIX
> > # we are back, rewritable
> > bash
> > # And this bash command running on /KNOPPIX already fails with obscure
> > # errors.
> 
> I just ran a similar test (on a 2.6.12 kernel):
>
> # Create loop devices
> dd if=/dev/zero of=loop_file0 bs=1M count=1 seek=1024
> dd if=/dev/zero of=loop_file1 bs=1M count=1 seek=1024
> losetup /dev/loop0 loop_file0
> losetup /dev/loop1 loop_file1

It is similar, but not the same. In the meantime, I found out that those
mysterious data corruption happens only if you use a cloop as origin
device and a rewrittable snapshot. Exactly the same problem has been
reported here, in
http://www.redhat.com/archives/dm-devel/2005-August/msg00081.html with
no useful results.

And I could reproduce it with kernel 2.6.13 as well, but not using the
loop driver as backend. Using snapshot-origin or another "linear" mapped
device as cow device does not solve it. To reproduce the problem, do
following:

Install the cloop driver and its utils from
http://ftp.de.debian.org/debian/pool/main/c/cloop/cloop_2.02.1+eb.8.tar.gz ,
unpack, do "make" and "mknod /dev/cloop0 b 240 0".

> # Create filesystem image and cow file
dd if=/dev/zero of=loop_file0 bs=1M count=1 seek=1024
dd if=/dev/zero of=loop_file1 bs=1M count=1 seek=1024

# mount image, copy data, umount image releasing cloop, compressing it for cloop
mke2fs -F loop_file0
mkdir tmp
mount loop_file0 tmp -oloop
cp -a /bin tmp/
umount tmp
create_compressed_fs loop_file0 loop_file0.cloop

# attache the compressed image to the cloop device and setup the
# snapshot
losetup /dev/cloop0 loop_file0.cloop
losetup /dev/loop0 loop_file1
echo "0 `blockdev --getsize /dev/cloop0` snapshot /dev/cloop0 /dev/loop0 p 8" \
    | dmsetup create loop_snap

# Mount the snapshot. Compare data
mount /dev/mapper/loop_snap /mnt/loop_snap
diff -Nr /bin /mnt/loop_snap/bin

You will get different data in almost every file. Though the filesystem
has been mounted without problems, the data returned on random reads
(file access) looks like a salad of randomly permutated blocks.

In addition, a 
# cmp loop_file0 /dev/mapper/cloop_snap
returns no problems for until the read reaches the last blocks of the
device. There cloop begins to print "funny" kernel messages about
decoding errors.

So I must assume there is something wrong with the cloop driver, and
dm-snapshot is the only way to reproduce that. The symptoms look similar
to non-reentrant programs, but I didn't try to inspect the exact
behaviour of dm-snapshot when reading from cloop device yet.

Eduard.
-- 
Bleib ruhig: In hundert Jahren ist alles vorbei.
		-- Ralph Waldo Emerson
