From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [-mm patch] drivers/md/Kconfig: fix BLOCK dependency
Date: Fri, 1 Sep 2006 16:26:23 +0200
Message-ID: <20060901142622.GE25434@kernel.dk>
References: <20060901135055.GA18276@stusta.de> <20060901015818.42767813.akpm@osdl.org> <44F80F0D.70100@zen.co.uk> <11281.1157120111@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751120AbWIAOXZ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11281.1157120111@warthog.cambridge.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>, Grant Wilson <grant.wilson@zen.co.uk>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Sep 01 2006, David Howells wrote:
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > -if CONFIG_BLOCK
> > +if BLOCK
> 
> Oops.
> 
> Acked-By: David Howells <dhowells@redhat.com>

Merged.

-- 
Jens Axboe
