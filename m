From: "Martins, Bruno O" <bruno.martins@cgi.com>
Subject: Re: multipathd ignoring dev_loss_tmo setting
Date: Mon, 4 Mar 2019 14:09:00 +0000
Message-ID: <9eac83157cc3f92593157d1f09bda6b4f2c13351.camel@cgi.com>
References: <d915601a3472d7448e57f968e2ec3a63c627a35e.camel@cgi.com>
	<ab5b51f08713bc0eed503d2de7ad31e6006320f0.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ab5b51f08713bc0eed503d2de7ad31e6006320f0.camel@suse.de>
Content-Language: en-US
Content-ID: <35AA3072DEF23E41AC44A652004A0C37@logica.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mwilck@suse.de" <mwilck@suse.de>
List-Id: dm-devel.ids

On Mon, 2019-03-04 at 13:09 +0100, Martin Wilck wrote:
> On Thu, 2019-02-28 at 11:38 +0000,  Martins, Bruno O wrote:
> > Hello guys,
> > 
> > I am trying to modify /etc/multipath.conf on my system so that the
> > parameter 'dev_loss_tmo' is changed from the default value.
> > 
> > My multipath.conf file contains the following:
> > 
> > defaults {
> >         verbosity 2
> >         polling_interval 5
> >         max_polling_interval 10
> >         multipath_dir "/lib64/multipath"
> >         path_selector "round-robin 0"
> >         path_grouping_policy "failover"
> >         uid_attribute "ID_SERIAL"
> >         prio "const"
> >         prio_args ""
> >         features "0"
> >         path_checker "directio"
> >         alias_prefix "mpath"
> >         failback "manual"
> >         rr_min_io 1000
> >         rr_min_io_rq 1
> >         max_fds "max"
> >         rr_weight "uniform"
> >         no_path_retry "fail"
> >         queue_without_daemon "no"
> >         checker_timeout 15
> >         flush_on_last_del "no"
> >         user_friendly_names "yes"
> >         fast_io_fail_tmo 5
> >         dev_loss_tmo 10
> >         bindings_file "/etc/multipath/bindings"
> >         wwids_file /etc/multipath/wwids
> >         log_checker_err always
> >         retain_attached_hw_handler no
> >         detect_prio no
> > }
> > 
> > However, when checking the value currently in use I am getting the
> > wrong value (which is '30') for some of the remote ports:
> > 
> > for f in /sys/class/fc_remote_ports/rport-*/dev_loss_tmo; do
> > d=$(dirname $f); echo $(basename $d):$(cat $d/node_name):$(cat $f);
> > done
> > 
> > rport-3:0-0:0x5742b0f00007c500:10
> > rport-3:0-1:0x5742b0f00007c500:10
> > rport-3:0-2:0x5742b0f00007c500:10
> > rport-3:0-3:0x5000097408369800:30
> > rport-3:0-4:0x500009757804cbff:30
> > rport-4:0-0:0x5742b0f00007c500:10
> > rport-4:0-1:0x5742b0f00007c500:10
> > rport-4:0-2:0x5000097408369800:30
> > rport-4:0-3:0x5742b0f00007c500:10
> > rport-4:0-4:0x500009757804cbff:30
> > rport-5:0-0:0x5742b0f00007c500:10
> > rport-5:0-1:0x5742b0f00007c500:10
> > rport-5:0-2:0x5742b0f00007c500:10
> > rport-5:0-3:0x5000097408369800:30
> > rport-5:0-4:0x500009757804cbff:30
> > rport-6:0-0:0x5742b0f00007c500:10
> > rport-6:0-1:0x5742b0f00007c500:10
> > rport-6:0-2:0x5000097408369800:30
> > rport-6:0-3:0x5742b0f00007c500:10
> > rport-6:0-4:0x500009757804cbff:30
> > 
> > systool is giving me the same information:
> > 
> > systool -c fc_remote_ports -v | grep dev_loss_tmo
> > 
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "10"
> > 
> > 
> > > I am using the following versions:
> > > 
> > > rpm -qa multipath-tools
> > > multipath-tools-0.4.9-109.1
> > > 
> > > uname -a
> > > Linux mysystem 3.0.101-63-default #1 SMP Tue Jun 23 16:02:31 UTC
> > 
> > 2015
> > > (4b89d0c) x86_64 x86_64 x86_64 GNU/Linux
> > > 
> > > Thanks for your help!
> > > 
> > > Kind regards,
> > > 
> > > Bruno
> > > 
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > 
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> > > 
> > > 
> > 
> > 
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "30"
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "30"
> >     dev_loss_tmo        = "30"
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "30"
> >     dev_loss_tmo        = "10"
> >     dev_loss_tmo        = "30"
> >     dev_loss_tmo        = "30"
> >     dev_loss_tmo        = "30"
> >     dev_loss_tmo        = "30"
> > 
> > Where is this value coming from? May this be a bug? I couldn't find
> > anything useful on the Internet regarding this.
> 
> It'd be very helpful if you could upload "multipath -v3" (or
> multipathd
> with verbosity 3) logs somewhere.
> 
> It looks as if you're using some SLE11 variant, so maybe you want to
> open a support case?
> 
> Another question would be why you want such a low dev_loss_tmo. It's
> not generally recommended, because on the kernel side, removing and
> re-
> adding a device is a lot more complex than disabling and re-enabling
> it. The fast_io_fail_tmo should provide you with quick path failover
> already. My recommendation is to set dev_loss_tmo to a value which
> would, in the given data center, indicate that the device loss is
> really not due to a temporary outage but due to a permantly removed
> device (e.g. permanent storage configuration change). So basically,
> the
> dev_loss_tmo shouldn't be shorter than the admin's lunch break.
> 
> Martin
> 
> 
> 
> 

Hello Martin,

Yes, I'm using SuSE:

[ 14:01:44 ] root@mysystem:/tmp# cat /etc/SuSE-release 
SUSE Linux Enterprise Server 11 (x86_64)
VERSION = 11
PATCHLEVEL = 4

The thing here is that my applications are crashing due to multipath
issues on my Oracle DB cluster, with errors like these:

[ 13:59:27 ] root@mysystem:~# cat /var/log/messages | grep multipath |
head -n 20
Mar  2 23:00:36 mysystem multipathd: sdayi: failed to set rport to
'Blocked', error 2
Mar  2 23:00:36 mysystem multipathd: BPM1ADB1REDO1DG-hdisk1: sdayi -
tur checker timed out
Mar  2 23:00:36 mysystem multipathd: checker failed path 67:1376 in map
BPM1ADB1REDO1DG-hdisk1
Mar  2 23:00:36 mysystem multipathd: BPM1ADB1REDO1DG-hdisk1: remaining
active paths: 3
Mar  2 23:00:36 mysystem multipathd: sdayj: failed to set rport to
'Blocked', error 2
Mar  2 23:00:36 mysystem multipathd: BPM1ADB1REDO1DG-hdisk2: sdayj -
tur checker timed out
Mar  2 23:00:36 mysystem multipathd: checker failed path 67:1392 in map
BPM1ADB1REDO1DG-hdisk2
Mar  2 23:00:36 mysystem multipathd: BPM1ADB1REDO1DG-hdisk2: remaining
active paths: 3
Mar  2 23:00:36 mysystem multipathd: sdayk: failed to set rport to
'Blocked', error 2
Mar  2 23:00:36 mysystem multipathd: BPM1ADB1REDO1DG-hdisk3: sdayk -
tur checker timed out
Mar  2 23:00:36 mysystem multipathd: checker failed path 67:1408 in map
BPM1ADB1REDO1DG-hdisk3
Mar  2 23:00:36 mysystem kernel: [9249542.734463] device-mapper:
multipath: Failing path 67:1376.
Mar  2 23:00:48 mysystem kernel: [9249542.734701] device-mapper:
multipath: Failing path 67:1392.
Mar  2 23:00:48 mysystem kernel: [9249542.734925] device-mapper:
multipath: Failing path 67:1408.
Mar  2 23:00:36 mysystem multipathd: BPM1ADB1REDO1DG-hdisk3: remaining
active paths: 3
Mar  2 23:00:48 mysystem multipathd: sdayo: failed to set rport to
'Blocked', error 2
Mar  2 23:00:48 mysystem multipathd: BPM1ADB1REDO2DG-hdisk2: sdayo -
tur checker timed out
Mar  2 23:00:48 mysystem multipathd: checker failed path 67:1472 in map
BPM1ADB1REDO2DG-hdisk2
Mar  2 23:00:48 mysystem multipathd: BPM1ADB1REDO2DG-hdisk2: remaining
active paths: 3
Mar  2 23:00:48 mysystem multipathd: sdayp: failed to set rport to
'Blocked', error 2

Output of 'multipath -v3' is available here:
https://paste.gnome.org/pojggla8w

Thanks for your cooperation!

Best regards,

Bruno
