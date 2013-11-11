From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 22:09:20 +0000
Message-ID: <20131111220920.GD24324@agk-dp.fab.redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-2-git-send-email-snitzer@redhat.com>
	<20131111211934.GB24324@agk-dp.fab.redhat.com>
	<20131111213232.GA5099@redhat.com>
	<20131111215009.GA17903@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131111215009.GA17903@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 11, 2013 at 04:50:09PM -0500, Mike Snitzer wrote:
> Valid point... but given DM gives users a tremendous amount of room to
> hang itself this is par for the course no?  Making this more
> bullet-proof could have userspace detect that the device is being used
> as in a dm-cache device... and then running userspace utils to analyze
> whether the device still has dirty blocks.
 
Indeed - I am asking what the intended process for userspace to follow
is, as I can't see any particularly efficient one at the moment (for a
general case with many dirty blocks) without first making further kernel
changes - and some ways to do this better might involve using a
different kernel interface instead of the one included in this patch.

In other words, I'm asking for some details of the future direction of
the cache shrinking feature so we can see that the interface in this
patch is genuinely useful to userspace and will be built upon as the
userspace shrinking features are developed.  Otherwise I think it could
be premature to include it if it turns out userspace needs to do things
a different way with a different interface.

Alasdair
