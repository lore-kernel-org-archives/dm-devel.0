From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm: Make MIN_IOS, et al, tunable via sysctl.
Date: Tue, 20 Aug 2013 18:52:57 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308201852220.22284@file01.intranet.prod.int.rdu2.redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com> <alpine.LRH.2.02.1308201712090.8826@file01.intranet.prod.int.rdu2.redhat.com> <1377034118.24869.48.camel@bobble.lax.corp.google.com> <alpine.LRH.2.02.1308201745130.8826@file01.intranet.prod.int.rdu2.redhat.com>
 <1377035833.24869.57.camel@bobble.lax.corp.google.com> <20130820222439.GA5883@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130820222439.GA5883@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Frank Mayhar <fmayhar@google.com>, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 20 Aug 2013, Mike Snitzer wrote:

> Mikulas' point is that you cannot reduce the size to smaller than 1.
> And aside from rq-based DM, 1 is sufficient to allow for forward
> progress even when memory is completely consumed.
> 
> A patch that simply changes them to 1 but makes the rq-based DM
> mempool's size configurable should actually be fine.

Yes, I think it would be viable.

Mikulas

> Mike
