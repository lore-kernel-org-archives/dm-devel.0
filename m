From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dm-cache: document zeroing metadata device step
Date: Sun, 12 Jul 2020 20:59:32 +0100
Message-ID: <20200712195932.GV12769@casper.infradead.org>
References: <20200712194039.329035-1-austin880625@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200712194039.329035-1-austin880625@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Austin Chang <austin880625@gmail.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jul 13, 2020 at 03:40:39AM +0800, Austin Chang wrote:
> +  # When using dmsetup directly instead of volume manager like lvm2,
> +  # the first 4k of the metadata device should be zeroed to indicate
> +  # empty metadata.
> +  dd if=/dev/zero of=/dev/mapper/metadata bs=4k conv=notrunc

... don't you need 'count=1' or you'll zero the entire device?

>    dmsetup create my_cache --table '0 41943040 cache /dev/mapper/metadata \
>  	  /dev/mapper/ssd /dev/mapper/origin 512 1 writeback default 0'
>    dmsetup create my_cache --table '0 41943040 cache /dev/mapper/metadata \
> -- 
> 2.26.2
> 
