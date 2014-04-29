From: Vasily Tarasov <tarasov@vasily.name>
Subject: Re: [PATCH RFC 00/10] dm-dedup: device-mapper
 deduplication target
Date: Tue, 29 Apr 2014 09:26:15 -0400
Message-ID: <CAFTzLMNzi8i=+2zhvCimtmWoNt8GymVQgXsxFJ5DzO53JG_e1A@mail.gmail.com>
References: <535ed0d2.0729e00a.4489.0c48@mx.google.com>
	<535F456B.5090600@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <535F456B.5090600@acm.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

Yes, you're right, documentation should be more detailed. Alasdair
also pointed me to the format they use in cache.txt and verity.txt
files. I'll update dedup.txt to comply with that format and include
the information about on-disk structures and behavior in case of a
power failure. Will send an updated documentation patch in some time.

The short answer to your question is that we use device-mapper's
persistent-data library for storing metadata. The library uses COW
B-trees to provide atomicity, consistency, and durability. On REQ_FUA
we commit transactions. The allocation of data blocks on a data device
ensures that no old blocks are overwritten within a transaction. So,
during a write operation, data blocks go straight to the disk, but
they become visible only after the transaction is committed (i.e., if
power fails in the middle of the transaction, one sees the old image
of the device).

I'll explain more details in the documentation patch.

Thanks,
Vasily


On Tue, Apr 29, 2014 at 2:23 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> On 04/29/14 00:03, Vasily Tarasov wrote:
>> See the documentation patch for more details.
>
> Regarding that documentation: shouldn't the on-disk data structures be
> documented ? Shouldn't it be documented how dm-dedup recovers from a
> power failure ? Since different storage devices are used for data and
> meta-data recovery from a power failure is nontrivial. How is it e.g.
> guaranteed if a data block has been made persistent (e.g. via REQ_FUA)
> and the refcount is increased for that data block that neither the data
> nor the metadata for that data block is lost if a power failure occurs ?
>
> Bart.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
