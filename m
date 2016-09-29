From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [dm-devel] [PATCH 03/10] md/dm-crypt: Rename a jump label in
 crypt_message()
Date: Thu, 29 Sep 2016 08:55:53 -0400
Message-ID: <20160929125553.kn45yx6jud35463p@thunk.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
 <db29ff0c-8da9-e7ba-054d-a35f8b4fd2d7@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <db29ff0c-8da9-e7ba-054d-a35f8b4fd2d7@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Sep 28, 2016 at 05:40:14PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 28 Sep 2016 14:54:39 +0200
> 
> Adjust a jump label according to the current Linux coding style convention.

In what bizzaro world is the "current Linux coding style convention"

> -
> -error:
> +show_warning:
>  	DMWARN("unrecognised message received.");
>  	return -EINVAL;
>  }

"show_warning" is better than "error" when the net result of the goto
is that the function returns -EINVAL?!?

Please give it up with these drive-by shooting of auto-generated
patches.  You're just embarassing yourself.

							- Ted
