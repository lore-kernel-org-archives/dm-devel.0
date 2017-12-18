From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 1/2] dm-unstripe: unstripe RAID 0/dm-striped device
Date: Mon, 18 Dec 2017 14:37:47 -0500
Message-ID: <20171218193746.GB6149@redhat.com>
References: <20171218172809.5826-1-scott.bauer@intel.com>
 <20171218172809.5826-2-scott.bauer@intel.com>
 <e39cb433-d54b-50a6-70c3-1315e4ffbf0b@infradead.org>
 <20171218185235.fcxbqb77fv733h5v@sbauer-Z170X-UD5>
 <20171218193249.GA6149@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171218193249.GA6149@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Bauer <scott.bauer@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, keith.busch@intel.com, dm-devel@redhat.com, agk@redhat.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On Mon, Dec 18 2017 at  2:32pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Dec 18 2017 at  1:52pm -0500,
> Scott Bauer <scott.bauer@intel.com> wrote:
> 
> > 
> > > > +config DM_UN_STRIPE
> > > > +       tristate "Transpose IO to individual drives on a raid device"
> > > > +       depends on BLK_DEV_DM
> > > > +       ---help---
> > > > +	  Enable this feature if you with to unstripe I/O on a RAID 0
> > > > +	  device to the respective drive. If your hardware has physical
> > > > +	  RAID 0 this module can unstripe the I/O to respective sides.
> > > 
> > > What does "sides" mean above?
> > 
> > Should say, "members". There's also an alternative patch set out by Heinz
> > that I am currently testing/writing comments for. It looks like we'll use
> > his version after I submit my comments (IE take the stuff I put in my v4
> > to fix your comments).
> 
> Can you be more specific?  I've not seen anything from Heinz.
> 
> I've been reviewing your v4 and modified it to match dm-stripe.c more
> (like Alasdair asked for).

When the right hand isn't aware the left is doing something ;)

I'll combine my effort with Heinz's.

Please don't send another revision until you see what I've come up with.

Thanks,
Mike
