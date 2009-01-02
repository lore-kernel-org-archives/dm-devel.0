From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] freeze feature ver 1.14
Date: Fri, 2 Jan 2009 04:47:30 -0500
Message-ID: <20090102094730.GA17841@infradead.org>
References: <20081027215811t-sato@mail.jp.nec.com> <495DA488.7080702@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <495DA488.7080702@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Jan 01, 2009 at 11:22:16PM -0600, Eric Sandeen wrote:
> In lieu of the timeout feature which was originally proposed, how
> about access to an emergency un-freeze via magic sysrq, maybe
> piggy-backed on emergency sync... something like this (not
> tested or even built yet...), would this be a good compromise to
> help save people from frozen roots?

Looks sane to me.  But for that we'd need to get the generic freeze bits
in first.  Andrews, as they are in 2.6.28-rc2 do you plan to send them?

Any chance for a general -mm merge plan, btw?

