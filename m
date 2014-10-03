From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/4] dm: reduce memory overhead of DM devices
Date: Fri, 3 Oct 2014 17:04:55 -0400
Message-ID: <20141003210454.GB14135@redhat.com>
References: <542E8CF9.6000609@ce.jp.nec.com>
	<20141003132328.GB11977@redhat.com>
	<20141003204852.GA14135@redhat.com> <542F0DB9.4020805@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <542F0DB9.4020805@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

On Fri, Oct 03 2014 at  4:57pm -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> >Jens, I can easily yield this patchset to you if you care.  Or I can
> >backfill your Acked-by in the above 2 block commits (I obviously won't
> >just send block changes upstream without your OK!).
> 
> My only worry is the switch to fast clones, apart from that, it's
> pretty basic. But we are pretty close to the 3.18 merge window, and
> as such, I'd prefer to let it simmer for a release.

Fine with me.  fast clones is all we need (thanks to Kent's immutable
biovec work), but waiting until 3.19 will give us plenty of time to
verify all is well.
