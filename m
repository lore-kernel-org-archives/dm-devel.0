From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [linux-lvm] storage-logger: Recording changes to the
	udev	database
Date: Fri, 27 Mar 2020 20:53:29 +0000
Message-ID: <20200327205329.GA29554@agk-dp.fab.redhat.com>
References: <20200326233144.GM17504@agk-dp.fab.redhat.com>
	<20200327195006.GE6382@bdmcc-us.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200327195006.GE6382@bdmcc-us.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Brian McCullough <bdmc@bdmcc-us.com>
Cc: dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 27, 2020 at 03:50:06PM -0400, Brian McCullough wrote:
> In your instructions, you say to put the "working" script in /usr/sbin,
> while in the udev rule, it is in /sbin/

In Fedora they are the same.

> I tried adding and removing a USB-connected drive, but did not see any
> response in the journal.  Should I have seen something, or are those not
> seen?

You should test the script in isolation in case there are any other 
differences on Debian.  Change the top line to '...bash -x' so you
can watch it, set some environment variables (like ACTION=add) and 
run it directly.

Alasdair
