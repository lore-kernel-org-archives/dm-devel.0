From: steve@chygwyn.com
Subject: Re: [PATCH 5/10] gfs2: Fix error handling in
	write_super_lockfs/unlockfs
Date: Fri, 26 Sep 2008 10:37:30 +0100
Message-ID: <20080926093730.GA5346@fogou.chygwyn.com>
References: <20080926175821t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080926175821t-sato@mail.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

Hi,

On Fri, Sep 26, 2008 at 05:58:21PM +0900, Takashi Sato wrote:
> Changed write_super_lockfs so that it returns an error in case of an failure.
> unlockfs always returns 0.

Looks good now. Thanks,

Steve.
