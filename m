From: Thanos Makatos <thanos.makatos@onapp.com>
Subject: Re: dm-cache: blocks don't get cached on
	3.18.21-17.el6.x86_64
Date: Mon, 14 Mar 2016 12:56:31 +0000
Message-ID: <CAM2wQBvDbBrtAEUax5ULKjBzQDjcJ4Wi6k5Ht+QTq-WbMLoewA@mail.gmail.com>
References: <CAM2wQBvqXoKz7kyHqsqg6VbXz_8M-QbhiS-RNYDk8eu+1dAKtg@mail.gmail.com>
	<20160314124436.GB10657@rh-vpn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160314124436.GB10657@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Thanos Makatos <thanos.makatos@onapp.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 14 March 2016 at 12:44, Joe Thornber <thornber@redhat.com> wrote:
> On Mon, Mar 14, 2016 at 09:54:06AM +0000, Thanos Makatos wrote:
>> (I've already reported this issue to centos and centos-devel. and
>> waited long enough but didn't get any reply.)
>>
>> I'm evaluating dm-cache on CentOS 6 kernels  3.18.21-17.el6.x86_64 (Xen 4) and
>> 2.6.32-573.7.1.el6.x86_64 (KVM). The test I do is a simple sequential
>> read using dd(1). read_promote_adjustment and sequential_threshold
>> have been set to 1 and 0, respectively. For the 2.6.32 kernel, all
>> seems to be working fine, "#usedcacheblocks" correctly reflects the
>> number of cached blocks based on what I'm reading with dd(1),
>> performance is pretty much native SSD performance. However, the same
>> test on the 3.18.21-17.el6.x86_64 kernel results in "#usedcacheblocks"
>> being stuck to "2" and no performance improvement is observed.
>>
>> Any ideas what could be wrong? How can I further debug this?
>
> There may not be anything wrong, dm-cache is very cagey these days
> about promoting blocks to the ssd without evidence that they're
> hotspots.  Hitting blocks once with a dd is not enough.

I've been hitting the same block many many times, still it doesn't get
promoted. Is there a foolproof way that results in blocks getting
cached?
