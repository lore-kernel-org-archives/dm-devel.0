From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: Re: Multipath and LVM (lvdisplay takes 30Secs)
Date: Tue, 15 May 2012 15:32:17 +0000
Message-ID: <77471C95FAFD844C8CA02DD4F4C5FE2B065AE3@SACEXCMBX02-PRD.hq.netapp.com>
References: <CANFxOjBW+RSKRCe_sSfAH=CXXLBLzJcfJzd8iJmJNLvSDVzOHg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CANFxOjBW+RSKRCe_sSfAH=CXXLBLzJcfJzd8iJmJNLvSDVzOHg@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-
> bounces@redhat.com] On Behalf Of ml ml
> Sent: Tuesday, May 15, 2012 5:15 AM
> To: dm-devel@redhat.com
> Subject: [dm-devel] Multipath and LVM (lvdisplay takes 30Secs)
> 
> Hello List,
> 
> i am using multipath for redundance reasons. But something seems to be
> dodgy.
> 
> "lvdisplay" takes 30Seconds.
> 
> "multipath" -l shows nothing
> 
> multipath -l -v 2
> SAN (3600a0b80001f7557000032864ce4aff3) dm-0 IBM,1722-600
> size=250G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
> |-+- policy='round-robin 0' prio=-1 status=active
> | `- 2:0:1:0 sdb 8:16 active undef running
> |-+- policy='round-robin 0' prio=-1 status=enabled
> | `- 3:0:1:0 sdd 8:48 active undef running
> `-+- policy='round-robin 0' prio=-1 status=enabled
>   `- 3:0:0:0 sdc 8:32 active undef running

Prio is showing -1.  May be your path grouping policy and prio handler is not set right.
I would set it correctly and then test it again. Here is how I would set it in multipath.conf.
path_grouping_policy    group_by_prio
prio                    		rdac

> 
> Any idea why lvmdisplay takes so long? If i can see its trying to read
> from sda, dm-1, sdb, dm-1 where the "read(3, " operations need some
> time each time.
> 
> Here is some more info:
> 
> multipath -l -v 3
> May 15 12:10:06 | sdb: not found in pathvec
> May 15 12:10:06 | sdb: mask = 0x1
> May 15 12:10:06 | sdb: dev_t = 8:16
> May 15 12:10:06 | sdb: size = 524288000
> May 15 12:10:06 | sdb: subsystem = scsi
> May 15 12:10:06 | sdb: vendor = IBM
> May 15 12:10:06 | sdb: product = 1722-600
> May 15 12:10:06 | sdb: rev = 0914
> May 15 12:10:06 | sdb: h:b:t:l = 2:0:1:0
> May 15 12:10:06 | sdb: tgt_node_name = 0x200400a0b816fb7
> May 15 12:10:06 | sda: device node name blacklisted
> May 15 12:10:06 | sdd: not found in pathvec
> May 15 12:10:06 | sdd: mask = 0x1
> May 15 12:10:06 | sdd: dev_t = 8:48
> May 15 12:10:06 | sdd: size = 524288000
> May 15 12:10:06 | sdd: subsystem = scsi
> May 15 12:10:06 | sdd: vendor = IBM
> May 15 12:10:06 | sdd: product = 1722-600
> May 15 12:10:06 | sdd: rev = 0914
> May 15 12:10:06 | sdd: h:b:t:l = 3:0:1:0
> May 15 12:10:06 | sdd: tgt_node_name = 0x200400a0b816fb7
> May 15 12:10:06 | sdc: not found in pathvec
> May 15 12:10:06 | sdc: mask = 0x1
> May 15 12:10:06 | sdc: dev_t = 8:32
> May 15 12:10:06 | sdc: size = 524288000
> May 15 12:10:06 | sdc: subsystem = scsi
> May 15 12:10:06 | sdc: vendor = IBM
> May 15 12:10:06 | sdc: product = 1722-600
> May 15 12:10:06 | sdc: rev = 0914
> May 15 12:10:06 | sdc: h:b:t:l = 3:0:0:0
> May 15 12:10:06 | sdc: tgt_node_name = 0x200400a0b816fb7
> May 15 12:10:06 | dm-0: device node name blacklisted
> May 15 12:10:06 | dm-1: device node name blacklisted
> May 15 12:10:06 | dm-2: device node name blacklisted
> May 15 12:10:06 | dm-3: device node name blacklisted
> May 15 12:10:06 | loop0: device node name blacklisted
> May 15 12:10:06 | loop1: device node name blacklisted
> May 15 12:10:06 | loop2: device node name blacklisted
> May 15 12:10:06 | loop3: device node name blacklisted
> May 15 12:10:06 | loop4: device node name blacklisted
> May 15 12:10:06 | loop5: device node name blacklisted
> May 15 12:10:06 | loop6: device node name blacklisted
> May 15 12:10:06 | loop7: device node name blacklisted
> May 15 12:10:06 | dm-4: device node name blacklisted
> May 15 12:10:06 | dm-5: device node name blacklisted
> May 15 12:10:06 | dm-6: device node name blacklisted
> ===== paths list =====
> uuid hcil    dev dev_t pri dm_st chk_st vend/prod/rev dev_st
>      2:0:1:0 sdb 8:16  -1  undef undef  IBM,1722-600  running
>      3:0:1:0 sdd 8:48  -1  undef undef  IBM,1722-600  running
>      3:0:0:0 sdc 8:32  -1  undef undef  IBM,1722-600  running
> May 15 12:10:06 | params = 1 queue_if_no_path 1 rdac 3 1 round-robin 0
> 1 1 8:16 600 round-robin 0 1 1 8:48 600 round-robin 0 1 1 8:32 100
> May 15 12:10:06 | status = 2 0 1 0 3 1 A 0 1 0 8:16 A 0 E 0 1 0 8:48 A
> 0 E 0 1 0 8:32 A 0
> SAN (3600a0b80001f7557000032864ce4aff3) dm-0 IBM,1722-600
> size=250G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
> |-+- policy='round-robin 0' prio=-1 status=active
> | `- 2:0:1:0 sdb 8:16 active undef running
> |-+- policy='round-robin 0' prio=-1 status=enabled
> | `- 3:0:1:0 sdd 8:48 active undef running
> `-+- policy='round-robin 0' prio=-1 status=enabled
>   `- 3:0:0:0 sdc 8:32 active undef running
> 
> Any idea whats wrong here?
> 
> Thanks a lot,
> Mario
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
