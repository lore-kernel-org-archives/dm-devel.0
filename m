From: Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [PATCH] multipathd: check and cleanup zombie paths
Date: Fri, 9 Mar 2018 06:11:31 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A34295D1BD@H3CMLB14-EX.srv.huawei-3com.com>
References: <CEB9978CF3252343BE3C67AC9F0086A34295C462@H3CMLB14-EX.srv.huawei-3com.com>
	<1520325779.4131.4.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295C9D0@H3CMLB14-EX.srv.huawei-3com.com>
	<1520349519.4131.20.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CA7D@H3CMLB14-EX.srv.huawei-3com.com>
	<1520426679.11340.5.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CF62@H3CMLB14-EX.srv.huawei-3com.com>
	<c9dc3387-4279-b2ca-2f8b-f63972dc4a06@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 'Christophe
	Varoqui' <christophe.varoqui@opensvc.com>, 'Hannes Reinecke' <hare@suse.de>
Cc: Guozhonghua <guozhonghua@h3c.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2018/3/8 23:54, Xose Vazquez Perez wrote:
> On 03/08/2018 09:03 AM, Chongyun Wu wrote:
> 
> [add dm-devel@redhat.com]
> 
>> 360002ac000000000000004f40001e2d7 dm-5 3PARdata,VV
>> size=13G features='1 queue_if_no_path' hwhandler='0' wp=rw
>> `-+- policy='round-robin 0' prio=1 status=active
>>     |- 3:0:0:3 sdk 8:160 active ready running
>>     |- 4:0:0:3 sdn 8:208 active ready running
>>     |- 3:0:0:6 sdo 8:224 failed faulty running
>>     `- 4:0:0:6 sdp 8:240 failed faulty running
> 3PAR arrays are able to use ALUA, but with *all ports*
> *across all controllers* in *single Target Port Group* :
> 
> 31000000000000a000000000000001000 dm-0 3PARdata,VV
> size=50G features='2 queue_if_no_path retain_attached_hw_handler' hwhandler='1 alua' wp=rw
> `-+- policy='service-time 0' prio=50 status=active
>    |- 0:0:0:0 sda 8:0   active ready running
>    |- 0:0:1:0 sdf 8:80  active ready running
>    |- 1:0:0:0 sdk 8:160 active ready running
>    `- 1:0:1:0 sdp 8:240 active ready running
> 
> And it's recommended by the manufacturer.
> 
> 
>  From the StoreServ Management Console "Host:" should be changed to
> "Generic-ALUA" "Persona 2" "(UARepLun, SESLun, ALUA)".
> 
> multipath-tools( *upstream* ) is already configured by default to use ALUA
> with 3PARdata, since c1b7f7f7: https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commitdiff;h=c1b7f7f7
> 
> Run "multipath -d -v3" to see the config by lun.
> 
Hi Xose Vazquez Perez,

Thanks for your reminding, I will check it, thanks again~

Regards,
Chongyun
