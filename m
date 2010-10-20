From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
Date: Wed, 20 Oct 2010 18:32:31 +0100
Message-ID: <20101020173231.GP3935@agk-dp.fab.redhat.com>
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com> <4CB1ECCA.8040801@redhat.com> <20101010170750.GA1475@redhat.com> <4CB20C72.3030504@redhat.com> <4CB7595C.4000801@redhat.com> <4CBEFABC.3030400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CBEFABC.3030400@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Andi Kleen <andi@firstfloor.org>, pedrib@gmail.com
List-Id: dm-devel.ids

On Wed, Oct 20, 2010 at 04:20:44PM +0200, Milan Broz wrote:
> this patch introduces apparent regressions in async crypto mode.
 
OK, thanks for performing those tests.

This patch is stalled until these problems are understood properly and
solutions are proposed.  I was prepared to overlook the regression in
stacked 'async' provided there was an inline FIXME explaining clearly
how to fix it in future should we need to, but I can't support a patch that
apparently breaks stacked sync encryption.

One solution might be to make the proposed changes only for non-stacked
configurations and leave stacks to work as they do today - either
detecting that automatically or having userspace supply a target
parameter to say whether or not to turn it on.  (For that, would need
tests to show a stack of many layers where only one is a crypt target
continues to work after the change.)

Alasdair
