From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH v3] staging: writeboost: Add dm-writeboost
Date: Sat, 21 Feb 2015 10:36:53 +0900
Message-ID: <54E7E135.3060507@gmail.com>
References: <54A508F7.1020207@gmail.com> <20150118000952.GB26160@kroah.com>
 <20150220174401.4badb3cbad7be3eed449f4c1@gmail.com>
 <20150220150614.GA4740@debian> <54E75201.9030202@gmail.com>
 <20150220155036.GB4740@debian> <54E75B70.1010007@gmail.com>
 <20150220161759.GC4740@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20150220161759.GC4740@debian>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: ejt@redhat.com
Cc: Greg KH <gregkh@linuxfoundation.org>, dm-devel@redhat.com, driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, snitzer@redhat.com
List-Id: dm-devel.ids

To be clear, bio's semantics doesn't require a io is written on
persistent medium before any ack. The border line is that ios that's acked
are persitent before ack to REQ_FLUSH request.
So, writing on the volatile buffer (log chunk in this case) and then ack
is safe if the data gets persistent before some future REQ_FLUSH
request is acked. That's dm-writeboost does.
And in general, ack should be quick as possible otherwise may incur
some problems such as upper layer may suspend any other requests.

The bio_vecs solution works only for a tiny prototype.
If I apply the solution there will appear the following problems

1. The write to the cache device isn't one single write.
    This causes atomicity problem. And may cause performance
    degradation.
2. We need to compute checksum of the entire log chunk before write.
    Without this, the user isn't safe from partial write problem.
    Like the 1 above, atomicity is to be cared.
    (btw, I don't think dm-cache that has separete data device and
     metadata device can guarantee this level of safetiness)
3. Don't ack any bios until the full buffer is written is harmful.
    We should ack as quick as possible as explained above.
4. Read caching becomes infeasible. It needs copying of the read data.

My conclusion is write buffer in practice should be a single buffer and
copying is inevitable.

From a engineering point of view, memory copy can't be the bottleneck
(before that, SSD's throughput hits) so we shouldn't hack for the little
improvement.

- Akira

On 2015/02/21 1:17, Joe Thornber wrote:
> On Sat, Feb 21, 2015 at 01:06:08AM +0900, Akira Hayakawa wrote:
>> The size is configurable but typically 512KB (that's the default).
>>
>> Refer to bio payload sounds really dangerous but it may be possible
>> in some tricky way. but at the moment I am not sure how the
>> implementation would be.
>>
>> Is there some fancy function that is like memcpy but actually "move"
>> the ownership?
> When building up your log chunk bio copy the bio_vecs (not the data)
> from the original bios.  You can't complete the original bios until
> your log chunk has been written.
>
> - Joe
