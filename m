From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: md/dm-crypt: Rename a jump label in crypt_message() ?
Date: Fri, 30 Sep 2016 15:02:14 +0300
Message-ID: <20160930120214.GW26713@mwanda>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
 <db29ff0c-8da9-e7ba-054d-a35f8b4fd2d7@users.sourceforge.net>
 <20160929125553.kn45yx6jud35463p@thunk.org>
 <e40a8107-7400-bc10-a212-563dd168aac5@users.sourceforge.net>
 <20160930100603.GB13620@mwanda>
 <d9c6668b-65b3-e410-81ed-1e43c227f015@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d9c6668b-65b3-e410-81ed-1e43c227f015@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Theodore Ts'o <tytso@mit.edu>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Sep 30, 2016 at 01:32:23PM +0200, SF Markus Elfring wrote:
> > I specifically did not say that "out:" or "error:" labels are bad names.
> 
> Did you inform me once that you had also a special opinion about an identifier
> like "out"?

I don't like out labels, but that's my opinion.  There is nothing in
CodingStyle which says you can't do it.

regards,
dan carpenter
