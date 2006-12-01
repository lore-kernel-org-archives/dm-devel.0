From: "Ming Zhao" <mingzhao99th@gmail.com>
Subject: Re: [RFC][PATCH] dm-cache: block level disk cache target
	for device mapper
Date: Fri, 1 Dec 2006 02:16:15 -0500
Message-ID: <b1e142760611302316w5917bc67q5a9f26e1d069f716@mail.gmail.com>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
	<200611301232.57966.jens.wilke@de.ibm.com>
	<a4e6962a0611300824qdfa43cbja783da86fe6eb5cf@mail.gmail.com>
	<200611302107.40418.jens.wilke@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200611302107.40418.jens.wilke@de.ibm.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 11/30/06, Jens Wilke <jens.wilke@de.ibm.com> wrote:
> - You don't keep track of I/O on the fly to the cache that is mapped
> directly in cache_hit(). How do you make sure that this I/O is completed
> before you replace a cache block?

The previous I/O from cache hit and the later I/O for cache
replacement should be queued in order on the cache block device - is
this a safe assumption?

> - The cache block index is hashed, this means the cache data blocks are not
> clustered. I don't think you can solve this problem with a proper hash function.
> Perhaps you should consider a (B-)Tree structure for that.

The current hash algorithm does clustering to some extent by mapping
consecutive blocks from the source device to consecutive blocks on the
cache device. But I agree that more sophisticated algorithms can be
studied.

Thanks a lot for the suggestions. I will try to incorporate them in
the next patch.

- Ming
