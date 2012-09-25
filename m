From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: bufio & write completion indication
Date: Tue, 25 Sep 2012 19:07:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1209251902510.21075@file.rdu.redhat.com>
References: <CALLzPKbK9Z=W00u9u4gCVp7cSREC3xmpPDD2u53N7593+W4t3g@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CALLzPKbK9Z=W00u9u4gCVp7cSREC3xmpPDD2u53N7593+W4t3g@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids



On Wed, 26 Sep 2012, Kasatkin, Dmitry wrote:

> Hi,
> 
> I have a question.
> 
> How dm target can be sure that data really have been written to storage?
> 
> - for remaped request
> bio_end really indicates that?
> or data can be stuck in block buffers?

No. When bio_endio is called, data may still be in hardware cache in the 
disk and not yet written to the disk. After you receive bio_endio for a 
write bio, you must submit another bio with REQ_FLUSH flag to flush the 
hardware cache (or you can use blkdev_issue_flush to send it).

> - for bufio requests
> dm_bufio_write_dirty_buffers() provides that ?

Yes. dm_bufio_write_dirty_buffers calls dm_bufio_issue_flush and 
dm_bufio_issue_flush flushes the hardware cache.

Mikulas

> 
> Thanks,
> Dmitry
> 
