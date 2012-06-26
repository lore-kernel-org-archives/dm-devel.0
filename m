From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH] block: all callers should check blkdev_issue_flush's return
Date: Tue, 26 Jun 2012 11:33:10 -0400
Message-ID: <x498vfarsuh.fsf@segfault.boston.devel.redhat.com>
References: <1340724445-3314-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1340724445-3314-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Tue, 26 Jun 2012 11:27:25 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tj@kernel.org, hch@infradead.org, vgoyal@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Mike Snitzer <snitzer@redhat.com> writes:

> It is concerning that a FLUSH may fail but the blkdev_issue_flush
> callers assume it will always succeed.
>
> Each blkdev_issue_flush caller should come to terms with the reality
> that a FLUSH may fail -- the file_operations' .fsync methods in
> particular.  nilfs2 is the only filesystem that checks
> blkdev_issue_flush's return.

Yeah, as it stands, it looks like in many cases fsync won't return an
error if a flush fails.  That's bad.
