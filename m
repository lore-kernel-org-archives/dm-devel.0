From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: 4.1-rc2 dm-multipath-mq kernel warning
Date: Wed, 27 May 2015 17:29:46 +0200
Message-ID: <5565E2EA.2000302@sandisk.com>
References: <5548CDE5.9@sandisk.com> <20150506022332.GA12096@redhat.com>
	<5549C68E.2050705@sandisk.com> <20150506182942.GA15545@redhat.com>
	<554B3C22.4060305@sandisk.com> <20150527125732.GA15911@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150527125732.GA15911@redhat.com>
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

On 05/27/15 14:57, Mike Snitzer wrote:
> Looks like Junichi likely fixed this issue you reported, please try this
> patch: https://patchwork.kernel.org/patch/6487321/

Hello Mike,

On a setup on which an I/O verification test passes with 
blk-mq/scsi-mq/dm-mq disabled, this is what fio reports after a few 
minutes with scsi-mq and dm-mq enabled:

test: Laying out IO file(s) (1 file(s) / 10MB)
fio: io_u error on file /mnt/test.0.0: Input/output error: write 
offset=8327168, buflen=4096
fio: io_u error on file /mnt/test.0.0: Input/output error: write 
offset=9007104, buflen=4096
fio: pid=4568, err=5/file:io_u.c:1564, func=io_u error, 
error=Input/output error

Bart.
