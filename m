From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 17/23] dm: Refactor for new bio
	cloning/splitting
Date: Tue, 29 Oct 2013 20:29:36 -0400
Message-ID: <20131030002935.GA3449@redhat.com>
References: <1383077896-4132-1-git-send-email-kmo@daterainc.com>
	<1383077896-4132-18-git-send-email-kmo@daterainc.com>
	<20131030000908.GB2989@redhat.com> <20131030001959.GB27129@kmo>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131030001959.GB27129@kmo>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, dm-devel@redhat.com, tj@kernel.org, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 29 2013 at  8:19pm -0400,
Kent Overstreet <kmo@daterainc.com> wrote:

> On Tue, Oct 29, 2013 at 08:09:08PM -0400, Mike Snitzer wrote:
> > 
> > But now that I look closer, the above dm-thin.c hunks belong in:
> > [PATCH 19/23] block: Generic bio chaining
> > 
> > Seems these changes were mistakenly folded into this 17/23 patch?
> 
> ...Whoops, fixed. Here's the new versions if you want to take a look:
> 
> http://evilpiepirate.org/git/linux-bcache.git/log/?h=for-jens
> http://evilpiepirate.org/git/linux-bcache.git/commit/?h=for-jens&id=74f0f2084f88bb38403ca80bb98976f8219f9262

Yeap, looks good (aside from the dm patches not having my Reviewed-by).

Not sure if Jens can add it?..  that said, I don't mind the commits not
having my Reviewed-by but it does lose some context for your changes
having had some other eyeballs on them.
