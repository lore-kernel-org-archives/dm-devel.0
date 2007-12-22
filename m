From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: Snapshots
Date: Fri, 21 Dec 2007 20:28:05 -0500
Message-ID: <476C6825.7070701@ce.jp.nec.com>
References: <47682630.5060803@cfl.rr.com>	<47684BE3.5060408@ce.jp.nec.com>	<47694A05.9090202@cfl.rr.com>	<4769862D.6090403@ce.jp.nec.com>
	<476AC672.4030405@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <476AC672.4030405@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Phillip Susi wrote:
> Jun'ichi Nomura wrote:
>> So, you have to put the linear mapping *before* that.
>> Then, the top-level block device will be locked but you can
>> still change the underlying mappings.
> 
> So using a disk device as a dm target locks it.  DM won't use a disk
> device as a target if it is locked.

If a device is locked by a DM device on top of it,
other DM device can still use the device as a target.

Also, even if a DM device is locked by mount, you can still change
the table of the DM device.

> Are you saying that dm can use
> another dm device as a target, even if it is already locked by being
> used as another dm target?

I'm not sure if I understand your last sentence correctly.
Does the above comment answer to your question?

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
