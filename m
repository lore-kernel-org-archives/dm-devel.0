From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: unwanted kpartx partition delimiter persistance
Date: Mon, 9 Nov 2009 13:43:56 -0800
Message-ID: <20091109214356.GA8671@linux.vnet.ibm.com>
References: <20091109211403.GH30590@mtholyoke.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091109211403.GH30590@mtholyoke.edu>
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

Ron Peterson <rpeterso@mtholyoke.edu> wrote:
> Hi,
> 
> I have a strange problem w/ a new server.  Debian Lenny, kernel 2.6.27.26.
> 
> While getting our multipath setup going, we edited
> /etc/udev/rules.d/z60_kpartx.rules to change the partition delimiter to
> 'quack'.
> 
> That's not the name we want in production, of course, so we changed it
> to 'p'.  The problem is, on every reboot, the /dev/mapper (and
> /dev/disk/...) names come up with the old delimiter - 'quack'.
> 
> If I run 'multipath -F', and 'multipath -v2', then the device names are
> created as we'd expect them to.
> 
> We have grep'd for the string 'quack' everywhere it we can think of, and
> it's nowhere to be found.  There is one kpartx config file in
> /etc/udev/rules.d only.  What could cause the old name to persist like
> this?
> 

I do not have this distro available so my information may not be that
useful. but..

It sounds like there is a copy of the old rules in your initrd. 

Did you update your initrd post adding "quack" and if so did you run it
again after removing "quack"? 

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
