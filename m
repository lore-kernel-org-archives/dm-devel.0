From: "Martins, Bruno O" <bruno.martins@cgi.com>
Subject: multipathd ignoring dev_loss_tmo setting
Date: Thu, 28 Feb 2019 11:38:22 +0000
Message-ID: <d915601a3472d7448e57f968e2ec3a63c627a35e.camel@cgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
Content-ID: <7F81297DDB80FC40AD89F3A257EC5404@logica.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello guys,

I am trying to modify /etc/multipath.conf on my system so that the
parameter 'dev_loss_tmo' is changed from the default value.

My multipath.conf file contains the following:

defaults {
        verbosity 2
        polling_interval 5
        max_polling_interval 10
        multipath_dir "/lib64/multipath"
        path_selector "round-robin 0"
        path_grouping_policy "failover"
        uid_attribute "ID_SERIAL"
        prio "const"
        prio_args ""
        features "0"
        path_checker "directio"
        alias_prefix "mpath"
        failback "manual"
        rr_min_io 1000
        rr_min_io_rq 1
        max_fds "max"
        rr_weight "uniform"
        no_path_retry "fail"
        queue_without_daemon "no"
        checker_timeout 15
        flush_on_last_del "no"
        user_friendly_names "yes"
        fast_io_fail_tmo 5
        dev_loss_tmo 10
        bindings_file "/etc/multipath/bindings"
        wwids_file /etc/multipath/wwids
        log_checker_err always
        retain_attached_hw_handler no
        detect_prio no
}

However, when checking the value currently in use I am getting the
wrong value (which is '30') for some of the remote ports:

for f in /sys/class/fc_remote_ports/rport-*/dev_loss_tmo; do
d=$(dirname $f); echo $(basename $d):$(cat $d/node_name):$(cat $f);
done

rport-3:0-0:0x5742b0f00007c500:10
rport-3:0-1:0x5742b0f00007c500:10
rport-3:0-2:0x5742b0f00007c500:10
rport-3:0-3:0x5000097408369800:30
rport-3:0-4:0x500009757804cbff:30
rport-4:0-0:0x5742b0f00007c500:10
rport-4:0-1:0x5742b0f00007c500:10
rport-4:0-2:0x5000097408369800:30
rport-4:0-3:0x5742b0f00007c500:10
rport-4:0-4:0x500009757804cbff:30
rport-5:0-0:0x5742b0f00007c500:10
rport-5:0-1:0x5742b0f00007c500:10
rport-5:0-2:0x5742b0f00007c500:10
rport-5:0-3:0x5000097408369800:30
rport-5:0-4:0x500009757804cbff:30
rport-6:0-0:0x5742b0f00007c500:10
rport-6:0-1:0x5742b0f00007c500:10
rport-6:0-2:0x5000097408369800:30
rport-6:0-3:0x5742b0f00007c500:10
rport-6:0-4:0x500009757804cbff:30

systool is giving me the same information:

systool -c fc_remote_ports -v | grep dev_loss_tmo

    dev_loss_tmo        = "10"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "30"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "30"
    dev_loss_tmo        = "30"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "30"
    dev_loss_tmo        = "10"
    dev_loss_tmo        = "30"
    dev_loss_tmo        = "30"
    dev_loss_tmo        = "30"
    dev_loss_tmo        = "30"

Where is this value coming from? May this be a bug? I couldn't find
anything useful on the Internet regarding this.

I am using the following versions:

rpm -qa multipath-tools
multipath-tools-0.4.9-109.1

uname -a
Linux mysystem 3.0.101-63-default #1 SMP Tue Jun 23 16:02:31 UTC 2015
(4b89d0c) x86_64 x86_64 x86_64 GNU/Linux

Thanks for your help!

Kind regards,

Bruno
