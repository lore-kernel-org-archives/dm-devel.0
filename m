From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
Date: Wed, 03 Mar 2010 22:42:17 +0300
Message-ID: <87lje9kx9i.fsf@openvz.org>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
	<20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org>
	<170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com>
	<87wrxtkzwu.fsf@openvz.org> <20100303191613.GB18480@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100303191613.GB18480@redhat.com> (Mike Snitzer's message of
	"Wed, 3 Mar 2010 14:16:13 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:

> Linux has all sorts of internal interfaces that are "odd"... the current
> 'q->merge_bvec_fn' interface included.  But odd is not a problem (nor is
> it "broken") unless you make changes that don't consider how the current
> interface is defined.
Ok. then cant you please explain more historical questions
1) Why bio_add_page() can not add less data than requested?
   Seems that it doesn't make caller's code much complicate
   Off course barrier bio is special case. I don't consider it here.
   
2) What statement "bio_add_page() must accept at least one page"
   exactly means?
   IMHO this means that bio_add_page() must accept at least
   one page with len (PAGE_SIZE - offset). Or more restricted
   statemnt that first bio_add_page() must be always successfull.

   But currently in some places this rule treated as what all bio
   which has size less whan PAGE_SIZE are accepted. And in x86 such
   bio may has up to 8 pages/bvecs.
>
> But I digress...
>
> Mike
