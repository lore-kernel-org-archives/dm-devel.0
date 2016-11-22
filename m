From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] dm: use bvec iterator helpers to implement
 .get_page and .next_page
Date: Mon, 21 Nov 2016 23:28:44 -0800
Message-ID: <20161122072844.GA21761@infradead.org>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
 <1478865957-25252-8-git-send-email-tom.leiming@gmail.com>
 <20161121144956.GB23051@redhat.com>
 <CACVXFVOHLMC+qHZco7S675PnbbNQyDH+qobcjdtJEyTE41gEmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVOHLMC+qHZco7S675PnbbNQyDH+qobcjdtJEyTE41gEmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Alasdair Kergon <agk@redhat.com>, "maintainer:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Jens, can you apply the non-dm patches?
