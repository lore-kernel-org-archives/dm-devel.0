From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] [RFC] dm-lc target
Date: Mon, 29 Jul 2013 15:39:17 +0100
Message-ID: <20130729143916.GA20119@debian>
References: <CABmKtjcsZUbafxtmPb=2-Gkxz9PkFq7KVsQBqRkHduEn7aaqkw@mail.gmail.com>
 <51F48531.6040104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51F48531.6040104@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: sunnikrishnan@stec-inc.com, kmo@daterainc.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Jul 28, 2013 at 11:42:57AM +0900, Akira Hayakawa wrote:
> I wrote an introduction slide which is available in URL below:
> https://github.com/akiradeveloper/dm-lc/blob/develop/what-is-dm-lc.pdf
> access the page and click "view raw".

This is nicely orthogonal to dm-cache.

dm-cache tries to move a working set of fixed size blocks into a cache
to optimise both read and write.  dm-lc focusses solely on optimising
bursty writes and uses a journal based structure to accomodate
variable sized blocks.

The next step is to get some third party users to post their
experiences with it, and get some feedback on the code itself from
Mike Snitzer.

If I get time I'll integrate it with my test suite.

https://github.com/jthornber/device-mapper-test-suite


- Joe
