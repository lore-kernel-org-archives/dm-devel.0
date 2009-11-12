From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: dm: bind new table before destroying old
Date: Thu, 12 Nov 2009 18:59:20 +0900
Message-ID: <4AFBDC78.5040801@ct.jp.nec.com>
References: <20091111011652.GK17055@agk-dp.fab.redhat.com>
	<4AFA6005.9060501@ct.jp.nec.com>
	<20091111151110.GO17055@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091111151110.GO17055@agk-dp.fab.redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi Alasdair,

On 11/12/2009 12:11 AM +0900, Alasdair G Kergon wrote:
> On Wed, Nov 11, 2009 at 03:56:05PM +0900, Kiyoshi Ueda wrote:
>> I believe dm-mpath needs to flush such workqueues in postsuspend.
> 
> Yes - should be an easy change.

OK, I posted the patch.
See: http://patchwork.kernel.org/patch/59556/


>> Also, we need something to block message ioctl to suspended device.
>  
>> As for the message ioctl, I don't have any good idea, but...
>>   - Reject message ioctl to suspended device in dm-ioctl
> 
> I think the crypt target expects to be able to do this to manipulate
> the in-core encryption key.
> 
>>   - Targets must not kick any work influencing external themselves
>>     in their message ioctl handlers.
> 
> So I think we'll need a target-specific approach like that here.

OK, Mike Anderson seems to be working on this.

Thanks,
Kiyoshi Ueda
