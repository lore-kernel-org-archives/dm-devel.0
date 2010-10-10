From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [dm-devel] DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 20:51:00 +0200
Message-ID: <20101010185100.GB21681@basil.fritz.box>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
 <20101010130842.GE8256@basil.fritz.box>
 <4CB1DD1A.5080906@redhat.com>
 <20101010162257.GA1272@redhat.com>
 <20101010170151.GD28828@agk-dp.fab.redhat.com>
 <20101010174454.GA21681@basil.fritz.box>
 <20101010181736.GE28828@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101010181736.GE28828@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>, Milan Broz <mbroz@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> AFAIK Nested dm-crypt is not extreme for some folk who have routine
> configurations using it.  But if in_interrupt is set how does this code
> work for them now compared to how it worked before?

Previously they will all pile up on the single worker thread.

Now in the nested case the nested work is run in their own
context. This should actually scale better because you
get parallelism too, not contention on a single resource.

The only difference to the non nested case is that the wq 
is not used.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
