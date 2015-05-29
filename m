From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: 4.1-rc2 dm-multipath-mq kernel warning
Date: Fri, 29 May 2015 12:04:23 +0200
Message-ID: <556839A7.9020307@sandisk.com>
References: <20150527125732.GA15911@redhat.com> <5565E2EA.2000302@sandisk.com>
	<5565E3E3.4080801@sandisk.com> <20150527161415.GA22520@redhat.com>
	<20150527170001.GA22548@redhat.com>	<20150527223741.GA18501@redhat.com>
	<5566CFAB.7060408@sandisk.com>	<20150528131051.GA22527@redhat.com>
	<20150528140702.GA25917@redhat.com> <55672C11.2080809@sandisk.com>
	<20150528150645.GA23017@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150528150645.GA23017@redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On 05/28/15 17:06, Mike Snitzer wrote:
> So you can confirm that with dm-4.1 your test passes?  If possible
> please try your test a fews times.  Also, if time permits, please vary
> scsi-mq and dm-mq enable/disable (4 permutations) to make sure all
> supported modes pass your SRP torture test.
>
> I just have to review Junichi's patch from today to silence the WARN_ON
> I added; once I work through that I'll likely send dm-4.1 to Linus.

Hello Mike,

Good news: with the latest dm-4.1 branch and with both scsi-mq and dm-mq 
enabled my SRP fail-over test passes.

Thanks,

Bart.
