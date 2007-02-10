From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: -mm merge plans for 2.6.21 --
	md-dm-reduce-stack-usage-with-stacked-block-devices.patch
Date: Sat, 10 Feb 2007 10:58:58 +0100
Message-ID: <20070210095858.GA8145@osiris.boeblingen.de.ibm.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070208150710.1324f6b4.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Feb 08, 2007 at 03:07:10PM -0800, Andrew Morton wrote:
> drivers-mdc-use-array_size-macro-when-appropriate.patch
> md-dm-reduce-stack-usage-with-stacked-block-devices.patch
>  
>  -> neilb
>  
>  (The second one is getting idiotic.  When are we going to fix this??)

Since it was me who asked to have the stack usage reduced and Neil was
kind enough to fix this, I'm wondering what the state of dm is.

I think more than a year ago we had this:

Alasdair G Kergon <agk@redhat.com> said:

 I can see nothing wrong with this in principle.

 For device-mapper at the moment though it's essential that, while the bio
 mappings may now get delayed, they still get processed in exactly
 the same order as they were passed to generic_make_request().

 My main concern is whether the timing changes implicit in this patch
 will make the rare data-corrupting races in the existing snapshot code
 more likely. (I'm working on a fix for these races, but the unfinished
 patch is already several hundred lines long.)

 It would be helpful if some people on this mailing list would test
 this patch in various scenarios and report back.

Alasdair, is dm already fixed or is there any chance that it will
ever get fixed?
