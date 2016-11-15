From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] dm: use bvec iterator helpers to implement
 .get_page and .next_page
Date: Tue, 15 Nov 2016 10:55:51 -0800
Message-ID: <20161115185551.GA14816@infradead.org>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
 <1478865957-25252-8-git-send-email-tom.leiming@gmail.com>
 <CACVXFVPbG6Dz2F=tc9o=jPdNCcXWDmtReaWGWQeTPa9HaGjh0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVPbG6Dz2F=tc9o=jPdNCcXWDmtReaWGWQeTPa9HaGjh0A@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

> Hi Alasdair, Mike, Christoph and anyone,
> 
> Could you give this one a review?

It looks nice, but I don't understand the code anywhere near well
enough to review it.  We'll need someone from the DM to look over it.
