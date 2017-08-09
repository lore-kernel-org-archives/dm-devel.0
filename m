From: "hch@lst.de" <hch@lst.de>
Subject: Re: [BUG] BLKZEROOUT on dm-crypt container cause OOM / kernel panic
Date: Wed, 9 Aug 2017 15:38:33 +0200
Message-ID: <20170809133833.GA25681@lst.de>
References: <CAGnHSEngW1Ugf66V5henR9fMEev0xcJnKVY9MjJb19gy3CkgNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEngW1Ugf66V5henR9fMEev0xcJnKVY9MjJb19gy3CkgNA@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, gmazyland@gmail.com, "axboe@fb.com" <axboe@fb.com>, axboe@kernel.dk, "hch@lst.de" <hch@lst.de>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Does commit 615d22a51c04856efe62af6e1d5b450aaf5cc2c0
"block: Fix __blkdev_issue_zeroout loop" fix the issue for you?
