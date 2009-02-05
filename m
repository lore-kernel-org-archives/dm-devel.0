From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Patchwork and patch flow
Date: Thu, 5 Feb 2009 16:12:19 -0600
Message-ID: <A5C05773-7C8F-4D59-B742-DBDC85799DFB@redhat.com>
References: <20090107025952.GH3512@agk.fab.redhat.com>
	<20090205.204508.71105166.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090205.204508.71105166.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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


On Feb 5, 2009, at 5:45 AM, Ryo Tsuruta wrote:

> Hi Alasdair,
>
>> I'd also like to see more people visibly reviewing and testing  
>> patches.
>> Please respond in the mailing list threads with comments and  
>> Reviewed-by: or
>> Tested-by: lines as appropriate.  If you've only reviewed part of  
>> the patch
>> or only tested a subset of the cases you think need testing,  
>> explain in the
>> thread but don't add those lines.  Only offer a Reviewed-by line if  
>> you have
>> performed a complete line-by-line review of the patch and patch  
>> header and
>> you support its inclusion in the tree.
>
> To add a Tested-by tag, how much test do we actually need?
> We've already done several tests of dm-ioband:
>  Proportional I/O bandwidth controlling
>  Loading/unloading driver and changing settings while under I/O load
>  Bounds checking of setting parameters
>  Benchmarks
> Do you think these are enough for adding the tag?
> It's very difficult for me to determine whether it's qualified or not.
> It would be helpful if you could give me some advice.

Interesting question...  If it was me, I'd like to see exactly what  
you wrote above.  State that you tested it and how you tested it.  If  
there are a number of people who test it and the things they describe  
offer a broad spectrum of tests, I think that's helpful.  Also, if  
extra testing is wanted, it can be suggested based on what tests have  
been performed.

  brassow
