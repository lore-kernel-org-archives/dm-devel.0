From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Possible data corruption with dm-thin
Date: Tue, 21 Jun 2016 12:46:59 +0200
Message-ID: <5cfb25da-40ce-ffab-d56b-8e1338d90340@redhat.com>
References: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
	<54221955-a21e-5152-00e3-d6b78e0c78ef@redhat.com>
	<CAAR726KwSx0VU3E4UxhSgtfYyOeYJLdsxJrut10UJcfoOQ7hfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAR726KwSx0VU3E4UxhSgtfYyOeYJLdsxJrut10UJcfoOQ7hfw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dennis Yang <dennisyang@qnap.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dne 21.6.2016 v 12:40 Dennis Yang napsal(a):
>
>
> 2016-06-21 16:59 GMT+08:00 Zdenek Kabelac <zkabelac@redhat.com
> <mailto:zkabelac@redhat.com>>:
>
>     Dne 21.6.2016 v 09:56 Dennis Yang napsal(a):
>
>         Hi,
>
>         We have been dealing with a data corruption issue when we run out I/O
>         test suite made by ourselves with multiple thin devices built on top of a
>         thin-pool. In our test suites, we will create multiple thin devices and
>         continually write to them, check the file checksum, and delete all files
>         and issue DISCARD to reclaim space if no checksum error takes place.
>
>         We found that there is one data access pattern could corrupt the data.
>         Suppose that there are two thin devices A and B, and device A receives
>         a DISCARD bio to discard a physical(pool) block 100. Device A will quiesce
>         all previous I/O and held both virtual and physical data cell before it
>         actually remove the corresponding data mapping. After the data mapping
>         is removed, both data cell will be released and this DISCARD bio will
>         be passed down to underlying devices. If device B tries to allocate
>         a new block at the very same moment, it could reuse the block 100 which
>         was just been discarded by device A (suppose metadata commit had
>         been triggered, for a block cannot be reused in the same transaction).
>         In this case, we will have a race between the WRITE bio coming from
>         device B and the DISCARD bio coming from device A. Once the WRITE
>         bio completes before the DISCARD bio, there would be checksum error
>         for device B.
>
>         So my question is, does dm-thin have any mechanism to eliminate the
>         race when
>         discarded block is reused right away by another device?
>
>         Any help would be grateful.
>         Thanks,
>
>
>
>     Please provide version of kernel and surrounding tools (OS release version)?
>     also are you using  'lvm2'  or you use directly 'dmsetup/ioctl' ?
>     (in the later case we would need to see exact sequencing of operation).
>
>     Also please provide  reproducer script.
>
>
>     Regards
>
>     Zdenek
>
>     --
>     dm-devel mailing list
>     dm-devel@redhat.com <mailto:dm-devel@redhat.com>
>     https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>
> Hi Zdenek,
>
> We are using a customized dm-thin driver based on linux 3.19.8 running
> on our QNAP NAS. Also, we create all our thin devices with "lvm2". I am

Please try to reproduce with recent kernel 4.6.

Regards

Zdenek

> afraid that I cannot provide the reproducer script since we reproduce this by
> running the I/O stress test suite on Windows to all thin devices exported to
> them via samba and iSCSI.
>
> The following is the trace of thin-pool we dumped via blktrace. The data
> corruption takes place from sector address 310150144 to 310150144 + 832.
>
> 252,19   1   154916   184.875465510 29959  Q   W 310150144 + 1024 [kworker/u8:0]
> 252,19   0   205964   185.496309521     0      C   W 310150144 + 1024 [0]
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> At first, pool receives a 1024 sector WRITE bio which had allocated a pool block.
>
> 252,19   3   353811   656.542481344 30280  Q   D 310150144 + 1024 [kworker/u8:8]
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Pool receives a 1024 sector (thin block size) DISCARD bio passed down by one
> of the thin device.
>
> 252,19   1   495204   656.558652936 30280  Q   W 310150144 + 832 [kworker/u8:8]
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Another thin device passed down a 832 sector WRITE bio to the exact same place.
>
> 252,19   3   353820   656.564140283     0      C   W 310150144 + 832 [0]
> 252,19   0   697455   656.770883592     0      C   D 310150144 + 1024 [0]
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Although the DISCARD bio was queued before the WRITE bio, their completion had
> been reordered which could corrupt the data.
>
> 252,19   1   515212   684.425478220 20751  A   R 310150144 + 80 <- (252,22)
> 28932096
> 252,19   1   515213   684.425478325 20751  Q   R 310150144 + 80 [smbd]
> 252,19   0   725274   684.425741079 23937  C   R 310150144 + 80 [0]
>
> Hope this helps.
> Thanks,
>
> Dennis
>
> --
> Dennis Yang
> QNAP Systems, Inc.
> Skype: qnap.dennis.yang
> Email: dennisyang@qnap.com <mailto:dennisyang@qnap.com>
> Tel: (+886)-2-2393-5152 ext. 15018
> Address: 13F., No.56, Sec. 1, Xinsheng S. Rd., Zhongzheng Dist., Taipei City,
> Taiwan
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
