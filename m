From: ml ml <mliebherr99@googlemail.com>
Subject: Re: Multipath and LVM (lvdisplay takes 30Secs)
Date: Wed, 16 May 2012 10:41:51 +0200
Message-ID: <CANFxOjCSPajjXYvPQ3et+MnpVxvvqkPzQN8UNAknEaWwcCgo+Q@mail.gmail.com>
References: <CANFxOjBW+RSKRCe_sSfAH=CXXLBLzJcfJzd8iJmJNLvSDVzOHg@mail.gmail.com>
	<77471C95FAFD844C8CA02DD4F4C5FE2B065AE3@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B065AE3@SACEXCMBX02-PRD.hq.netapp.com>
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

Hi,

>> multipath -l -v 2
>> SAN (3600a0b80001f7557000032864ce4aff3) dm-0 IBM,1722-600
>> size=250G features='1 queue_if_no_path' hwhandler='1 rdac' wp=rw
>> |-+- policy='round-robin 0' prio=-1 status=active
>> | `- 2:0:1:0 sdb 8:16 active undef running
>> |-+- policy='round-robin 0' prio=-1 status=enabled
>> | `- 3:0:1:0 sdd 8:48 active undef running
>> `-+- policy='round-robin 0' prio=-1 status=enabled
>>   `- 3:0:0:0 sdc 8:32 active undef running
>
> Prio is showing -1.  May be your path grouping policy and prio handler is not set right.
> I would set it correctly and then test it again. Here is how I would set it in multipath.conf.
> path_grouping_policy    group_by_prio
> prio                                    rdac
>

Right now i am using "path_grouping_policy    failover". See below for
the full config file.
Since i want failover/redundancy. In this case i really want
"path_grouping_policy    group_by_prio"?

Here is the full config file:


blacklist {
        devnode "sda"
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^hd[a-z][[0-9]*]"

}

defaults {
        user_friendly_names     yes
        udev_dir                /dev
        polling_interval        10
        verbosity               0
        path_grouping_policy    failover
        #path_grouping_policy    group_by_prio
        #prio                    rdac

}

multipaths {
       multipath {
               wwid                    3600a0b80001f7557000032864ce4aff3
               alias                   SAN
               path_grouping_policy    failover
               path_selector           "round-robin 0"
               failback                manual
               rr_weight               priorities
               no_path_retry           5
               rr_min_io               100
       }
}

devices {
       device {
               vendor                  "IBM"
               product                 "1722-600"
               path_grouping_policy    failover
       }
}



Thanks,
Mario
