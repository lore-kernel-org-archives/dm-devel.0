From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v2 2/2] dm unstripe: Add documentation for unstripe target
Date: Tue, 12 Dec 2017 07:45:56 -0700
Message-ID: <20171212144556.GF11218@localhost.localdomain>
References: <20171211160019.20518-1-scott.bauer@intel.com>
 <20171211160019.20518-3-scott.bauer@intel.com>
 <00fdc58c-d8e9-6b42-727d-ab70d5ce1b0a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <00fdc58c-d8e9-6b42-727d-ab70d5ce1b0a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: Scott Bauer <scott.bauer@intel.com>, dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On Tue, Dec 12, 2017 at 01:35:13PM +0200, Nikolay Borisov wrote:
> On 11.12.2017 18:00, Scott Bauer wrote:
> > +    As an example:
> > +
> > +    Intel NVMe drives contain two cores on the physical device.
> > +    Each core of the drive has segregated access to its LBA range.
> > +    The current LBA model has a RAID 0 128k stripe across the two cores:
> > +
> > +       Core 0:                Core 1:
> > +      __________            __________
> > +      | LBA 511|            | LBA 768|
> > +      | LBA 0  |            | LBA 256|
> > +      ⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻            ⎻⎻⎻⎻⎻⎻⎻⎻⎻⎻
> 
> If it's 128k stripe shouldn't it be LBAs 0/256 on core0 and LBAs 128/511
> on core1?

Ah, this device's makers call the "stripe" size what should be called
"chunk". This device has a 128k chunk per core with two cores, so the
full stripe is 256k. The above should have core 0 owning LBA 512 rather
than 511 (assuming 512b LBA format).
