From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipathd: check and cleanup zombie paths
Date: Tue, 20 Mar 2018 16:12:17 +0100
Message-ID: <3537d472-27ad-53fd-7d13-229359a53849@gmail.com>
References: <CEB9978CF3252343BE3C67AC9F0086A34295C462@H3CMLB14-EX.srv.huawei-3com.com>
	<1520325779.4131.4.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295C9D0@H3CMLB14-EX.srv.huawei-3com.com>
	<1520349519.4131.20.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CA7D@H3CMLB14-EX.srv.huawei-3com.com>
	<1520426679.11340.5.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CF62@H3CMLB14-EX.srv.huawei-3com.com>
	<20180308154435.GB14513@octiron.msp.redhat.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295D215@H3CMLB14-EX.srv.huawei-3com.com>
	<20180309162243.GE14513@octiron.msp.redhat.com>
	<1521495726.3798.141.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295DF37@H3CMLB14-EX.srv.huawei-3com.com>
	<1521557887.3156.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1521557887.3156.5.camel@wdc.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "wu.chongyun@h3c.com" <wu.chongyun@h3c.com>, "mwilck@suse.com" <mwilck@suse.com>
Cc: "guozhonghua@h3c.com" <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "changlimin@h3c.com" <changlimin@h3c.com>, "ge.changwei@h3c.com" <ge.changwei@h3c.com>
List-Id: dm-devel.ids

On 03/20/2018 03:58 PM, Bart Van Assche wrote:

> It is on purpose that the SCSI core does not remove stale SCSI device nodes.
> If you want that these stale SCSI device nodes get removed automatically,
> two possible approaches are (there might be other approaches):
> * Write a new user space daemon that periodically checks for stale devices
>   (e.g. by running grep -aH . /sys/class/scsi_device/*/*/state |
>    grep -v running) and that triggers a SCSI rescan if any stale devices are
>   found.
> * Write a udev rule that listens for SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED
>   and that triggers a SCSI rescan if this event is triggered by the kernel.

There are some "remove" flags in rescan-scsi-bus.sh:
https://github.com/hreinecke/sg3_utils/blob/d4dbbede04db21c206e4c2acc1cf766117f003c3/scripts/rescan-scsi-bus.sh#L1080

-r      enables removing of devices        [default: disabled]
--forceremove:   Remove stale devices (DANGEROUS)
--forcerescan:   Remove and readd existing devices (DANGEROUS)
