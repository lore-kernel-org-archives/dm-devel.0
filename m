From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RFC 00/10] dm-dedup: device-mapper
 deduplication target
Date: Tue, 29 Apr 2014 08:23:39 +0200
Message-ID: <535F456B.5090600@acm.org>
References: <535ed0d2.0729e00a.4489.0c48@mx.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <535ed0d2.0729e00a.4489.0c48@mx.google.com>
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

On 04/29/14 00:03, Vasily Tarasov wrote:
> See the documentation patch for more details.

Regarding that documentation: shouldn't the on-disk data structures be
documented ? Shouldn't it be documented how dm-dedup recovers from a
power failure ? Since different storage devices are used for data and
meta-data recovery from a power failure is nontrivial. How is it e.g.
guaranteed if a data block has been made persistent (e.g. via REQ_FUA)
and the refcount is increased for that data block that neither the data
nor the metadata for that data block is lost if a power failure occurs ?

Bart.
