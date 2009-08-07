From: Akshay Lal <alal@cleversafe.com>
Subject: Re: User specific priorities on for iscsi paths doesn't
	seem to	work
Date: Fri, 07 Aug 2009 16:28:12 -0500
Message-ID: <4A7C9C6C.3070204@cleversafe.com>
References: <4A7C8DB4.1090608@cleversafe.com>
	<20090807204304.GA1181@redhat.com>
	<4A7C9799.5090904@cleversafe.com>
	<20090807212104.GA1419@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090807212104.GA1419@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, John Quigley <jquigley@cleversafe.com>
List-Id: dm-devel.ids

Mike Snitzer wrote:
> On Fri, Aug 07 2009 at  5:07pm -0400,
> Akshay Lal <alal@cleversafe.com> wrote:
>
>   
>> Mike Snitzer wrote:
>>     
>>> On Fri, Aug 07 2009 at  4:25pm -0400,
>>> Akshay Lal <alal@cleversafe.com> wrote:
>>>
>>>   
>>>       
>>>> I'm having a few issues with path priorities. It seems that the 
>>>> choice  of path to use during I/O is independent of the user defined 
>>>> priorities  for each path.
>>>>
>>>> I am setting the priorities by executing writing a script that is 
>>>> used  by prio_callout. This seems to work when I execute multipath 
>>>> -ll since  all the specified priorities show up correctly. (the   
>>>> path_grouping_policy being used is  failover)
>>>>     
>>>>         
>>> ...
>>>
>>>   
>>>       
>>>> Is there something I'm doing wrong? I would like to be able to define 
>>>>  the priorities per device, and ensure that data only traverses on 
>>>> the  lower priority path when
>>>> a) a failure to the first path (path with a higher priority) occures
>>>> b) no other path with a higher priority exists
>>>>     
>>>>         
>>> Do things behave as you'd like if you change path_grouping_policy to
>>> 'group_by_prio'?
>>>
>>> Mike
>>>   
>>>       
>
>
>   
>> Mike:
>>
>> It seems that if I were to set the path_grouping_policy to  
>> "group_by_prio", then it seems to be working similar to a multibus  
>> configuration. What I would like is for within a single multipath group,  
>> (say mpath1), specify a primary path and an alternate/failover path. If  
>> I can make this configurable via user land tool that'd be great. In this  
>> vein, I had considered priorities with hope that if I can set the  
>> priority of a certain path within a group then the path with the highest  
>> priority will always be chosen and the other path (with the lower  
>> priority) will only come into play when the primary goes down.
>>
>> Below is the output of the multipath -ll & conf file when setting the  
>> path_grouping_policy to group_by_prio.
>>
>>
>> multipath -ll:
>> --------------
>> mpath2 (244534e3833623961) dm-1 DSNET,Dispersed Store
>> [size=47G][features=1 queue_if_no_path][hwhandler=0][rw]
>> \_ round-robin 0 [prio=15][enabled]
>> \_ 85:0:0:0 sdc 8:32  [active][ready]
>> \_ 87:0:0:0 sde 8:64  [active][ready]
>> mpath1 (244534e3266616134) dm-0 DSNET,Dispersed Store
>> [size=47G][features=1 queue_if_no_path][hwhandler=0][rw]
>> \_ round-robin 0 [prio=15][active]
>> \_ 84:0:0:0 sdb 8:16  [active][ready]
>> \_ 86:0:0:0 sdd 8:48  [active][ready]
>>
>>
>> /etc/multipath.conf:
>> --------------------
>> defaults {
>>        udev_dir                /dev
>>        polling_interval        1
>>        selector                "round-robin 0"
>>        path_grouping_policy    group_by_prio
>>        getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>>        prio_callout            "/bin/bash  
>> /root/MultipathScripts/mpath_prio_alt %n"
>>        path_checker            tur
>>        rr_min_io               128
>>        max_fds                 8192
>>        rr_weight               priorities
>>        failback                immediate
>>        no_path_retry           queue
>>        user_friendly_names     yes
>> }
>>     
>
>
> Please don't top-post.
>
> I'm pretty sure John meant to say "group_by_prio" rather than "failover"
> in his initial reply to this thread.  John originally got this insight
> (dummy device section et. al. applies to RHEL 5.3) back in April:
>
> https://www.redhat.com/archives/dm-devel/2009-April/msg00157.html
>
> Which multipath/distro are you using?
>
> Mike
>   

I tried out John's approach as well and it still seems to be giving me 
the similar results to what I mentioned before, i.e., replicating multibus


Priority list:
--------------
192.168.7.103:3260-iscsi-iqn.2008-07.com.cleversafe:vault-2    5
192.168.7.106:3260-iscsi-iqn.2008-07.com.cleversafe:vault-2    10
192.168.7.103:3260-iscsi-iqn.2008-07.com.cleversafe:vault-1    10
192.168.7.106:3260-iscsi-iqn.2008-07.com.cleversafe:vault-1    5

iSCSI disk associated with iSCSI sessions:
------------------------------------------
Target: iqn.2008-07.com.cleversafe:vault-1
    Current Portal: 192.168.7.106:3260,1
    Persistent Portal: 192.168.7.106:3260,1
            Attached scsi disk sdb        State: running
    Current Portal: 192.168.7.103:3260,1
    Persistent Portal: 192.168.7.103:3260,1
            Attached scsi disk sdd        State: running

Target: iqn.2008-07.com.cleversafe:vault-2
    Current Portal: 192.168.7.106:3260,1
    Persistent Portal: 192.168.7.106:3260,1
            Attached scsi disk sdc        State: running
    Current Portal: 192.168.7.103:3260,1
    Persistent Portal: 192.168.7.103:3260,1
            Attached scsi disk sde        State: running


multipath -ll:
---------------
mpath2 (244534e3833623961) dm-1 DSNET,Dispersed Store
[size=47G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=15][enabled]
 \_ 85:0:0:0 sdc 8:32  [active][ready]
 \_ 87:0:0:0 sde 8:64  [active][ready]
mpath1 (244534e3266616134) dm-0 DSNET,Dispersed Store
[size=47G][features=1 queue_if_no_path][hwhandler=0][rw]
\_ round-robin 0 [prio=15][enabled]
 \_ 84:0:0:0 sdb 8:16  [active][ready]
 \_ 86:0:0:0 sdd 8:48  [active][ready]



Versions being used:
dm-multipath: device-mapper-multipath-0.4.7-23.el5_3.4
kernel: 2.6.29.6
