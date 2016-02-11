From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] [dm-cache] Make the mq policy an alias for
	smq
Date: Thu, 11 Feb 2016 15:32:43 -0500
Message-ID: <22204.61419.400638.37964@quad.stoffel.home>
References: <1455100523-16922-1-git-send-email-ejt@redhat.com>
	<22203.28152.788363.168128@quad.stoffel.home>
	<20160211101001.GA4908@rh-vpn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160211101001.GA4908@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, John Stoffel <john@stoffel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

>>>>> "Joe" == Joe Thornber <thornber@redhat.com> writes:

Joe> On Wed, Feb 10, 2016 at 12:06:00PM -0500, John Stoffel wrote:
>> 
>> Can you add in some documentation on how you tell which dm_cache
>> policy is actually being used, and how to measure it, etc?  It's a
>> black box and some info would be nice.

Joe> You can get some stats on the cache performance via the status
Joe> ioctl (eg, dmsetup status ...).  This will tell you about
Joe> promotions/demotion to the cache, write hits, read hits etc.

I've looked at this output, but I can't make heads nor tail of it, nor
does the docs (v4.4-rc7) seem to provide any useful headings.

    # dmsetup --manglename none status --target cache
    data-home: 0 1153433600 cache 8 2443/32768 128 819200/819200 379170
    190334 1010554 121237 232 232 0 1 writeback 2 migration_threshold 2048
    smq 0 rw -
    data-local: 0 702545920 cache 8 2443/32768 128 804148/819200 574195
    28503 81586 19118 0 85798 0 1 writeback 2 migration_threshold 2048 smq
    0 rw -

But at least I see that I'm using smq for my cache policy.  

Joe> There is documentation on cache policies in
Joe> Documentation/device-mapper/cache-policies.txt

Joe> https://github.com/jthornber/linux-2.6/blob/2016-02-10-thin-dev-on-4.4/Documentation/device-mapper/cache-policies.txt

Joe> As for knowing which policy is running; I'm not sure what to say.
Joe> It'll be the one you ask for.  If the above patch goes in, then
Joe> there'll be a kernel version where mq becomes the same as smq.
Joe> I'll bump the policy version number to make it clear that mq has
Joe> undergone a big change.

I never explicitly asked for any policy when using lvcache, so that's
why I was asking.  *grin*

Using the -c or -C options doesn't really change things.  I see
there's a --noheadings option, but that's not useful without the
inverse --headings option so I can figure out what the results mean
without looking into the kernel source code.

Should I pull down the source and try to make up a patch for this
case?

John
