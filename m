From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Tue, 14 Jun 2016 16:19:19 -0400
Message-ID: <x49inxbzfp4.fsf@segfault.boston.devel.redhat.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
	<CAPcyv4jdM1phR=kGoP2-7tfsVvbNe2C6hHNS5TD28ALGZQQTSw@mail.gmail.com>
	<1465861755.3504.185.camel@hpe.com>
	<x49fusf282h.fsf@segfault.boston.devel.redhat.com>
	<20160614154131.GB25876@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160614154131.GB25876@redhat.com> (Mike Snitzer's message of
	"Tue, 14 Jun 2016 11:41:31 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Kani, Toshimitsu" <toshi.kani@hpe.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "agk@redhat.com" <agk@redhat.com>
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:

> On Tue, Jun 14 2016 at  9:50am -0400,
> Jeff Moyer <jmoyer@redhat.com> wrote:
>
>> "Kani, Toshimitsu" <toshi.kani@hpe.com> writes:
>>=20
>> >> I had dm-linear and md-raid0 support on my list of things to look=
 at,
>> >> did you have raid0 in your plans?
>> >
>> > Yes, I hope to extend further and raid0 is a good candidate. =C2=A0=
=C2=A0
>>=20
>> dm-flakey would allow more xfstests test cases to run.  I'd say that=
's
>> more important than linear or raid0.  ;-)
>
> Regardless of which target(s) grow DAX support the most pressing init=
ial
> concern is getting the DM device stacking correct.  And verifying tha=
t
> IO that cross pmem device boundaries are being properly split by DM
> core (via drivers/md/dm.c:__split_and_process_non_flush()'s call to
> max_io_len).

That was a tongue-in-cheek comment.  You're reading way too much into
it.

>> Also, the next step in this work is to then decide how to determine =
on
>> what numa node an LBA resides.  We had discussed this at a prior
>> plumbers conference, and I think the consensus was to use xattrs.
>> Toshi, do you also plan to do that work?
>
> How does the associated NUMA node relate to this?  Does the
> DM requests_queue need to be setup to only allocate from the NUMA nod=
e
> the pmem device is attached to?  I recently added support for this to
> DM.  But there will likely be some code need to propagate the NUMA no=
de
> id accordingly.

I assume you mean allocate memory (the volatile kind).  That should wor=
k
the same between pmem and regular block devices, no?

What I was getting at was that applications may want to know on which
node their data resides.  Right now, it's easy to tell because a single
device cannot span numa nodes, or, if it does, it does so via an
interleave, so numa information isn't interesting.  However, once data
on a single file system can be placed on multiple different numa nodes,
applications may want to query and/or control that placement.

Here's a snippet from a blog post I never finished:

There are two essential questions that need to be answered regarding
persistent memory and NUMA: first, would an application benefit from
being able to query the NUMA locality of its data, and second, would
an application benefit from being able to specify a placement policy
for its data?  This article is an attempt to summarize the current
state of hardware and software in order to consider the above two
questions.  We begin with a short list of use cases for these
interfaces, which will frame the discussion.

=46irst, let's consider an interface that allows an application to quer=
y
the NUMA placement of existing data.  With such information, an
application may want to perform the following actions:

- relocate application processes to the same NUMA node as their data.
  (Interfaces for moving a process are readily available.)
- specify a memory (RAM) allocation policy so that memory allocations
  come from the same NUMA node as the data.

Second, we consider an interface that allows an application to specify
a placement policy for new data.  Using this interface, an application
may:

- ensure data is stored on the same NUMA node as the one on which the
  application is running
- ensure data is stored on the same NUMA node as an I/O adapter such
  as a network card, that is a producer of data stored to NVM.
- ensure data is stored on a different NUMA node:
  - so that the data is stored on the same NUMA node as related data
  - because the data does not need the faster access afforded by local
    NUMA placement.  Presumably this is a trade-off, and other data
    will require local placement to meet the performance goals of the
    application.

Cheers,
Jeff
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
