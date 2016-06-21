From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Possible data corruption with dm-thin
Date: Tue, 21 Jun 2016 10:59:38 +0200
Message-ID: <54221955-a21e-5152-00e3-d6b78e0c78ef@redhat.com>
References: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAR726JWQ4VKOVR87QX6Tmuhu1JnCymm7coLT=TFn3BseKm8XA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Dne 21.6.2016 v 09:56 Dennis Yang napsal(a):
> Hi,
>
> We have been dealing with a data corruption issue when we run out I/O
> test suite made by ourselves with multiple thin devices built on top of a
> thin-pool. In our test suites, we will create multiple thin devices and
> continually write to them, check the file checksum, and delete all files
> and issue DISCARD to reclaim space if no checksum error takes place.
>
> We found that there is one data access pattern could corrupt the data.
> Suppose that there are two thin devices A and B, and device A receives
> a DISCARD bio to discard a physical(pool) block 100. Device A will quiesce
> all previous I/O and held both virtual and physical data cell before it
> actually remove the corresponding data mapping. After the data mapping
> is removed, both data cell will be released and this DISCARD bio will
> be passed down to underlying devices. If device B tries to allocate
> a new block at the very same moment, it could reuse the block 100 which
> was just been discarded by device A (suppose metadata commit had
> been triggered, for a block cannot be reused in the same transaction).
> In this case, we will have a race between the WRITE bio coming from
> device B and the DISCARD bio coming from device A. Once the WRITE
> bio completes before the DISCARD bio, there would be checksum error
> for device B.
>
> So my question is, does dm-thin have any mechanism to eliminate the race when
> discarded block is reused right away by another device?
>
> Any help would be grateful.
> Thanks,


Please provide version of kernel and surrounding tools (OS release version)?
also are you using  'lvm2'  or you use directly 'dmsetup/ioctl' ?
(in the later case we would need to see exact sequencing of operation).

Also please provide  reproducer script.


Regards

Zdenek
