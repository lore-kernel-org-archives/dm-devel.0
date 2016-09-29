From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: [dm-devel] [PATCH 03/10] md/dm-crypt: Rename a jump label in
 crypt_message()
Date: Thu, 29 Sep 2016 17:43:57 +0200
Message-ID: <e40a8107-7400-bc10-a212-563dd168aac5@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <7c232017-e291-fd2d-5516-26e5150d90df@users.sourceforge.net>
 <db29ff0c-8da9-e7ba-054d-a35f8b4fd2d7@users.sourceforge.net>
 <20160929125553.kn45yx6jud35463p@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160929125553.kn45yx6jud35463p@thunk.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

> In what bizzaro world is the "current Linux coding style convention"

Do you look at the evolution for a document like "CodingStyle"?


>> -
>> -error:
>> +show_warning:
>>  	DMWARN("unrecognised message received.");
>>  	return -EINVAL;
>>  }
> 
> "show_warning" is better than "error"

I got such an impression.


> when the net result of the goto is that the function returns -EINVAL?!?

Do other identifiers fit better for the desired description of "what" and "why"
by jump labels?


> Please give it up with these drive-by shooting of auto-generated patches.

This update step was not auto-generated.

There are further change possibilities where special analysis tools
can help in the corresponding software development.


> You're just embarassing yourself.

Do you find any of my update suggestions worth for further considerations?

Regards,
Markus
