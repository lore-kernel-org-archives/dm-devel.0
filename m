From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [dm-devel] [PATCH 05/10] md/dm-crypt: Rename a jump label in
 crypt_set_key()
Date: Thu, 29 Sep 2016 08:56:54 -0400
Message-ID: <20160929125654.hxhuz3k6h3wdnfbq@thunk.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
 <f89d98a2-fe7e-a9d3-5bdc-2a1943e09049@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f89d98a2-fe7e-a9d3-5bdc-2a1943e09049@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Sep 28, 2016 at 05:42:28PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 28 Sep 2016 15:21:18 +0200
> 
> Adjust jump labels according to the current Linux coding style convention.
> 
> -
> -out:
> +set_memory:
>  	/* Hex key string not needed after here, so wipe it. */
>  	memset(key, '0', key_string_len);

Also not "current Linux coding style convetion".

							- Ted

