From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [dm-devel] [RFC] dm-lc target
Date: Tue, 30 Jul 2013 22:02:51 +0900
Message-ID: <51F7B97B.3010704@gmail.com>
References: <CABmKtjcsZUbafxtmPb=2-Gkxz9PkFq7KVsQBqRkHduEn7aaqkw@mail.gmail.com> <51F48531.6040104@gmail.com> <20130729143916.GA20119@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130729143916.GA20119@debian>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: sunnikrishnan@stec-inc.com, kmo@daterainc.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Thanks for your comment, Joe.

Yes, dm-lc focuses solely on optimizing writes.

As you know, writing to RAID storage is slower than reading because of
so-called RAID penalty. So, only improving writes may rescue most of the
actual storage systems suffering from heavy I/Os. That's why I cares
writes more than reads.

> The next step is to get some third party users to post their
> experiences with it, and get some feedback on the code itself from
> Mike Snitzer.
Yes, I want to make my code better.

> If I get time I'll integrate it with my test suite.
Thanks. That seems to be a nice test suite.
I am currently testing dm-lc by make -j N and then make test with ruby
source code, but I think the test should be severer.
Actually, I have tried to implement general test tool for block device.
But I gave up.
https://github.com/akiradeveloper/iocheck

Your test suite is like one I have been pursuing.
I am really happy if you integrate dm-lc to your test suite.

Akira

On 7/29/13 11:39 PM, Joe Thornber wrote:
> On Sun, Jul 28, 2013 at 11:42:57AM +0900, Akira Hayakawa wrote:
>> I wrote an introduction slide which is available in URL below:
>> https://github.com/akiradeveloper/dm-lc/blob/develop/what-is-dm-lc.pdf
>> access the page and click "view raw".
> 
> This is nicely orthogonal to dm-cache.
> 
> dm-cache tries to move a working set of fixed size blocks into a cache
> to optimise both read and write.  dm-lc focusses solely on optimising
> bursty writes and uses a journal based structure to accomodate
> variable sized blocks.
> 
> The next step is to get some third party users to post their
> experiences with it, and get some feedback on the code itself from
> Mike Snitzer.
> 
> If I get time I'll integrate it with my test suite.
> 
> https://github.com/jthornber/device-mapper-test-suite
> 
> 
> - Joe
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
