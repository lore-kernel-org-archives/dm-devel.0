From: Ed Cashin <ecashin@coraid.com>
Subject: Re: Sending reads/writes to a userspace program?
Date: Fri, 21 Nov 2008 10:10:06 -0500
Message-ID: <874p215d4h.fsf@coraid.com>
References: <a01fc5d10705160353o582e074ep428d76d2a55ff39b@mail.gmail.com>
	<m3fy5xyori.fsf@guaranine.beaverton.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Dan Smith <danms@us.ibm.com> writes:

> NJ> Does dm provide any way for a custom target type to redirect a read or
> NJ> write to a userspace program? Or even for it to notify the program of
> NJ> the read/write and wait until it gives the goahead, somewhat like the
> NJ> way page faulting works? 
>
> I have been working on a userspace target, which allows you to do just
> what you describe.  I have an hg tree up with some userspace tools, as
> well as an out-of-body version of the kernel module:
>
>   http://static.danplanet.com/hg/dm-userspace.ring/
>
> I also have an actual kernel tree with dm-userspace support, from
> which I could generate a patch if the above does not work well for
> you.
>
> NJ> I'm wondering if it's possible to create a target type that
> NJ> implements a 'remote' block device with blocks stored on something
> NJ> like Amazon S3, keeping only a local cache of mapped blocks, and
> NJ> fetching / writing blocks as needed.
>
> Yep, I have done similar things with dm-userspace.

The dm-userspace target is very interesting to me because it would
allow me to use block devices that were based on arbitrary and
experimental aggregations of local and remote storage coordinated by a
simple userland program.

I see in the archives that there were some attempts to get
dm-userspace into the mainline kernel by way of the development device
mapper code, but I don't think there have been recent attempts to
get dm-userspace merged.

Is there a problem with dm-userspace that is keeping it out of the
mainline?  If not, can it be resubmitted?

-- 
  Ed Cashin <ecashin@coraid.com>
