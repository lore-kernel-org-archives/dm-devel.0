From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: md/dm-crypt: Rename a jump label in crypt_message() ?
Date: Fri, 30 Sep 2016 14:19:57 +0200
Message-ID: <fb79ac4d-3d77-b446-e370-e0a48d997c60@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
 <db29ff0c-8da9-e7ba-054d-a35f8b4fd2d7@users.sourceforge.net>
 <20160929125553.kn45yx6jud35463p@thunk.org>
 <e40a8107-7400-bc10-a212-563dd168aac5@users.sourceforge.net>
 <20160930100603.GB13620@mwanda>
 <d9c6668b-65b3-e410-81ed-1e43c227f015@users.sourceforge.net>
 <20160930120214.GW26713@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160930120214.GW26713@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: dm-devel.ids

> I don't like out labels, but that's my opinion.

Thanks for this acknowledgement that you have still got a special opinion
about such an identifier.

 
> There is nothing in CodingStyle which says you can't do it.

Does the terse description there try to suggest also to choose
better identifiers for source code places?

Does the meaning of such a coding style specification include also
the selection of a more pleasing identifier than "error"
for this software module?

Regards,
Markus
