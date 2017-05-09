From: Keith Busch <keith.busch@intel.com>
Subject: Re: dm: submit stacked requests in irq enabled context
Date: Tue, 9 May 2017 11:55:55 -0400
Message-ID: <20170509155555.GB2572@localhost.localdomain>
References: <a66b6e17-a8c4-3465-fc2e-c3114abe0ca7@codeaurora.org>
	<dee12838-7b43-2fdd-0644-41c10ecf9148@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <dee12838-7b43-2fdd-0644-41c10ecf9148@codeaurora.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neeraj Soni <neersoni@codeaurora.org>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

On Tue, May 09, 2017 at 03:19:31PM +0530, Neeraj Soni wrote:
>    + Alasdair and dm-devel for awareness and inputs.
> 
>    On 5/9/2017 12:26 PM, Neeraj Soni wrote:
> 
>      Hi Keith/Snitzer,
> 
>      I have recently started using kernel 4.4 on a Android device and ran
>      Androbench to check storage read/write performance. I found that the
>      Random Read (RR) and Random write(RW) performance with Full Disk
>      Encryption is degraded compared to no Disk Encryption. Initially i
>      thought this must the issue with the storage part used and i compared
>      the performance of similar storage part on a device that was using
>      Android with kernel 3.18. I found that with no Disk Encryption the
>      performance was equivalent to the device which was using 4.4 but with
>      Disk Encryption there was degradation in RR (~20%) and RW(10%).
> 
>      I then tried to compare the changes that was brought in kernel 4.4 in
>      Full Disk Encryption path. I came across the patch mentioned in subject
>      and found that now a worker thread is scheduled in dm_request_fn() to
>      process the requests instead of directly invoking map_request() as was
>      in kernel 3.18.
> 
>      I reverted this patch and found that the RR and RW performance was now
>      closer to what we have without Disk Encryption. From the commit message
>      i understand that this change is significant and will be required for
>      blk-mq support but have you came across such degradation issue with your
>      patch and do we have any fix for this degradation available?

Just for comparison, could you check performance on a more recent stable
kernel?
