From: David Howells <dhowells@redhat.com>
Subject: Re: [-mm patch] drivers/md/Kconfig: fix BLOCK dependency
Date: Fri, 01 Sep 2006 15:15:11 +0100
Message-ID: <11281.1157120111@warthog.cambridge.redhat.com>
References: <20060901135055.GA18276@stusta.de>  <20060901015818.42767813.akpm@osdl.org> <44F80F0D.70100@zen.co.uk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932072AbWIAOQX@vger.kernel.org>
In-Reply-To: <20060901135055.GA18276@stusta.de> 
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Grant Wilson <grant.wilson@zen.co.uk>, David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Adrian Bunk <bunk@stusta.de> wrote:

> -if CONFIG_BLOCK
> +if BLOCK

Oops.

Acked-By: David Howells <dhowells@redhat.com>
