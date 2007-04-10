From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-core-add-ratelimit-printing.patch
Date: Tue, 10 Apr 2007 00:17:33 -0500
Message-ID: <D960F8C5-BAD5-42E2-BFCC-F2B9DEEB420C@redhat.com>
References: <1175791012.24640.6.camel@hydrogen.msp.redhat.com>
	<200704091923.55986.okir@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200704091923.55986.okir@lst.de>
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

hmmm, yes.  that was stupid.

  brassow

On Apr 9, 2007, at 12:23 PM, Olaf Kirch wrote:

> On Thursday 05 April 2007 18:36, Jonathan Brassow wrote:
>>  #define DMERR(f, arg...) printk(KERN_ERR DM_NAME ": "  
>> DM_MSG_PREFIX ": " f "\n", ## arg)
>> +#define DMERR_LIMIT(f, arg...) \
>> +	if (printk_ratelimit())	\
>> +		printk(KERN_ERR DM_NAME ": " DM_MSG_PREFIX ": " f "\n", ## arg)
>
> I would put a "do { ... } while (0)" around this, else you end up  
> with nasty surprises
> if it's used as in "if (..) DMERR_LIMIT(..) else do_something"
>
> Olaf
> -- 
> Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
> okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
