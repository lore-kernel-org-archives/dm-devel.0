From: OS Engineering <osengineering-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: RE: Performance Comparison among EnhanceIO, bcache and dm-cache.
Date: Tue, 2 Jul 2013 08:25:17 +0000
Message-ID: <D399C715A2AD7F4F891A75871FC3117508A112@MYMBX3.stec-inc.ad>
References: <D399C715A2AD7F4F891A75871FC3117507866B@MYMBX3.stec-inc.ad>
 <CAMM=eLfKku3CuHUS-0Akv=FdEzk_OWz3j+3oTAWCrFnFLZ0b1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMM=eLfKku3CuHUS-0Akv=FdEzk_OWz3j+3oTAWCrFnFLZ0b1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Amit Phansalkar <aphansalkar-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>, "thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Padmini Balasubramaniyan <padminib-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>, "koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

>On Jun 11, 2013 11:06 AM, "OS Engineering" <osengineering-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org=
> wrote:
>>
>> Hi Jens,
>>
>> In continuation with our previous communication, we have carried out=
 performance comparison among EnhanceIO, bcache and dm-cache.

>How reproducible are these results?=A0 Any chance you could do 5-10 ru=
ns to get the avg and stddev?=A0 May (or may not) prove interesting.

Hi mike,

We found that, in case of write through caches, the test results were c=
onsistent for all caching solution with EnhanceIO providing better thro=
ughput in comparison to bcache and dm-cache. However, under write-back =
mode, dm-cache showed a large standard deviation. The results for Enhan=
ceIO and bcache were consistent with EnhanceIO providing higher through=
put when compared to bcache.

We have performed 5 runs for all our performance tests and observed the=
ir mean and standard deviations.=20
The test results can be found at: https://gist.github.com/sanoj-stec/58=
58574
The test scripts can be found at:  https://github.com/stec-inc/EnhanceI=
O/tree/master/performance_test

Regards,
Sanoj
