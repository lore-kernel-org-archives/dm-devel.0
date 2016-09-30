From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [dm-devel] [PATCH 03/10] md/dm-crypt: Rename a jump label in
 crypt_message()
Date: Fri, 30 Sep 2016 13:06:03 +0300
Message-ID: <20160930100603.GB13620@mwanda>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
 <db29ff0c-8da9-e7ba-054d-a35f8b4fd2d7@users.sourceforge.net>
 <20160929125553.kn45yx6jud35463p@thunk.org>
 <e40a8107-7400-bc10-a212-563dd168aac5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e40a8107-7400-bc10-a212-563dd168aac5@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Theodore Ts'o <tytso@mit.edu>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Sep 29, 2016 at 05:43:57PM +0200, SF Markus Elfring wrote:
> > In what bizzaro world is the "current Linux coding style convention"
> 
> Do you look at the evolution for a document like "CodingStyle"?
> 

Again, I wrote the paragraph in CodingStyle.  I just said that it's a
good idea to think about label names instead of using GW-BASIC style
numbered labels, I didn't say go around bothering everyone with waste
of time cleanup patches.

I specifically did not say that "out:" or "error:" labels are bad names.
Those are common style in the kernel.

Please stop sending these patches.

regards,
dan carpenter
