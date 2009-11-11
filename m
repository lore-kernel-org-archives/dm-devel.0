From: Milan Broz <mbroz@redhat.com>
Subject: Re: dm: bind new table before destroying old
Date: Wed, 11 Nov 2009 16:14:59 +0100
Message-ID: <4AFAD4F3.8070505@redhat.com>
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
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Jun'ichi N
List-Id: dm-devel.ids

On 11/11/2009 04:11 PM, Alasdair G Kergon wrote:
> On Wed, Nov 11, 2009 at 03:56:05PM +0900, Kiyoshi Ueda wrote:
>> I believe dm-mpath needs to flush such workqueues in postsuspend.
> 
> Yes - should be an easy change.

similar problem is probably in crypt target, I'll check it later.

>> Also, we need something to block message ioctl to suspended device.
>  
>> As for the message ioctl, I don't have any good idea, but...
>>   - Reject message ioctl to suspended device in dm-ioctl
> 
> I think the crypt target expects to be able to do this to manipulate
> the in-core encryption key.

yes, crypt target must be able to process messages when in suspended state.

Milan
