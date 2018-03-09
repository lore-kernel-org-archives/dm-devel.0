From: Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [PATCH] multipathd: check and cleanup zombie paths
Date: Fri, 9 Mar 2018 06:47:30 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A34295D215@H3CMLB14-EX.srv.huawei-3com.com>
References: <CEB9978CF3252343BE3C67AC9F0086A34295C462@H3CMLB14-EX.srv.huawei-3com.com>
	<1520325779.4131.4.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295C9D0@H3CMLB14-EX.srv.huawei-3com.com>
	<1520349519.4131.20.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CA7D@H3CMLB14-EX.srv.huawei-3com.com>
	<1520426679.11340.5.camel@suse.com>
	<CEB9978CF3252343BE3C67AC9F0086A34295CF62@H3CMLB14-EX.srv.huawei-3com.com>
	<20180308154435.GB14513@octiron.msp.redhat.com>
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
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: 'Xose Vazquez Perez' <xose.vazquez@gmail.com>, Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On 2018/3/8 23:45, Benjamin Marzinski wrote:
> On Thu, Mar 08, 2018 at 08:03:50AM +0000, Chongyun Wu wrote:
>> On 2018/3/7 20:45, Martin Wilck wrote:
>>> On Wed, 2018-03-07 at 01:45 +0000, Chongyun Wu wrote:
>>>>
>>>> Hi Martin,
>>>> Your analysis is correct. Did you have any good idea to deal with
>>>> this
>>>> issue?
>>>
>>> Could you maybe explain what was causing the issue in the first place?
>>> Did you reconfigure the storage in any particular way?
>>>
>>> If yes, I think "multipathd reconfigure" would be the correct way to
>>> deal with the problem. It re-reads everything, so it should get rid of
>>> the stale paths.
>>>
>>> Regards
>>> Martin
>>>
>>
>> I have used "multipathd reconfigure", but the zombie(or stale) still
>> here, even restart multipath-tools also can't clean those zombie paths.
>>
>> issue reproduce steps:
>> (1)export the LUN(LUN1) to the server(host1) form LUN value *6* in the
>> storage array;
>> (2)scan out LUN1 in host1 and create multipath;
>> (3)delete multipath in host1;
>> (4)unexport LUN1 to host1 in the storage array;
>> (5)export the LUN(LUN1) to the server(host1) form LUN value *3* in the
>> storage array;
>> (6)scan out LUN1 in host1 and create multipath, will see the zombie path
>> like below:
>> 360002ac000000000000004f40001e2d7 dm-5 3PARdata,VV
>> size=13G features='1 queue_if_no_path' hwhandler='0' wp=rw
>> `-+- policy='round-robin 0' prio=1 status=active
>>     |- 3:0:0:3 sdk 8:160 active ready running
>>     |- 4:0:0:3 sdn 8:208 active ready running
>>     |- 3:0:0:6 sdo 8:224 failed faulty running
>>     `- 4:0:0:6 sdp 8:240 failed faulty running
>> those zombie paths actually case by cancel the old export relation in
>> the storage array and change to a new export relation(given a different
>> LUN value, kernel will create a new device for it), the old device stay
>> in the system which I called zombie path or stable paths.
>>
>> I'm sorry that my first description isn't so clear and can be
>> misleading. The description *a lun can't be exported from a different
>> lun number to a host at the same time* actually not the reference to
>> found zombie paths. I have tested the storage haven't such restrict we
>> can export one LUN to server from different LUN number at the same time.
>> But my patch not care about this scenario, because the path which export
>> many times from different LUN number in the storage array  at the same
>> time will have the same path status(either faild or active).
> 
> If there are multiple routes to the storage, Some of them can be down,
> even if everything is fine on the storage.  This will cause some paths
> to be up and some to be down, regardless of the state of the LUN. In
> every other multipath case but this one, there is just one LUN, and not
> all the paths have the same state.
> 
> Ideally, there would be a way to determine if a path is a zombie, simply
> by looking at it alone.  The additional sense code "LOGICAL UNIT NOT
> SUPPORTED" that you posted earlier isn't one that I recall seeing for
> failed multipathd paths.  I'll check around more, but a quick look makes
> it appear that this code is only used when you are accessing a LUN that
> really isn't there. It's possible that the TUR checker could return a
> special path state for this, that would cause multipathd to remove the
> device.  Also, even if that additional sense code is only supposed to be
> used for this condition, we should still removing a device that returns
> it configurable, because I can almost guarantee that there will be a
> scsi device that does follow the standard for this.
> 
Hi Ben,
You just mentioned *the TUR checker could return a special path state 
for this*, what is the special path state?  Thanks~

> -Ben
>   
>> My previous patch use three conditions to found those paths:
>> (1)path status is faild;
>> (2)can found path which have the same wwid and different lun
>> number(pp->sg_id.lun) with the failed path ;
>> (3)the founded path's status is active.
>>
>> Based on your analysis of support for all devices, I want to restrict
>> the clean up just for scsi device.
>>
>> Above is my test result and reconsideration after your reply. Thanks a lot~
>>
>> Regards,
>> Chongyun
> 
