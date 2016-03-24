From: Ming Lei <ming.lei@canonical.com>
Subject: dm: snapshot: I/O error failure in xfstests generic/081
Date: Thu, 24 Mar 2016 20:23:52 +0800
Message-ID: <CACVXFVPA9eLi1rDeyp-aM0VfPuFKPozs4LJhw25Vhd4PEf34Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi,

When I run xfstests generic/081 over virtio-scsi, loop or virtio-blk,
the following snapshot error and IO failure is alwasy observed in
linus v4.5+.

Thanks,

[1], dmesg log
[  374.794520] EXT4-fs (dm-3): mounted filesystem with ordered data
mode. Opts: (null)
[  392.894924] device-mapper: snapshots: Invalidating snapshot: Unable
to allocate exception.
[  392.904760] EXT4-fs warning (device dm-3): ext4_end_bio:314: I/O
error -5 writing to inode 12 (offset 4194304 size 1048576 starting
block 14337)
[  392.905336] EXT4-fs warning (device dm-3): ext4_end_bio:314: I/O
error -5 writing to inode 12 (offset 0 size 2097152 starting block
10241)
[  392.905340] Buffer I/O error on device dm-3, logical block 10241
[  392.905342] Buffer I/O error on device dm-3, logical block 10242
[  392.905343] Buffer I/O error on device dm-3, logical block 10243
[  392.905345] Buffer I/O error on device dm-3, logical block 10244
[  392.905349] Buffer I/O error on device dm-3, logical block 10245
[  392.905351] Buffer I/O error on device dm-3, logical block 10246
[  392.905352] Buffer I/O error on device dm-3, logical block 10247
[  392.905353] Buffer I/O error on device dm-3, logical block 10248
[  392.905355] Buffer I/O error on device dm-3, logical block 10249
[  392.905357] Buffer I/O error on device dm-3, logical block 10250
[  392.906708] EXT4-fs warning (device dm-3): ext4_end_bio:314: I/O
error -5 writing to inode 12 (offset 0 size 2097152 starting block
11265)
[  392.949341] EXT4-fs warning (device dm-3): ext4_end_bio:314: I/O
error -5 writing to inode 12 (offset 2097152 size 2097152 starting
block 12289)
[  392.956143] EXT4-fs warning (device dm-3): ext4_end_bio:314: I/O
error -5 writing to inode 12 (offset 2097152 size 2097152 starting
block 13313)
