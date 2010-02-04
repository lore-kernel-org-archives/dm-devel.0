From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 3/4] dm-mpath: separate pg-init handling from
	process_queued_ios()
Date: Thu, 04 Feb 2010 19:31:15 +0900
Message-ID: <4B6AA1F3.5030206@ct.jp.nec.com>
References: <4B665507.8080205@ct.jp.nec.com> <4B6656FF.5000701@ct.jp.nec.com>
	<20100202182437.GI864@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100202182437.GI864@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

Thanks for your review and comments.

On 02/03/2010 03:24 AM +0900, Alasdair G Kergon wrote:
> On Mon, Feb 01, 2010 at 01:22:23PM +0900, Kiyoshi Ueda wrote:
>> This patch is a preparation of the next patch, which fixes the issue
>> that ioctl isn't processed until any I/O is issued.  (And also it is
>> a preparation of another patch-set to remove multipath internal queue.)
>> No functional change.
>  
> I've split this into two, but it's very 'tight' code forming a state
> machine here, and while I understand the principle of the patch, I can't
> spot an easy way to tell that all the paths through the code are right.
> Is it worth trying to extend the explanation, or will later patches be
> replacing this code, making it better to wait for that new code before
> reviewing?
> 
>   ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing/patches/dm-mpath-refactor-pg_init-trigger.patch

While trying to extend the explanation, I come to think there may be
better implementation for pg_init refactoring.
So please wait reviewing dm-mpath-refactor-pg_init-trigger.patch until
my next update.
(I think dm-mpath-refactor-pg_init.patch is no problem to apply even
 at this point.)

Thanks,
Kiyoshi Ueda
