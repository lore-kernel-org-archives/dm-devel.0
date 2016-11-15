From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 07/12] dm: use bvec iterator helpers to implement
 .get_page and .next_page
Date: Tue, 15 Nov 2016 13:57:14 -0500
Message-ID: <20161115185714.GA17614@redhat.com>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
 <1478865957-25252-8-git-send-email-tom.leiming@gmail.com>
 <CACVXFVPbG6Dz2F=tc9o=jPdNCcXWDmtReaWGWQeTPa9HaGjh0A@mail.gmail.com>
 <20161115185551.GA14816@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161115185551.GA14816@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Tue, Nov 15 2016 at  1:55pm -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> > Hi Alasdair, Mike, Christoph and anyone,
> > 
> > Could you give this one a review?
> 
> It looks nice, but I don't understand the code anywhere near well
> enough to review it.  We'll need someone from the DM to look over it.

I'll try to get to it this week.
