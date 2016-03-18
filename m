From: Ming-Hung Tsai <mingnus@gmail.com>
Subject: Re: [PATCH] thin_dump: added --device-id, --skip-mappings,
 and new output --format's
Date: Fri, 18 Mar 2016 10:04:37 +0800
Message-ID: <CAAYit8RgumGtcx7qRLKtiW=F++e76SKeKPSyB_=joL+Rjr8C_Q@mail.gmail.com>
References: <alpine.LRH.2.11.1603150104370.19675@mail.ewheeler.net>
	<20160317154553.GC4033@rh-vpn>
	<alpine.LRH.2.11.1603172245520.21357@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1603172245520.21357@mail.ewheeler.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

2016-03-18 6:45 GMT+08:00 Eric Wheeler <dm-devel@lists.ewheeler.net>:
>
> On Thu, 17 Mar 2016, Joe Thornber wrote:
>
>> If you're skipping the mappings does the new thin_ls provide enough
>> information for you?
>
> Our primary need is the ability to specify --device-id in the o:L:d output
> format (old_format.cc) with mappings.  Our nightly dumps now take 50
> seconds instead of 40 minutes since we only dump the dev_id's that we
> need.
>
> As for thin_ls, we're still in the 0.5.x branch, I couldn't get 0.6.x to
> build on el7:
>
> # git checkout v0.6.2-rc6
> Previous HEAD position was e46bdfd... v0.6.1
> HEAD is now at afb71d8... bump version
>
> # ./configure
> [...]
>
> # make
>     [CXX] base/application.cc
> g++: error: @LFS_FLAGS@: No such file or directory
> make: *** [base/application.o] Error 1
>
>
> Am I missing something trivial here?

Did you run autoconf to regenerate the configure script ? v0.6.x has
some changes in the configure script.

# make distclean
# autoconf
# ./configure
# make


Ming-Hung Tsai
