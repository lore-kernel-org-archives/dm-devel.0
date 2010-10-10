From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 19:17:36 +0100
Message-ID: <20101010181736.GE28828@agk-dp.fab.redhat.com>
References: <20101010115941.GA8539@basil.fritz.box> <4CB1B3B9.4030205@redhat.com> <20101010130842.GE8256@basil.fritz.box> <4CB1DD1A.5080906@redhat.com> <20101010162257.GA1272@redhat.com> <20101010170151.GD28828@agk-dp.fab.redhat.com> <20101010174454.GA21681@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101010174454.GA21681@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: Milan Broz <mbroz@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>, pedrib@gmail.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Oct 10, 2010 at 07:44:54PM +0200, Andi Kleen wrote:
> It's not broken AFAIK and it will not perform worse than the original
> single thread work queue.
 
This is the contentious code:

+       /*
+        * Since we only have a single worker per CPU in extreme
+        * cases there might be nesting (dm-crypt on another dm-crypt)
+        * To avoid deadlock run the work directly then.
+        */
+       cpu = get_cpu();   
+       if (per_cpu(io_wq_cpu, cpu) == current && !in_interrupt()) {
+               put_cpu();
+               kcryptd_io(&io->work);   
+               return;
+       }

AFAIK Nested dm-crypt is not extreme for some folk who have routine
configurations using it.  But if in_interrupt is set how does this code
work for them now compared to how it worked before?

Alasdair
