From: Ming-Hung Tsai <mingnus@gmail.com>
Subject: Re: [PATCH] thin_dump: added --device-id, --skip-mappings,
 and new output --format's
Date: Sun, 20 Mar 2016 23:59:09 +0800
Message-ID: <CAAYit8RG-xgY=jxcmVG3tGdUSN93GGJ=KCKkGQsxL_SwAjjY0Q@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
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

I think that the --device-id option is required for thin_dump, but the
necessity of --skip-mappings could be discussed. If thin_ls supports
--device-id, then thin_dump might not require --skip-mappings.

I put my code here for reference (based on v0.7-devel)
https://github.com/mingnus/thin-provisioning-tools/commits/v0.7-thin_dump-enhancement
I borrow the option name "--skip-mappings" and function name
"set_skip_mappings" from Eric, since that they sounds more clear.

Build method:
# autoconf; ./configure --enable-dev-tools; make

My use cases:
# thin_dump --device-id=<dev_id> --format=<f> [--skip-mappings]


Ming-Hung Tsai
