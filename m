From: Mike Snitzer <snitzer@redhat.com>
Subject: [LSF/MM TOPIC] block, dm: restack queue_limits
Date: Mon, 29 Jan 2018 16:08:37 -0500
Message-ID: <20180129210836.GA5744@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

We currently don't restack the queue_limits if the lowest, or
intermediate, layer of an IO stack changes.

This is particularly unfortunate in the case of FLUSH/FUA which may
change if/when a HW controller's BBU fails; whereby requiring the device
advertise that it has a volatile write cache (WCE=1).

But in the context of DM, really it'd be best if the entire stack of
devices had their limits restacked if any underlying layer's limits
change.

In the past, Martin and I discussed that we should "just do it" but
never did.  Not sure we need a lengthy discussion but figured I'd put it
out there.

Maybe I'll find time, between now and April, to try implementing it.

Thanks,
Mike
