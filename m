From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [dm-devel] [PATCH v5] dm mpath: avoid call to blk_abort_queue by
 default
Date: Thu, 18 Nov 2010 12:39:55 -0800
Message-ID: <20101118203954.GA6241@linux.vnet.ibm.com>
References: <1290107959-17167-1-git-send-email-snitzer@redhat.com>
 <1290110853-17541-1-git-send-email-snitzer@redhat.com>
 <20101118201841.GE30435@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101118201841.GE30435@agk-dp.fab.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org
List-Id: dm-devel.ids

Alasdair G Kergon <agk@redhat.com> wrote:
> On Thu, Nov 18, 2010 at 03:07:33PM -0500, Mike Snitzer wrote:
> > It is expected that this race will be fixed in the near-term so it makes
> > little since to remove all associated code.  Providing control over the
> > call to blk_abort_queue() facilitates continued testing and future
> > flexibility to opt-in to lower latency path deactivation.  Opting to
> > enable this feature will emit a warning for the time being.
> 
> Ah, but then the *feature* keyword - which is only going to be needed
> temporarily until it's fixed - becomes a permanent part of the interface...
> 
> If it's broken, let's just disable it (#define-style) until it gets fixed.
> (And only if it doesn't get fixed in a reasonable amount of time, remove the
> code.)

I understand that if its broken that we could #define it out in dm or we
could #define the code in blk_abort_queue.

I believe the thought was that post addressing the race issue that
others may want control. As there maybe cases where the waking up of the
error_handler and a extra abort may not be wanted in all cases. 

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
