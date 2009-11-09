From: Ron Peterson <rpeterso@mtholyoke.edu>
Subject: Re: unwanted kpartx partition delimiter persistance
Date: Mon, 9 Nov 2009 17:44:30 -0500
Message-ID: <20091109224430.GJ30590@mtholyoke.edu>
References: <20091109211403.GH30590@mtholyoke.edu>
	<20091109214356.GA8671@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091109214356.GA8671@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

2009-11-09_16:43:56-0500 Mike Anderson <andmike@linux.vnet.ibm.com>:
> Ron Peterson <rpeterso@mtholyoke.edu> wrote:

> > While getting our multipath setup going, we edited
> > /etc/udev/rules.d/z60_kpartx.rules to change the partition delimiter to
> > 'quack'.
> > 
> > That's not the name we want in production, of course, so we changed it
> > to 'p'.  The problem is, on every reboot, the /dev/mapper (and
> > /dev/disk/...) names come up with the old delimiter - 'quack'.

> It sounds like there is a copy of the old rules in your initrd. 
> 
> Did you update your initrd post adding "quack" and if so did you run it
> again after removing "quack"? 

Ah.  Yes, I compiled a new kernel.  I don't have time at the moment to
verify this, but that's a very good lead.  Thanks!

-Ron-
