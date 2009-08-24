From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: implement .iterate_devices
Date: Mon, 24 Aug 2009 18:55:15 -0400
Message-ID: <20090824225514.GA30263@redhat.com>
References: <1251007867-13004-1-git-send-email-snitzer@redhat.com>
	<20090824141536.30df105c.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090824141536.30df105c.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Aug 24 2009 at  5:15pm -0400,
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 23 Aug 2009 02:11:07 -0400
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > This patch implements .iterate_devices for the origin and snapshot
> > targets.  dm-snapshot's lack of .iterate_devices resulted in the
> > inability to properly establish queue_limits for both targets.  
> > 
> > With 4K sector drives: an unfortunate side-effect of not establishing
> > proper limits in either targets' DM device was that IO to the devices
> > would fail even though both had been created without error.
> 
> Does this make the patch a regression fix?

Yes.
 
> > Commit af4874e03ed82f050d5872d8c39ce64bf16b5c38 should have implemented
> > .iterate_devices for dm-snap.c's origin and snapshot targets.
> 
> Please use the form af4874e03ed82f050d5872d8c39ce64bf16b5c38 ("dm
> target:s introduce iterate devices fn") when referring to commits. 
> Because commits might have different IDs in different trees (I think
> that's the reason).

OK, thanks for picking this up.  I believe Alasdair is back from
vacation tomorrow and will be pushing other remaining DM fixes for
2.6.31 final.
