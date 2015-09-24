From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: v4.3-rc2 dm-mq bug
Date: Thu, 24 Sep 2015 14:27:51 -0700
Message-ID: <56046AD7.7080400@sandisk.com>
References: <56044A6E.90900@sandisk.com> <20150924211804.GA16328@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150924211804.GA16328@redhat.com>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 09/24/2015 02:18 PM, Mike Snitzer wrote:
> p.s. Bart, why is your test destroying the DM mpath device while it is
> issuing IO to the device? ;)

Removing SCSI device instances created by the SRP initiator while I/O is 
being submitted is a great way to stress-test the SRP initiator driver 
but apparently the test I'm running triggers bugs in other drivers than 
the SRP initiator driver ...

Bart.
