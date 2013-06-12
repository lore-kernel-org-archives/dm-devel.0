From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 22/26] block: Make generic_make_request handle arbitrary
 sized bios
Date: Tue, 11 Jun 2013 21:26:55 -0700
Message-ID: <20130612042655.GA8650@moria.home.lan>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
 <1370744348-15407-23-git-send-email-koverstreet@google.com>
 <20130611171241.GA5316@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130611171241.GA5316@twin.jikos.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: dsterba@suse.cz, axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jun 11, 2013 at 07:12:41PM +0200, David Sterba wrote:
> On Sat, Jun 08, 2013 at 07:19:04PM -0700, Kent Overstreet wrote:
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -467,6 +468,7 @@ struct request_queue {
> >  #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
> >  #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
> >  #define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
> > +#define QUEUE_FLAG_LARGEBIOS   19	/* no limits on bio size */
>                                   ^^
> 				  20 ?
> 
> david

Whoops! Thanks, fixed.
