From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 8/8] dm-mpath: do not activate failed paths
Date: Fri, 28 Feb 2014 16:08:43 +0100
Message-ID: <5310A67B.2070606@suse.de>
References: <1393486229-72034-1-git-send-email-hare@suse.de>
	<1393486229-72034-9-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784010D7C45@BPXM12GP.gisp.nec.co.jp>
	<531057A7.4020208@suse.de>
	<11AF7C027C4C02408624617A49860784010D7F79@BPXM12GP.gisp.nec.co.jp>
	<53105C4D.50305@suse.de> <20140228142230.GA1140@redhat.com>
	<5310A0C7.6000601@suse.de> <20140228150243.GB1140@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140228150243.GB1140@redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/28/2014 04:02 PM, Mike Snitzer wrote:
> On Fri, Feb 28 2014 at  9:44am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> =

>> On 02/28/2014 03:22 PM, Mike Snitzer wrote:
>> [ .. ]
>>>
>>> FYI, I still intend to review/take your "accept failed paths" patch.
>>> Would be helpful if any rebase is needed for that patch that you do so
>>> and re-post.
>>>
>>> One thing I noticed is you're only converting MAJ:MIN paths to devices.
>>> I think we should factor a helper out of DM core that does the full path
>>> lookup check from dm_get_device() -- rather than you open coding an
>>> older version of the MAJ:MIN device path processing.
>>>
>>> But is there a reason for not using lookup_bdev()?  Because the device
>>> is failed it cannot be found using lookup_bdev()?
>>>
>> Yes, that's precisely it.
>> When setting dev_loss_tmo very aggressively (to, say, 10 or even 5
>> seconds) it might well be that multipathd won't be able to keep up
>> with the events in time.
>> So by the time multipathd tries to push a new table into the kernel
>> (which contains major:minor numbers only) those devices are already
>> gone. So lookup_bdev() won't be able to find them, either.
> =

> Been talking this over with Alasdair.  Need some things clarified.
> =

> Are you needing to handle non-existent devices during initial mpath
> table load?
> =

> Or is the failed path in question already part of the active mpath table
> -- so active table currently holds a reference to the device?
> =

> Or do you need to support both cases?  Sounds like you want to support
> both cases..
> =

Hmm. I wouldn't think I'd need it during initial mpath table load;
but then you never now, devices might fail faster than you'd think ...

So yeah, I'd need to support both cases.

The main reason why I've sent this patch is to get rid of these
_really_ annoying messages 'error getting device' during failover.
We really should and can do better than that.

That this patch allows to drop references to failed devices earlier
is a nice side effect :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
