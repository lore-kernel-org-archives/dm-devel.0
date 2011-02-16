From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: timestamp for shared snapshot
Date: Wed, 16 Feb 2011 17:55:44 +0000
Message-ID: <20110216175544.GB28729@agk-dp.fab.redhat.com>
References: <AANLkTinLFoOQ-mbPMAHQ0RCObyrWH0jMP4qQ0wsC4uaU@mail.gmail.com>
	<20110216143641.GA28595@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110216143641.GA28595@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: devicemapper niko <devicemapper.niko@gmail.com>
List-Id: dm-devel.ids

> > Is it possible to add timestamp and comment for each snapshots ?

Good idea - as a userspace lvm2 feature, yes.

We currently store creation details for each VG.
I agree we should also store such details for each LV.
This should be optional, but default to enabled.
(People short of space can perhaps turn it off, discarding any existing
details.)

Storing a comment is perhaps an extension to tag support that's been discussed,
to allow longer tags with a wider character set.

> It should be noted that the above shared snapshot work is unlikely to
> make it upstream (portions of it likely will, for instance the lvm2
> userspace changes).  A new shared snapshot implementation is in
> development.

Different snapshot implementations are optimised for different types of usage.
Each one involves choosing between different trade-offs.  We're unlikely ever
to have one solution that is optimal for everyone.

In that spirit, I hope to be submitting more than one shared snapshot
implementation upstream, including *both* of the ones referred to in this
message.  But I want the interfaces used by these implementations to be
basically compatible so that the same userspace tools can make use of them.

Alasdair
