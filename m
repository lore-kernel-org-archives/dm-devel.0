From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: v4.3-rc2 dm-mq bug
Date: Thu, 24 Sep 2015 19:01:03 -0400
Message-ID: <20150924230103.GA17394@redhat.com>
References: <56044A6E.90900@sandisk.com> <20150924211804.GA16328@redhat.com>
	<56046AD7.7080400@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56046AD7.7080400@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Sep 24 2015 at  5:27pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 09/24/2015 02:18 PM, Mike Snitzer wrote:
> >p.s. Bart, why is your test destroying the DM mpath device while it is
> >issuing IO to the device? ;)
> 
> Removing SCSI device instances created by the SRP initiator while
> I/O is being submitted is a great way to stress-test the SRP
> initiator driver but apparently the test I'm running triggers bugs
> in other drivers than the SRP initiator driver ...

I'm not referring to the removal of a DM mpath device's underlying SRP
paths.  The __dm_destroy() path is only used when destroying a DM
device.  The only DM device used by multipath is the DM mpath device.

So somehow your test is running the equivalent of:
 dmsetup remove <toplevel_DM_mpath_device>

While IO is being issued directly to that device.
