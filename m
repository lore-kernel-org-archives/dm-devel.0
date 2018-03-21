From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] multipathd: check and cleanup zombie paths
Date: Wed, 21 Mar 2018 19:56:04 +0000
Message-ID: <1521662163.2534.13.camel@wdc.com>
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
	<3537d472-27ad-53fd-7d13-229359a53849@gmail.com>
	<1521558853.3156.10.camel@wdc.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295E289@H3CMLB14-EX.srv.huawei-3com.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CEB9978CF3252343BE3C67AC9F0086A34295E289@H3CMLB14-EX.srv.huawei-3com.com>
Content-Language: en-US
Content-ID: <C0FD5803F0D06A47A5E02135436A6112@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>, "wu.chongyun@h3c.com" <wu.chongyun@h3c.com>, "bmarzins@redhat.com" <bmarzins@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
Cc: "guozhonghua@h3c.com" <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "changlimin@h3c.com" <changlimin@h3c.com>, "ge.changwei@h3c.com" <ge.changwei@h3c.com>
List-Id: dm-devel.ids

On Wed, 2018-03-21 at 01:54 +0000, Chongyun Wu wrote:
> Is there any special operation or conditions to reproduce the dead lock? 
>   I have use SCSI sysfs delete atrribute to remove stale devices in my 
> previous patch and test many times, but I haven't encountered any 
> deadlock problems.

Hello Chongyun,

In my tests I enabled the lock validator (CONFIG_LOCKDEP) in order not only
to obtain detailed information about the cause of actual deadlocks but also
to obtain information about potential deadlocks.

I'm not sure how to make it more likely to trigger this deadlock. But I think
that you should be aware that some SCSI transports remove the SCSI host if a
transport failure is detected and other SCSI transports don't remove the SCSI
host upon a transport failure. I ran my tests with the SRP protocol and the
SRP transport protocol removes the SCSI host if a transport failure persists
long enough. Maybe triggering SCSI host removal often helps to trigger that
deadlock.

Bart.
