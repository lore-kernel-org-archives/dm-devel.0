From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept arbitrary offset and len
Date: Mon, 24 Feb 2020 16:53:37 -0500
Message-ID: <x49sgizodni.fsf@segfault.boston.devel.redhat.com>
References: <20200218214841.10076-1-vgoyal@redhat.com>
        <20200218214841.10076-3-vgoyal@redhat.com>
        <x49lfoxj622.fsf@segfault.boston.devel.redhat.com>
        <20200220215707.GC10816@redhat.com>
        <x498skv3i5r.fsf@segfault.boston.devel.redhat.com>
        <20200221201759.GF25974@redhat.com>
        <20200223230330.GE10737@dread.disaster.area>
        <CAPcyv4ghusuMsAq8gSLJKh1fiKjwa8R_-ojVgjsttoPRqBd_Sg@mail.gmail.com>
        <x49blpop00m.fsf@segfault.boston.devel.redhat.com>
        <CAPcyv4gCA_oR8_8+zhAhMnqOga9GcpMX97S+x8_UD6zLEQ0Cew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4gCA_oR8_8+zhAhMnqOga9GcpMX97S+x8_UD6zLEQ0Cew@mail.gmail.com>
        (Dan Williams's message of "Mon, 24 Feb 2020 12:48:35 -0800")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dan Williams <dan.j.williams@intel.com> writes:

>> Let's just focus on reporting errors when we know we have them.
>
> That's the problem in my eyes. If software needs to contend with
> latent error reporting then it should always contend otherwise
> software has multiple error models to wrangle.

The only way for an application to know that the data has been written
successfully would be to issue a read after every write.  That's not a
performance hit most applications are willing to take.  And, of course,
the media can still go bad at a later time, so it only guarantees the
data is accessible immediately after having been written.

What I'm suggesting is that we should not complete a write successfully
if we know that the data will not be retrievable.  I wouldn't call this
adding an extra error model to contend with.  Applications should
already be checking for errors on write.

Does that make sense?  Are we talking past each other?

> Setting that aside we can start with just treating zeroing the same as
> the copy_from_iter() case and fail the I/O at the dax_direct_access()
> step.

OK.

> I'd rather have a separate op that filesystems can use to clear errors
> at block allocation time that can be enforced to have the correct
> alignment.

So would file systems always call that routine instead of zeroing, or
would they first check to see if there are badblocks?

-Jeff
