From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [dm-devel] clone() with CLONE_NEWNET breaks kobject_uevent_env()
Date: Fri, 19 Aug 2011 02:13:48 -0700
Message-ID: <m17h69sr03.fsf@fess.ebiederm.org>
References: <4E4CDF44.5080109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E4CDF44.5080109@redhat.com> (Milan Broz's message of "Thu, 18
	Aug 2011 11:45:40 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>, "David S. Miller" <davem@davemloft.net>
List-Id: dm-devel.ids

Milan Broz <mbroz@redhat.com> writes:

> Hi,
>
> after analysing very strange report (with running chromium
> some device-mapper ioctl functions started to fail) I found
> interesting problem:
>
> If you run clone() with CLONE_NEWNET (which is chromium using
> for sanboxing), udev namespace is cloned too (newly registered
> in uevent_sock_list) and netlink send (except the first in list)
> fails with -ESRCH.
>
> This causes that _every_ call of kobject_uevent_env() return failure.
>
> Most of users silently ignores  kobject_uevent() return value,
> so the problem was invisible for long time.
>
> Unfortunately dm checks return value and reports failure,
> taking the wrong error path.
>
> How is this supposed to work?
>
> Why cloning net namespace breaks the udev netlink subsystem?

The netlink subsystem is not broken.  The netlink subsystem
just happens to be reporting in a very obnoxious manner
that there were no listening sockets in one of the network
namespaces.

> Is it bug or we need to do something differently?
> (I do not think ignoring return value is the proper way...)

From my quick look at this problem this looks like a doozy.

That netlink_ broadcast chooses to treat failure to deliver a packet to
anyone as an error and return -ESRCH is a little peculiar.  In general
we don't see that error because when you are testing there is at least
one listener on the netlink socket.  So as a practical matter I think
we should be ignoring return values of -ESRCH from netlink_broadcast,
in kobject_uevent_env.

What puzzles me is why kobject_uevent_env bothers with a return code.
As far as I understand the semantics kobject_uevent_env attempts to
send an event and there really isn't anything anyone can do if the
attempt to send the event fails.

I can see complaining if kobject_uevent_env is given invalid input
but that seems better as a WARN_ON so you get a backtrace and someone
can change their code.

I don't think kobject_uevent_env has any cases where it can return
an error that is useful for anything.  What can caller do with
an error code of -ENOMEM? 

I think the proper fix is to remove the error return from
kobject_uevent_env and kobject_uevent, and make it harder to get calling
of this function wrong.  Possibly in conjunction with that tag all of
the memory allocations of kobject_uevent_env with GFP_NOFAIL or
something so the memory allocator knows that this path is totally
not able to deal with failure.

Is kobject_uevent_env anything except an asynchronous best effort
notification to user-space that a device has come or gone?

Eric
