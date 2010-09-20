From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] idr_get_new_exact ?
Date: Mon, 20 Sep 2010 22:38:25 +0100
Message-ID: <20100920213825.GF30622@agk-dp.fab.redhat.com>
References: <AANLkTi=ZLupVyFR0e2v-TLpeNWdw1bVMZUAhgyxLJ7OV@mail.gmail.com> <adaiq20f90h.fsf@cisco.com> <4C97D197.9070703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C97D197.9070703@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Roland Dreier <rdreier@cisco.com>, Ohad Ben-Cohen <ohad@wizery.com>, akpm@linux-foundation.org, Steve Wise <swise@chelsio.com>linux-
List-Id: dm-devel.ids

On Mon, Sep 20, 2010 at 11:26:47PM +0200, Tejun Heo wrote:
> I agree.  Wouldn't those users better off simply using radix tree?
 
Can't speak for the other users, but dm uses it both ways - normally
happy with any id (minor number), but sometimes user requires a specific
one.

Alasdair

