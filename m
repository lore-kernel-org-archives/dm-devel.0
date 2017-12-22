From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: regression 4.15-rc: kernel oops in dm-multipath
Date: Fri, 22 Dec 2017 11:14:14 -0500
Message-ID: <20171222161413.GA31354@redhat.com>
References: <7dc463af-554f-1778-7e24-757de143d6b7@de.ibm.com>
 <1513958435.2579.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513958435.2579.1.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "agk@redhat.com" <agk@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>
List-Id: dm-devel.ids

On Fri, Dec 22 2017 at 11:00am -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Fri, 2017-12-22 at 10:53 +0100, Christian Borntraeger wrote:
> > any quick ideas?
> 
> Hello Christian,
> 
> Was commit afc567a4977b ("dm table: fix regression from improper dm_dev_internal.count
> refcount_t conversion") included in your test kernel?

Good call.  Unlikely since since he is running 4.15-rc3 but afc567a4977b
wasn't merged until after rc3; for inclusion in 4.15-rc4.
