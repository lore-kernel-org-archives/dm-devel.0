From: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: Too many I/O controller patches
Date: Tue, 05 Aug 2008 09:20:18 -0700
Message-ID: <1217953218.10907.25.camel@nimitz>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com>
	 <000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>  <48981D3B.2020701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761421AbYHEQUk@vger.kernel.org>
In-Reply-To: <48981D3B.2020701@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: righi.andrea@gmail.com
Cc: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, vtaras@openvz.org, dm-devel@redhat.com, agk@sourceware.org, virtualization@lists.linux-foundation.org, ngupta@google.com
List-Id: dm-devel.ids

On Tue, 2008-08-05 at 11:28 +0200, Andrea Righi wrote:
> > Buffered write I/O is also related with cache system.
> > We must consider this problem as I/O control.
>=20
> Agree. At least, maybe we should consider if an IO controller could b=
e
> a valid solution also for these problems.

Isn't this one of the core points that we keep going back and forth
over?  =EF=BB=BFIt seems like people are arguing in circles over this:

Do we:
	1. control potential memory usage by throttling I/O
or
	2. Throttle I/O when memory is full

I might lean toward (1) if we didn't already have a memory controller.
But, we have one, and it works.  Also, we *already* do (2) in the
kernel, so it would seem to graft well onto existing mechanisms that we
have.

I/O controllers should not worry about memory.  They're going to have a
hard enough time getting the I/O part right. :)

=EF=BB=BFOr, am I over-simplifying this?

-- Dave
