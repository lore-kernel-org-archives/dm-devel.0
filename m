From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: md/dm-crypt: Rename a jump label in crypt_message() ?
Date: Fri, 30 Sep 2016 13:32:23 +0200
Message-ID: <d9c6668b-65b3-e410-81ed-1e43c227f015@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
 <db29ff0c-8da9-e7ba-054d-a35f8b4fd2d7@users.sourceforge.net>
 <20160929125553.kn45yx6jud35463p@thunk.org>
 <e40a8107-7400-bc10-a212-563dd168aac5@users.sourceforge.net>
 <20160930100603.GB13620@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20160930100603.GB13620@mwanda>
Sender: linux-doc-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: dm-devel.ids

> Again, I wrote the paragraph in CodingStyle.

This is obvious from the corresponding commit "add some more error
handling guidelines" (ea04036032edda6f771c1381d03832d2ed0f6c31
on 2014-12-02).


> I just said that it's a good idea to think about label names

I agree also to such a desire.


> instead of using GW-BASIC style numbered labels,

Is this kind of wording another weakness in the discussed document?
How many guidance do programmers get from such a software specification?

I came a few source code places along where I proposed corresponding changes.


> I didn't say

You did not say anything about some details as it is often easier to express
several aspects in vague and general terms.


> go around bothering everyone with waste of time cleanup patches.

I find it still debatable if the shown software development efforts
are really "wasted".

It seems that also the Linux development community is mixed about
related interpretations.


> I specifically did not say that "out:" or "error:" labels are bad names.

Did you inform me once that you had also a special opinion about an identifier
like "out"?

The C compiler will accept them as usual. But do we occasionally prefer
to express implementation details a bit better there?


> Those are common style in the kernel.

* Which impressions can you get from a statement like "goto fail;"
  or "goto error;"?

* Do any exception handling implementations should be reconsidered
  at such places?


> Please stop sending these patches.

Could it happen that the change acceptance will increase also for
the suggested renaming of jump labels if maintainers from other subsystems
would dare to respond once more in a positive way for such a software refactoring?

Regards,
Markus
