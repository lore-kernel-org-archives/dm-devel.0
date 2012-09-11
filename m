From: Muthu Kumar <muthu.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Tue, 11 Sep 2012 13:00:31 -0700
Message-ID: <CAFR8uedk3KpqhJuMn5rVuDbbWz=VOqt=O7ssFqugHTcw=EZsFw@mail.gmail.com>
References: <20120910002810.GA23241@moria.home.lan>
	<20120910172210.GC14103@google.com>
	<20120910202435.GG16360@google.com>
	<20120910204010.GA32310@google.com>
	<20120910213349.GH16360@google.com>
	<20120910213710.GA7677@google.com>
	<20120910215633.GA19739@google.com>
	<CAFR8ued=Le4B4i_Rf4eECXsVgKvce9J7bO9sDSS91PFzBZ6j5w@mail.gmail.com>
	<20120911184553.GT7677@google.com>
	<CAFR8uefj7kxNUHLeppsH8THPzM7XCzT3tOxtuZ0qr4XUe7Bbmw@mail.gmail.com>
	<20120911193124.GI19739@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120911193124.GI19739-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
List-Id: dm-devel.ids

Kent,

On Tue, Sep 11, 2012 at 12:31 PM, Kent Overstreet
<koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Sep 11, 2012 at 11:58:05AM -0700, Muthu Kumar wrote:
>> On Tue, Sep 11, 2012 at 11:45 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > Hello,
>> >
>> > On Tue, Sep 11, 2012 at 11:36:28AM -0700, Muthu Kumar wrote:
>> >> Does this preserve the CPU from which the bio was submitted
>> >> originally. Not familiar with cmwq, may be Tejun can clarify.
>> >>
>> >> Tejun - the question is, do we honor the rq_affinity with the above
>> >> rescue worker implementation?
>> >
>> > The work item would run from the same CPU but there isn't any
>> > mechanism to keep track of the issuing CPU if there are multiple bios
>> > to be rescued.  Isn't rq_affinity an optimization hint?  If so, I
>> > don't think it matters here.
>> >
>>
>> Thanks... Just worried about performance impact.
>>
>> Kent - Anything to validate that the performance is not impacted would
>> be really good. Otherwise, the patch looks great.
>
> Well - there'll only be any performance impact at all when we're memory
> constrained enough that GFP_NOWAIT allocations fail, which for these
> size allocations definitely isn't normal.


Agreed. If we are in this situation, we are already running in
degraded mode. So performance is not in question.

Regards,
Muthu
