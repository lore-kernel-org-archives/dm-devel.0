From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/4] multipath-tools: add checker callout to
 repair path
Date: Fri, 12 Aug 2016 10:10:37 -0700
Message-ID: <58643d35-10fa-ded1-3733-02dfc28495f4@sandisk.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
	<1470657710-28081-3-git-send-email-mchristi@redhat.com>
	<9d5dcfcd-2550-c9e9-94dc-47c34ebdb039@sandisk.com>
	<57ACE12F.20700@redhat.com>
	<e4286ca9-01cb-5cc0-2d67-38f68c0a19cb@sandisk.com>
	<57ADFF4E.2070604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <57ADFF4E.2070604@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mchristi@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 08/12/2016 09:54 AM, Mike Christie wrote:
> On 08/11/2016 04:41 PM, Bart Van Assche wrote:
>> On 08/11/2016 01:33 PM, Mike Christie wrote:
>>> Could you try the attached patch. I found two segfaults. If check_path
>>> returns less than 0 then we free the path and so we cannot call repair
>>> on it. If libcheck_init fails it memsets the checker, so we cannot call
>>> repair on it too.
>>>
>>> I moved the repair call to the specific paths that the path is down.
>>
>> Thanks for the patch. Unfortunately even with this patch applied I can
>> still trigger a segfault sporadically:
> 
> I can't seem to replicate the problem with my patch and I do not see
> anything. Could you send me your multipath.conf/hwtable settings?

Please find that file at the end of this e-mail.
 
> For the fo/fb test, dev_loss_tmo is firing causing paths to be
> added/deleted right?
 
The script that I'm using to simulate path loss writes into /sys/class
/srp_remote_ports/*/delete. That causes the ib_srp driver to call
scsi_remove_host(). That script is available at
https://github.com/bvanassche/srp-test. However, an InfiniBand HCA is
needed to run this script.

Bart.


/etc/multipath.conf:

defaults {
        user_friendly_names     yes
        queue_without_daemon    no
}

blacklist {
        device {
                vendor                  "ATA"
                product                 ".*"
        }
}

devices {
        device {
                vendor                  "SCST_BIO|LIO-ORG"
                product                 ".*"
                features                "3 queue_if_no_path pg_init_retries 50"
                path_grouping_policy    group_by_prio
                path_selector           "queue-length 0"
                path_checker            tur
        }
}

blacklist_exceptions {
        property        ".*"
}
