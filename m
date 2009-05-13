From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: no_path_retry configurable per device basis?
Date: Wed, 13 May 2009 19:35:49 +0200
Message-ID: <561c252c0905131035p19ddb6fdp32482feb0b66bf1e@mail.gmail.com>
References: <561c252c0905130851q221e9febq61cc37f9fe9cee3@mail.gmail.com>
	<1242231573.13505.571.camel@breeves.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1242231573.13505.571.camel@breeves.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Thanks for answering.
why will I still see queue if_if_no_path?
Ok for the kb... it was the same I referred to in my qyestion... ;-)

And what about having a multipath.conf like this?

blacklist {
      devnode "^cciss!c[0-9]d[0-9]*"
}


defaults {
      user_friendly_names yes
      polling_interval 30
      rr_min_io 100
}
      device {
              vendor                  "IBM"
              product                 "1750500"
              getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
              prio_callout            "/sbin/mpath_prio_alua %d"
              hardware_handler        "0"
              path_grouping_policy    group_by_prio
              failback                immediate
              rr_weight               uniform
              path_checker            tur
              no_path_retry 3
      }
multipaths {
      multipath {
              wwid                    3600507630efe0b0c0000000000000600
              alias                   mpath0
              no_path_retry      queue
      }
      multipath {
              wwid                    3600507630efe0b0c0000000000000601
              alias                   mpath1
              no_path_retry      queue
      }
     [snip]
      multipath {
              wwid                    3600507630efe0b0c0000000000000610
              alias                   mpath6
      }
    [snip]
}

what would I see with multipath -l?

As in defaults for this device there is
features 1 queue_if_no_path
and there is no other option configurable per "features" key in device
section....
what would be the effect?
Or in other words, can I disable the "features" key for a device....?
For example setting fir it the no_path_retry that semms applicable to
the device section itself...?


Gianluca
