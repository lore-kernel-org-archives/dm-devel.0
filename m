From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: v4.3-rc2 dm-mq bug
Date: Tue, 29 Sep 2015 19:54:15 -0700
Message-ID: <560B4ED7.8020409@sandisk.com>
References: <56044A6E.90900@sandisk.com> <20150924211804.GA16328@redhat.com>
	<20150925003755.GA5984@xzibit.linux.bs1.fc.nec.co.jp>
	<56056A36.8060900@sandisk.com>
	<20150930004224.GB4857@xzibit.linux.bs1.fc.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150930004224.GB4857@xzibit.linux.bs1.fc.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 09/29/15 17:42, Junichi Nomura wrote:
> However, when I added scsi device removal and rescan to the mix
> the system crashed within a few seconds.  It looks like the change
> in v4.3-rc which integrates scsi_dh to scsi core introduced
> use-after-free.  I reported the problem to linux-scsi:
>    [REGRESSION v4.3] scsi_dh: use-after-free when removing scsi device
>    http://marc.info/?l=linux-scsi&m=144357350800712&w=2
>
> Though I'm not sure if it's related to your issue, just FYI.

Thanks a lot for your research !

Bart.
