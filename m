From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH v4 1/2] dm-unstripe: unstripe RAID 0/dm-striped device
Date: Mon, 18 Dec 2017 11:52:36 -0700
Message-ID: <20171218185235.fcxbqb77fv733h5v@sbauer-Z170X-UD5>
References: <20171218172809.5826-1-scott.bauer@intel.com>
 <20171218172809.5826-2-scott.bauer@intel.com>
 <e39cb433-d54b-50a6-70c3-1315e4ffbf0b@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e39cb433-d54b-50a6-70c3-1315e4ffbf0b@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com
List-Id: dm-devel.ids


> > +config DM_UN_STRIPE
> > +       tristate "Transpose IO to individual drives on a raid device"
> > +       depends on BLK_DEV_DM
> > +       ---help---
> > +	  Enable this feature if you with to unstripe I/O on a RAID 0
> > +	  device to the respective drive. If your hardware has physical
> > +	  RAID 0 this module can unstripe the I/O to respective sides.
> 
> What does "sides" mean above?

Should say, "members". There's also an alternative patch set out by Heinz
that I am currently testing/writing comments for. It looks like we'll use
his version after I submit my comments (IE take the stuff I put in my v4
to fix your comments).
