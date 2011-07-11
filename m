From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: Wrong behaviour of multipathing on Active/Passive
	storage array
Date: Mon, 11 Jul 2011 20:41:35 +0200
Message-ID: <1310409695.22613.6.camel@lapoo.opensvc.com>
References: <1310398486.6249.209.camel@mi>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1310398486.6249.209.camel@mi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikhail Shevyakov <Shevyakov.M@avroraid.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On lun., 2011-07-11 at 19:34 +0400, Mikhail Shevyakov wrote:
> Hello!
> I try to configure multipathing for Active/Passive storage and I have
> a problem with this:
> when paths are switched (Active->Passive, Passive->Active) all
> read/write operations
> are suspended. When paths switches back read/write resumes. 
> Following is the configuration:
> 
Active/passive arrays should not use a 'multibus' grouping policy. You
should have 2 paths groups. And a hardware handler to signal the array
controllers about path group switching.

Your array seems to support alua, so you should seed your config with a
'device' config block from another alua-supported array.

Bye.

> # less /etc/multipath.conf 
> defaults {
> user_friendly_names yes
> prio alua
> path_checker tur
> no_path_retry 10
> fast_io_fail_tmo 5
> polling_interval        10
> selector                "round-robin 0"
> path_grouping_policy    multibus
> rr_min_io               100
> failback                immediate
> }
> 
> # multipath -ll
> mpathb (0AvroRAIDDVAS            000000000000000097f62ae1) dm-0 AvroRAID,DVAS
> size=683G features='1 queue_if_no_path' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=5 status=active
>   |- 7:0:0:0 sdc 8:32 active ghost  running
>   `- 9:0:0:0 sdd 8:48 active ready  running
> 
> This is output of st_turs:
> 
> # sg_turs -v /dev/sdd
>     test unit ready cdb: 00 00 00 00 00 00 
> # sg_turs -v /dev/sdc
>     test unit ready cdb: 00 00 00 00 00 00 
> test unit ready:  Fixed format, current;  Sense key: Not Ready
>  Additional sense: Logical unit not accessible, target port in standby state
>   Info fld=0x0 [0] 
> device not ready
> 
> And REPORT TARGET PORT GROUPS output:
> 
> #sg_rtpg /dev/sdd 
> Report target port groups:
>   target port group id : 0x1 , Pref=1
>     target port group asymmetric access state : 0x00
>     T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
>     status code : 0x02
>     vendor unique status : 0x00
>     target port count : 02
>     Relative target port ids:
>       0x01
>       0x02
> #sg_rtpg /dev/sdc
> Report target port groups:
>   target port group id : 0x2 , Pref=0
>     target port group asymmetric access state : 0x02
>     T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
>     status code : 0x02
>     vendor unique status : 0x00
>     target port count : 04
>     Relative target port ids:
>       0x01
>       0x02
>       0x03
>       0x04
> 
> I used dd to write on the dm device:
> 
> #dd if=/dev/zero of=/dev/dm-0 oflag=direct bs=1M
> 
> Everything works fine untill paths are switched. dd stops, turs output:
> 
> # sg_turs -v /dev/sdd
>     test unit ready cdb: 00 00 00 00 00 00 
> # sg_turs -v /dev/sdc
>     test unit ready cdb: 00 00 00 00 00 00 
> test unit ready:  Fixed format, current;  Sense key: Not Ready
>  Additional sense: Logical unit not accessible, target port in standby state
>   Info fld=0x0 [0] 
> device not ready
>  
> REPORT TARGET PORT GROUPS output:
> 
> # sg_rtpg /dev/sdd 
> Report target port groups:
>   target port group id : 0x1 , Pref=0
>     target port group asymmetric access state : 0x02
>     T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
>     status code : 0x02
>     vendor unique status : 0x00
>     target port count : 02
>     Relative target port ids:
>       0x01
>       0x02
> # sg_rtpg /dev/sdc
> Report target port groups:
>   target port group id : 0x2 , Pref=1
>     target port group asymmetric access state : 0x00
>     T_SUP : 0, O_SUP : 0, U_SUP : 1, S_SUP : 1, AN_SUP : 0, AO_SUP : 1
>     status code : 0x02
>     vendor unique status : 0x00
>     target port count : 04
>     Relative target port ids:
>       0x01                                                                                                                                                                                                                                   
>       0x02                                                                                                                                                                                                                                   
>       0x03                                                                                                                                                                                                                                   
>       0x04
> 
> As you can see paths' states are switched.Output of multipath:
> 
> # multipath -ll
> mpathb (0AvroRAIDDVAS            000000000000000097f62ae1) dm-0 AvroRAID,DVAS
> size=683G features='1 queue_if_no_path' hwhandler='0' wp=rw
> `-+- policy='round-robin 0' prio=5 status=enabled
>   |- 7:0:0:0 sdc 8:32 failed ready  running
>   `- 9:0:0:0 sdd 8:48 failed ghost  running
> 
> 
> So states of the paths are changed but multipath for some reason fails both paths.
> Is something wrong with my config or is it a bug in multipath?
> Could you help me with this problem?
> 
> Regards
> Mikhail Shevyakov
> 
