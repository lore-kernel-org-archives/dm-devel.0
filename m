From: Brian McCullough <bdmc@bdmcc-us.com>
Subject: Re: storage-logger: Recording changes to the udev
 database
Date: Fri, 27 Mar 2020 15:50:06 -0400
Message-ID: <20200327195006.GE6382@bdmcc-us.com>
References: <20200326233144.GM17504@agk-dp.fab.redhat.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <20200326233144.GM17504@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
Content-Disposition: inline
To: dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 26, 2020 at 11:31:45PM +0000, Alasdair G Kergon wrote:
> I'm experimenting with ways of recording changes to the udev database so
> you can look back at the history of the storage stack on a particular
> machine.  This is still a work-in-progress, but it's reached a point
> where I'd like more people to try it out.
> 
> I've written a shell script that records data related to storage uevents
> in the system journal and a perl script that helps you to interrogate
> this data later to create a representation of the storage components.
> 
> If you're interested, please try this out and let me know if you think
> pursing this approach further would lead to something that you would
> use and distributions should ship.

Quick note, Alasdair.

In your instructions, you say to put the "working" script in /usr/sbin,
while in the udev rule, it is in /sbin/



I tried adding and removing a USB-connected drive, but did not see any
response in the journal.  Should I have seen something, or are those not
seen?



Thanks,
Brian



_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
