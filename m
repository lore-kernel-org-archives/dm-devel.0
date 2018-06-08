From: Jens Axboe <axboe@kernel.dk>
Subject: Re: next-20180605 - kernel tried to execute NX-protected page -
 exploit attempt?
Date: Fri, 8 Jun 2018 15:17:43 -0600
Message-ID: <4d8ac96b-8537-6f6a-1223-5bf6f75769e5@kernel.dk>
References: <21051.1528404057@turing-police.cc.vt.edu>
 <20180607211401.GD4481@redhat.com>
 <136327.1528411295@turing-police.cc.vt.edu>
 <248061.1528488439@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <248061.1528488439@turing-police.cc.vt.edu>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: valdis.kletnieks@vt.edu, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 6/8/18 2:07 PM, valdis.kletnieks@vt.edu wrote:
> On Thu, 07 Jun 2018 18:41:35 -0400, valdis.kletnieks@vt.edu said:
>> On Thu, 07 Jun 2018 17:14:01 -0400, Mike Snitzer said:
>>> Can you please share what you test is?  We've gotten lots of reports
>>> with failure following wake_up but I don't have a canned test to trigger
>>
>> Just a laptop with 16G of RAM, no clear reproducer -  Chrome with a lot of
>> tabs, a mail reader, a bunch of SSH windows, and the next thing I know, it's
>> locked up good and solid with wreckage in /sys/fs/pstore :)
>>
>> I got bit a third time a little while ago.  Will test the patches and see if
>> they help - looks like I'm averaging two hours or so of active use before it
>> hits, so it shouldn't take long before I know if the issue is swatted...
> 
> Looks like those two patches from Jens fixed the issue - this build has been up for
> 20 hours, and has survived a kernel build, an OpenWRT/Lede build, and a backup,
> along with a bunch of other stuff.

Thanks for testing - I've sent the pull request to Linus, so hopefully it'll
soon be fixed in mainline as well.

-- 
Jens Axboe
