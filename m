From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: dm-writecache
Date: Fri, 18 May 2018 15:10:04 -0700
Message-ID: <CAPcyv4iO-6QHSb58O3TVUgiZvQ5BBAq=_=yP1kW5oTHkjS3b3Q@mail.gmail.com>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
 <CAPcyv4gBUt5NYK2Lx0dMZAnENeSgKm3KaUvY9kkqB+PNPyQu4w@mail.gmail.com>
 <20180518154454.GA4902@redhat.com>
 <CAPcyv4hAZVTE7T7q7YRN6QvxfVR64c3jBpCTu-rCvNAB1-OWSA@mail.gmail.com>
 <alpine.LRH.2.02.1805181514420.28860@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jecVBaJb5WeO3FdbJ8xabishbAccORoXN2pHKOvUc2qA@mail.gmail.com>
 <alpine.LRH.2.02.1805181755410.27649@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <alpine.LRH.2.02.1805181755410.27649-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Alasdair G. Kergon" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: dm-devel.ids

On Fri, May 18, 2018 at 3:00 PM, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>
> On Fri, 18 May 2018, Dan Williams wrote:
>
>> >> ...and I wonder what the benefit is of the 16-byte case? I would
>> >> assume the bulk of the benefit is limited to the 4 and 8 byte copy
>> >> cases.
>> >
>> > dm-writecache uses 16-byte writes frequently, so it is needed for that.
>> >
>> > If we split 16-byte write to two 8-byte writes, it would degrade
>> > performance for architectures where memcpy_flushcache needs to flush the
>> > cache.
>>
>> My question was how measurable it is to special case 16-byte
>> transfers? I know Ingo is going to ask this question, so it would
>> speed things along if this patch included performance benefit numbers
>> for each special case in the changelog.
>
> I tested it some times ago - and the movnti instruction has 2% better
> throughput than the existing memcpy_flushcache function.
>
> It is doing one 16-byte write for every sector written and one 8-byte
> write for every sector clean-up. So, the overhead is measurable.

Awesome, include those measured numbers in the changelog for the next
spin of the patch.
