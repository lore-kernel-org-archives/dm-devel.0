From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Thu, 29 Jan 2009 16:18:59 +0900
Message-ID: <49815863.8040806@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
	<20090128154019.GB23158@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090128154019.GB23158@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

On 01/29/2009 12:40 AM +0900, Alasdair G Kergon wrote:
> On Fri, Oct 03, 2008 at 11:08:25AM -0400, Kiyoshi Ueda wrote:
>> This patch-set is the updated version of request-based dm-multipath.
>> The changes from the previous version (*) are to follow up the change
>> of the interface to export lld's busy state (PATCH 5).
> 
> I've fixed them up to compile again, but haven't thoroughly checked for
> side-effects.

I found some problems below in my patches and now considering
how to fix them:
  o Unnecessary EIO is returned to application if it submits
    a bio during table swapping.
  o kernel panic occurs by frequent table swapping during heavy I/Os.
 
I'll post the fixed version after my vacation.

Thanks,
Kiyoshi Ueda
