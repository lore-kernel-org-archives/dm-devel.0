From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: dm: use revalidate_disk to update device size after
	set_capacity
Date: Fri, 29 Oct 2010 12:00:10 +0900
Message-ID: <4CCA38BA.3070406@ce.jp.nec.com>
References: <20101019220711.GA25169@redhat.com>
	<4CBE813B.6050105@ce.jp.nec.com>
	<20101028011658.GA13690@redhat.com>
	<4CC96970.7010903@ce.jp.nec.com>
	<20101028195432.GA23063@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101028195432.GA23063@redhat.com>
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

Hi Mike,

(10/29/10 04:54), Mike Snitzer wrote:
>> If __set_size() could be done in later stage of do_resume(),
>> we can use revalidate_disk() for dm, too.
>> What do you think?
> 
> I think it would be incorrect to make a new DM table live without first
> adjusting the size of the DM device to reflect the new table.  Could
> result in racing IO to the end of a device which would cause IO errors
> like "access beyond end of device".

Yes, but at that point, resume ioctl is still in progress.
Doesn't that mean "the resize is still in progress"?
If so, who cares that I/O while the resize is not yet completed?

> I'll cleanup the patch from my previous mail to include some in-code
> comments and re-post it.  Please ack it if you agree that direct use of
> bd_mutex in __set_size() is a reasonable fix given the current code.

My point is that it's better to avoid having a code with
special assumption on generic code, either "any codes don't do
I/O while holding bd_mutex" or "dm_resume is the only code
which calls i_size_write() for dm device".
I think it's prone for someone who don't care dm specifics
to introduce a new code that breaks such an assumption.

Anyway, I think your bd_mutex patch should be fine for now and
is better than the current code with i_mutex, which has a real deadlock issue.

-- 
Jun'ichi Nomura, NEC Corporation
