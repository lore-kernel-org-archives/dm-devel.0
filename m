From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept
 arbitrary offset and len
Date: Fri, 28 Feb 2020 06:05:08 -0800
Message-ID: <20200228140508.GA2987@infradead.org>
References: <x49lfoxj622.fsf@segfault.boston.devel.redhat.com>
 <20200220215707.GC10816@redhat.com>
 <x498skv3i5r.fsf@segfault.boston.devel.redhat.com>
 <20200221201759.GF25974@redhat.com>
 <20200223230330.GE10737@dread.disaster.area>
 <20200224153844.GB14651@redhat.com>
 <20200227030248.GG10737@dread.disaster.area>
 <CAPcyv4gTSb-xZ2k938HxQeAXATvGg1aSkEGPfrzeQAz9idkgzQ@mail.gmail.com>
 <20200228013054.GO10737@dread.disaster.area>
 <CAPcyv4i2vjUGrwaRsjp1-L0wFf0a00e46F-SUbocQBkiQ3M1kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4i2vjUGrwaRsjp1-L0wFf0a00e46F-SUbocQBkiQ3M1kg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 27, 2020 at 07:28:41PM -0800, Dan Williams wrote:
> "don't perform generic memory-error-handling, there's an fs that owns
> this daxdev and wants to disposition errors". The fs/dax.c
> infrastructure that sets up ->index and ->mapping would still need to
> be there for ext4 until its ready to take on the same responsibility.
> Last I checked the ext4 reverse mapping implementation was not as
> capable as XFS. This goes back to why the initial design avoided
> relying on not universally available / stable reverse-mapping
> facilities and opted for extending the generic mm/memory-failure.c
> implementation.

The important but is that we stop using ->index and ->mapping when XFS
is used as that enables using DAX+reflinks, which actually is the most
requested DAX feature on XFS (way more than silly runtime flag switches
for example).
