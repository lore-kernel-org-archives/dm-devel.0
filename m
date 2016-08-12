From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 2/4] multipath-tools: add checker callout to
 repair path
Date: Fri, 12 Aug 2016 11:54:38 -0500
Message-ID: <57ADFF4E.2070604@redhat.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
	<1470657710-28081-3-git-send-email-mchristi@redhat.com>
	<9d5dcfcd-2550-c9e9-94dc-47c34ebdb039@sandisk.com>
	<57ACE12F.20700@redhat.com>
	<e4286ca9-01cb-5cc0-2d67-38f68c0a19cb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e4286ca9-01cb-5cc0-2d67-38f68c0a19cb@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 08/11/2016 04:41 PM, Bart Van Assche wrote:
> On 08/11/2016 01:33 PM, Mike Christie wrote:
>> Could you try the attached patch. I found two segfaults. If check_path
>> returns less than 0 then we free the path and so we cannot call repair
>> on it. If libcheck_init fails it memsets the checker, so we cannot call
>> repair on it too.
>>
>> I moved the repair call to the specific paths that the path is down.
> 
> Hello Mike,
> 
> Thanks for the patch. Unfortunately even with this patch applied I can
> still trigger a segfault sporadically:
> 

I can't seem to replicate the problem with my patch and I do not see
anything. Could you send me your multipath.conf/hwtable settings?

For the fo/fb test, dev_loss_tmo is firing causing paths to be
added/deleted right?
