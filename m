From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] DM-CRYPT: Scale to multiple CPUs v3
Date: Mon, 11 Oct 2010 11:32:09 +0200
Message-ID: <4CB2D999.9080002@redhat.com>
References: <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com> <20101010170151.GD28828@agk-dp.fab.redhat.com> <20101010174454.GA21681@basil.fritz.box> <20101010181736.GE28828@agk-dp.fab.redhat.com> <20101010185100.GB21681@basil.fritz.box> <20101010190734.GH28828@agk-dp.fab.redhat.com> <20101010191640.GC21681@basil.fritz.box> <4CB21492.8050101@redhat.com> <20101010202031.GD21681@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101010202031.GD21681@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Mike Snitzer <snitzer@redhat.com>, Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 10/10/2010 10:20 PM, Andi Kleen wrote:
>> But previously, there were threads per device, so if one IO thread blocks,
>> others stacked mappings can continue
>> Now I see possibility for deadlock there because we have one io thread now
>> (assuming that 1 CPU situation Alasdair mentioned).
> 
> That path calls the crypto worker thread, not the IO worker thread?
> crypto worker should be fine here, only IO worker would be a problem
> I think because crypto doesn't really block on nested IO.

Well, crypt thread can block, this is surely not what we want in async callback
and IO thread cannot call generic_make_request() from this context as well...

But the reads are not problem - system queues IO, then after completion
it calls async crypt. When async crypt is done, kcrypt_crypt_read_done()
is called - and it is safe, there is just bio_endio().

The problem is write path - it allocates bio clone, run async crypto on it
and the final callback queues cloned bio to underlying device.
Because code cannot call generic_make_request() directly here (assuming
it still runs in interrupt mode), it submits new work to io thread.

So there the code behaves the same as before - just instead of queueing into
separate per-device io workqueue we have now just one common queue...
So question is, if this is safe in all stacked situations and cannot deadlock.

Imagine you have stacked one dm-crypt device, which implements uses
alg in sync mode over another one, which run in async mode.
So the common io thread runs both encryption and make_request...
If it can lock itself here, it is regression from previous version here.

(Note I am not blocking the patch - I think this can be solved later somehow,
but either we should know about this problem or prove it is safe.
In normal (sync) mode this path is not used at all - and this is the most
common situation.)

Milan
