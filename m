From: Rudy Gevaert <Rudy.Gevaert@UGent.be>
Subject: Re: unmapping luns doesn't work (good)
Date: Wed, 27 Oct 2010 15:26:32 +0200
Message-ID: <4CC82888.90505@UGent.be>
References: <B2FD678A64EAAD45B089B123FDFC3ED704BFE2C0@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED704BFE2C0@inbmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Vijay,

On 10/22/2010 10:35 AM, Chauhan, Vijay wrote:
>
> On Thur, October 21, 2010 8:22 PM, Rudy Gevaert wrote:
>> On 10/21/2010 09:28 AM, Chauhan, Vijay wrote:
>>
>>> Try with disabling the queuing before removing the map.
>>>
>>> dmsetup message mail14r-ds3400-1 0 "fail_if_no_path"
>>
>> Hi
>>
>> When I do that, and then unmap the lun.
>>
>> If I then rescan an issue multipath I get:
>>
>> root@cyrprd1:~# multipath
>> create: 1                 undef IBM,1726-4xx  FAStT
>> size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=undef
>> `-+- policy='round-robin 0' prio=0 status=undef
>>     |- 0:0:0:3 sdd 8:48  undef faulty running
>>     `- 5:0:0:3 sdl 8:176 undef faulty running
>> <hang>
>>
>>
>
> You may not get into this issue if you follow these steps:
>
> step 1) Delete the paths for the dm device to be unmapped. (Ensure that this dm device is not being used for IO)
> 	  Once the last path is deleted, multipathd will remove this map.
>
> step 2) Unmap the LUN from storage.
>
> Hope this helps.
>
> Regards,
> Vijay

Unfortunately I then get up with:
root@cyrprd3:~# multipath -l
1                 dm-3 IBM,1726-4xx  FAStT
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
`-+- policy='round-robin 0' prio=-30 status=enabled
   |- 5:0:0:10 sdb  8:16   failed undef running
   |- 6:0:0:10 sdc  8:32   failed undef running
   |- 5:0:0:12 sdd  8:48   failed undef running
   |- 6:0:0:12 sde  8:64   failed undef running
   |- 5:0:0:20 sdf  8:80   failed undef running
   |- 6:0:0:20 sdg  8:96   failed undef running
   |- 5:0:0:9  sdh  8:112  failed undef running
   |- 6:0:0:9  sdi  8:128  failed undef running
   |- 5:0:0:11 sdj  8:144  failed undef running
   |- 6:0:0:11 sdk  8:160  failed undef running
   |- 5:0:0:13 sdl  8:176  failed undef running
   |- 6:0:0:13 sdm  8:192  failed undef running
   |- 5:0:0:8  sdn  8:208  failed undef running
   |- 6:0:0:8  sdo  8:224  failed undef running
   |- 5:0:0:21 sdp  8:240  failed undef running
   |- 6:0:0:21 sdq  65:0   failed undef running
   |- 5:0:0:19 sdr  65:16  failed undef running
   |- 6:0:0:19 sds  65:32  failed undef running
   |- 5:0:0:18 sdt  65:48  failed undef running
   |- 6:0:0:18 sdu  65:64  failed undef running
   |- 5:0:0:17 sdv  65:80  failed undef running
   |- 6:0:0:17 sdw  65:96  failed undef running
   |- 5:0:0:22 sdx  65:112 failed undef running
   |- 6:0:0:22 sdy  65:128 failed undef running
   |- 5:0:0:16 sdz  65:144 failed undef running
   |- 6:0:0:16 sdaa 65:160 failed undef running
   |- 5:0:0:15 sdab 65:176 failed undef running
   |- 6:0:0:15 sdac 65:192 failed undef running
   |- 5:0:0:14 sdad 65:208 failed undef running
   `- #:#:#:#  -    #:#    failed undef running



(for the last line, I also echo'd 1 to the remove file.  Doing for all 
devices gets me:
1                 dm-3 ,
size=550G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
`-+- policy='round-robin 0' prio=-30 status=active
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# active undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   |- #:#:#:# -   #:# failed undef running
   `- #:#:#:# -   #:# failed undef running
