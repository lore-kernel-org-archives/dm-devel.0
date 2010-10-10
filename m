From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 18:01:51 +0100
Message-ID: <20101010170151.GD28828@agk-dp.fab.redhat.com>
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101010162257.GA1272@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>, Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Oct 10, 2010 at 12:22:57PM -0400, Mike Snitzer wrote:
> this out quite yet.  You have 4 patches yet you say conceptually there
> are 2 distinct changes.
 
IOW should we end up with 2 bisectable patches here?

And the potentially-broken/poorly-performing stacked async should be
explained in comments inline perhaps if we're choosing to ignore this
apparent regression.

Alasdair
