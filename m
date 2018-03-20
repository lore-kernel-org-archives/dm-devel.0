From: Chongyun Wu <wu.chongyun@h3c.com>
Subject: Re: [PATCH] multipathd: check and cleanup zombie paths
Date: Tue, 20 Mar 2018 03:19:38 +0000
Message-ID: <CEB9978CF3252343BE3C67AC9F0086A34295DF37@H3CMLB14-EX.srv.huawei-3com.com>
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
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: 'Xose Vazquez Perez' <xose.vazquez@gmail.com>, Guozhonghua <guozhonghua@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Changwei Ge <ge.changwei@h3c.com>, Changlimin <changlimin@h3c.com>
List-Id: dm-devel.ids

On 2018/3/20 5:42, Martin Wilck wrote:
> On Fri, 2018-03-09 at 10:22 -0600, Benjamin Marzinski wrote:
>> On Fri, Mar 09, 2018 at 06:47:30AM +0000, Chongyun Wu wrote:
>>> On 2018/3/8 23:45, Benjamin Marzinski wrote:
>>>>
>>>> If there are multiple routes to the storage, Some of them can be
>>>> down,
>>>> even if everything is fine on the storage.  This will cause some
>>>> paths
>>>> to be up and some to be down, regardless of the state of the LUN.
>>>> In
>>>> every other multipath case but this one, there is just one LUN,
>>>> and not
>>>> all the paths have the same state.
>>>>
>>>> Ideally, there would be a way to determine if a path is a zombie,
>>>> simply
>>>> by looking at it alone.  The additional sense code "LOGICAL UNIT
>>>> NOT
>>>> SUPPORTED" that you posted earlier isn't one that I recall seeing
>>>> for
>>>> failed multipathd paths.  I'll check around more, but a quick
>>>> look makes
>>>> it appear that this code is only used when you are accessing a
>>>> LUN that
>>>> really isn't there. It's possible that the TUR checker could
>>>> return a
>>>> special path state for this, that would cause multipathd to
>>>> remove the
>>>> device.  Also, even if that additional sense code is only
>>>> supposed to be
>>>> used for this condition, we should still removing a device that
>>>> returns
>>>> it configurable, because I can almost guarantee that there will
>>>> be a
>>>> scsi device that does follow the standard for this.
>>>>
>>>
>>> Hi Ben,
>>> You just mentioned *the TUR checker could return a special path
>>> state
>>> for this*, what is the special path state?  Thanks~
>>>
>>
>> We would have to add a new state, like PATH_NOT_SUPPORTED, that the
>> TUR
>> checker could return in this case.  multipathd could be configured to
>> remove the path if it returned this state. If it wasn't configured to
>> do
>> so, multipathd would just change the state to PATH_DOWN.
> 
> Is it really multipathd's job to do remove devices that return "LOGICAL
> UNIT NOT SUPPORTED"? To me it sounds like a misconfiguration on the
> SCSI/storage level, and I'm unsure if that's a thing multipathd should
> mess with.
> 
> Martin
> 
Actually there are two scenario:
(1)Export the LUN to a server at the same time using different LUN nubmer.
As you mentioned this scenario can be considered a misconfiguration 
which we might not care about it.
(2)Export the LUN to a server not at the same time using different LUN 
number.
This scenario's operation may be right, the customer just want to 
reassignment the export relations in the storage.
But the former export operation leave a residual device in the system 
which will been adopted by the latter exported device's multipath. Also 
there are lots of syslog for the former device which actually not 
exist(at lest customer don't think it exists, the customer want only the 
new exported device exist)

Regards,
Chongyun
