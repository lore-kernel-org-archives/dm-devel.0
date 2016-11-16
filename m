From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 0/7] dm-mpath: Fix a race condition in the
	blk-mq path
Date: Tue, 15 Nov 2016 16:57:06 -0800
Message-ID: <51cae932-470e-aa27-8c7d-e33ed978f37e@sandisk.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<20161116004752.GD19059@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161116004752.GD19059@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/15/2016 04:47 PM, Mike Snitzer wrote:
> On Tue, Nov 15 2016 at  6:31pm -0500,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>> The seven patches in this series is what I came up with while
>> reviewing and testing the dm-mpath single queue and multiqueue code.
>> It would be appreciated if these patches would be considered for
>> inclusion in the upstream kernel.
>
> This series seems like it is not a product of need.  But that of changes
> that fell out from code review.
>
> If not, what test was failing that now passes with this patchset?

Hello Mike,

Without this patch series I see sporadic I/O errors when running I/O on 
top of dm-mq-on-mq. With this patch series my dm-mq-on-mq tests pass. 
However, I still see sporadic I/O errors being reported when I run I/O 
on top of dm-sq-on-mq and very sporadic I/O errors with my dm-sq-on-sq 
tests. It is not yet clear to me what is causing these I/O errors but 
it's probably something in either the dm core or the dm-mpath driver. My 
tests scripts are available at https://github.com/bvanassche/srp-test in 
case you would like to have a look.

Bart.
