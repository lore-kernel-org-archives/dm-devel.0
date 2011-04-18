From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Date: Mon, 18 Apr 2011 17:30:48 -0400
Message-ID: <20110418213048.GA21852@infradead.org>
References: <4DA2E03A.2080607@fusionio.com>
 <20110411212635.7959de70@notabene.brown>
 <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110418081922.1651474a@notabene.brown>
 <4DABDC60.2090009@fusionio.com>
 <20110418172551.55629fc6@notabene.brown>
 <4DABF1EA.3070301@fusionio.com>
 <20110418183343.036f412e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110418183343.036f412e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

>       md: provide generic support for handling unplug callbacks.

This looks like some horribly ugly code to me.  The real fix is to do
the plugging in the block layers for bios instead of requests.  The
effect should be about the same, except that merging will become a
little easier as all bios will be on the list now when calling into
__make_request or it's equivalent, and even better if we extent the
list sort callback to also sort by the start block it will actually
simplify the merge algorithm a lot as it only needs to do front merges
and no back merges for the on-stack merging.

In addition it should also allow for much more optimal queue_lock
roundtrips - we can keep it locked at the end of what's currently
__make_request to have it available for the next bio that's been
on the list.  If it either can be merged now that we have the lock
and/or we optimize get_request_wait not to sleep in the fast path
we could get down to a single queue_lock roundtrip for each unplug.

