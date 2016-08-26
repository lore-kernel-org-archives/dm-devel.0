From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH RFC] dm: Fix a bio leak in dec_pending()
Date: Fri, 26 Aug 2016 08:34:49 -0700
Message-ID: <b122a926-6124-34d0-0a82-b2eac3da575e@sandisk.com>
References: <1e64fe53-ed57-ef97-a077-19a153506e63@sandisk.com>
	<20160826145740.GB1876@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160826145740.GB1876@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

On 08/26/2016 07:57 AM, Mike Snitzer wrote:
> On Thu, Aug 25 2016 at  4:57pm -0400,
> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>
>> Ensure that bio_endio() is called if io->error == DM_ENDIO_REQUEUE and
>> __noflush_suspending(md) returns false. Posting this as an RFC since I'm
>> not really familiar with the dm code.
>>
>> Fixes: commit 2e93ccc1933d ("dm: suspend: add noflush pushback")
>> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
>
> I did reinstate bio-based multipath recently.  But I just want to make
> sure: you realize that dec_pending() is only ever used by bio-based DM
> right? (dm-mq and .request_fn multipath are request-based)

Hello Mike,

Yes, I am aware that this code is not triggered by my tests. This is 
something I noticed while reading the dm source code and something I 
wanted to report.

Bart.
