From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
 vg/lv - xfs
Date: Wed, 4 Aug 2010 08:56:31 -0400
Message-ID: <20100804125631.GC17263@redhat.com>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
 <20100804085039.GA11671@infradead.org>
 <20100804091317.GA27779@isilmar-3.linta.de>
 <20100804092122.GA2998@infradead.org>
 <20100804073546.GA7494@comet.dominikbrodowski.net>
 <201008041116.09822@zmi.at>
 <20100804102526.GB13766@isilmar-3.linta.de>
 <20100804111803.GA32643@infradead.org>
 <alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1008041351100.19930@uplift.swm.pp.se>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Michael Monnerie <michael.monnerie@is.it-management.at>, linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Aug 04 2010 at  7:53am -0400,
Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> On Wed, 4 Aug 2010, Christoph Hellwig wrote:
> 
> >The good news is that you have it tracked down, the bad news is
> >that I know very little about dm-crypt.  Maybe the issue is the
> >single threaded decryption in dm-crypt?  Can you check how much
> >CPU time the dm crypt kernel thread uses?
> 
> I'm not sure it's that. I have a Core i5 with AES-NI and that didn't
> significantly increase my overall performance, as it's not there the
> bottleneck is (at least in my system).

You could try applying both of these patches that are pending review for
hopeful inclussion in 2.6.36:

https://patchwork.kernel.org/patch/103404/
https://patchwork.kernel.org/patch/112657/
