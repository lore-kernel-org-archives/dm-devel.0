From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH v3 2/2] dm unstripe: Add documentation for unstripe target
Date: Wed, 13 Dec 2017 16:58:30 -0700
Message-ID: <20171213235829.tr62tyc3u2v77yp6@sbauer-Z170X-UD5>
References: <20171213213332.2914-1-scott.bauer@intel.com>
 <20171213213332.2914-3-scott.bauer@intel.com>
 <808cd141-3c0a-d0ae-5b9d-efc19ab9f0fb@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <808cd141-3c0a-d0ae-5b9d-efc19ab9f0fb@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On Wed, Dec 13, 2017 at 04:18:06PM -0800, Randy Dunlap wrote:
> Use ASCII characters ___ or ---,  not whatever those bottom block characters are.

Argh, sorry, I removed those for an internal review but forgot to remove them here.

> 
> > +
> > +    The purpose of this unstriping is to provide better QoS in noisy
> > +    neighbor environments. When two partitions are created on the
> > +    aggregate drive without this unstriping, reads on one partition
> > +    can affect writes on another partition. This is because the partitions
> > +    are striped across the two cores. When we unstripe this hardware RAID 0
> > +    and make partitions on each new exposed device the two partitions are now
> > +    physically separated.
> > +
> > +    With the module we were able to segregate a fio script that has read and
> > +    write jobs that are independent of each other. Compared to when we run
> > +    the test on a combined drive with partitions, we were able to get a 92%
> > +    reduction in five-9ths read latency using this device mapper target.
> 
> 	            5/9ths
> although I can't quite parse that sentence.

I'll reword it, thanks.
