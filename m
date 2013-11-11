From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 18:06:26 -0500
Message-ID: <CAMM=eLdsE7_MsKoZUZkRa0S83NkcN6esYL8AEF+PpV17tvMqbw@mail.gmail.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-2-git-send-email-snitzer@redhat.com>
	<20131111211934.GB24324@agk-dp.fab.redhat.com>
	<20131111213232.GA5099@redhat.com> <20131111215009.GA17903@redhat.com>
	<20131111220920.GD24324@agk-dp.fab.redhat.com>
	<20131111221527.GE24324@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20131111221527.GE24324@agk-dp.fab.redhat.com>
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
List-Id: dm-devel.ids

On Mon, Nov 11, 2013 at 5:15 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> Could you make the case that this interface is only intended for use
> when using the cache in a mode that doesn't have dirty blocks?

This really isn't even an "interface".  All this patch enables a user
to do is shrink the cache device is they have taken care to not have
dirty blocks (be it "cleaner" policy or passthrough or writethrough
operation modes).

> And that the mechanism for shrinking a cache with dirty blocks has not
> yet been developed but might use a quite different interface?

We can add an interface to instruct the cache to clean all dirty
blocks >= a particular size [1].  Whereby enabling even dirty/hot
caches to remain generally useful while allowing to shrink the fast
device.

But no I'm not prepared to predict what that'll look like, and no that
doesn't invalidate the basic support that this patch is providing.

We'll improve the docs but there is no reason to withhold this patch
waiting for more add-ons.  By the time lvm2 has support for dm-cache
this very likely won't be a concern anyway (e.g. we'll have the
ability to do [1] above).
