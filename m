From: "Martins, Bruno O" <bruno.martins@cgi.com>
Subject: Re: multipathd ignoring dev_loss_tmo setting
Date: Mon, 4 Mar 2019 09:48:59 +0000
Message-ID: <1379896535dccc69dc07bf16a8be7696392261a3.camel@cgi.com>
References: <d915601a3472d7448e57f968e2ec3a63c627a35e.camel@cgi.com>
	<20190228195330.GQ3023@octiron.msp.redhat.com>
	<69ee893dda390f614c78f49b55ea99c7c7f6583a.camel@cgi.com>
	<20190301173512.GR3023@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190301173512.GR3023@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <7ABF51115C75F540A92F265C0B5D4B0B@logica.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-03-01 at 11:35 -0600, Benjamin Marzinski wrote:
> On Fri, Mar 01, 2019 at 10:04:52AM +0000, Martins, Bruno O wrote:
> > On Thu, 2019-02-28 at 13:53 -0600, Benjamin Marzinski wrote:
> > > On Thu, Feb 28, 2019 at 11:38:22AM +0000, Martins, Bruno O wrote:
> > > > Hello guys,
> > > > 
> > > > I am trying to modify /etc/multipath.conf on my system so that
> > > > the
> > > > parameter 'dev_loss_tmo' is changed from the default value.
> > > > 
> > > > However, when checking the value currently in use I am getting
> > > > the
> > > > wrong value (which is '30') for some of the remote ports:
> > > > 
> > > 
> > > Are you sure those rports are used by multipath devices?
> > > multipath
> > > only
> > > changes dev_loss_tmo for rports associated with a multipath path
> > > device.
> > > 
> > > -Ben
> > >  
> > 
> > Hi Benjamin,
> > 
> > Thanks for your reply!
> > 
> > I believe they are:
> > 
> > [ 10:02:45 ] root@myhost:~# multipath -ll | grep 3:0:3
> >   |- 3:0:3:12  sdblc 128:1568 active ready running
> >   |- 3:0:3:13  sdbnu 132:1664 active ready running
> >   |- 3:0:3:18  sdbre 66:1792  active ready running
> >   |- 3:0:3:1   sdbkg 70:1728  active ready running
> >   |- 3:0:3:2   sdbnv 132:1680 active ready running
> >   |- 3:0:3:20  sdbrg 66:1824  active ready running
> >   |- 3:0:3:17  sdbpg 134:1760 active ready running
> >   |- 3:0:3:16  sdbpf 134:1744 active ready running
> >   |- 3:0:3:11  sdbkf 70:1712  active ready running
> >   |- 3:0:3:19  sdbrf 66:1808  active ready running
> >   |- 3:0:3:14  sdbnw 132:1696 active ready running
> >   |- 3:0:3:15  sdbpe 134:1728 active ready running
> > 
> > Is this the best way to check that information?
> 
> The scsi HBTL isn't guaranteed to line up with the rport id.  To find
> this
> out you can either run
> 
> # ls -l /sys/block
> 
> and then check the rport for your path devices from the link
> destination.
> 
> For instance
> 
> [root@ask-07 block]# ls -l /sys/block
> <snip>
> lrwxrwxrwx. 1 root root 0 Feb 21 02:45 sdb ->
> ../devices/pci0000:00/0000:00:0a.0/0000:06:00.0/host16/rport-16:0-
> 0/target16:0:0/16:0:0:0/block/sdb
> lrwxrwxrwx. 1 root root 0 Feb 21 02:45 sdc ->
> ../devices/pci0000:00/0000:00:0a.0/0000:06:00.0/host16/rport-16:0-
> 0/target16:0:0/16:0:0:1/block/sdc
> lrwxrwxrwx. 1 root root 0 Feb 21 02:45 sdd ->
> ../devices/pci0000:00/0000:00:0a.0/0000:06:00.1/host17/rport-17:0-
> 0/target17:0:0/17:0:0:0/block/sdd
> lrwxrwxrwx. 1 root root 0 Feb 21 02:45 sde ->
> ../devices/pci0000:00/0000:00:0a.0/0000:06:00.1/host17/rport-17:0-
> 0/target17:0:0/17:0:0:1/block/sde
> <snip>
>  
> Here, sdb and sdc are using rport-16:0-0, and sdd and sde are using
> rport-17:0-0
> 
> Otherwise, you can pick an rport with the wrong dev_loss_tmo, and
> check
> 
> /sys/class/fc_remote_ports/<rport>/device/<target>/
> 
> In there there will be a number of scsi HBTL identifiers, for example
> 
> # ls /sys/class/fc_remote_ports/rport-16\:0-0/device/target16\:0\:0/
> 16:0:0:0  16:0:0:1  fc_transport  power  subsystem  uevent
> 
> If these HBTL ids (16:0:0:0 and 16:0:0:1) are for multipath path
> devices, then multipath should be updating dev_loss_tmo for them. In
> my
> example above, the scsi HBTL does correspond to the rport id, but
> this
> isn't always the case.
> 
> -Ben
> 
> > BR,
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> 
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> 


Hello Ben,

Then I believe this rport's with wrong dev_loss_tmo are part of
multipathd. Is this correct?

[ 09:46:21 ] root@mysystem:~# ls -l /sys/block | grep rport-3:0-0
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdaa ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:26/block/sdaa
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdab ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:27/block/sdab
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdac ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:28/block/sdac
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdad ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:29/block/sdad
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdae ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:30/block/sdae
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdaf ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:31/block/sdaf
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdag ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:32/block/sdag
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdah ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:33/block/sdah
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdai ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:34/block/sdai
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdaj ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:35/block/sdaj
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdak ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:36/block/sdak
lrwxrwxrwx 1 root root 0 Feb  6 17:50 sdal ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:37/block/sdal
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdaug ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:0/block/sdaug
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdauh ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:1/block/sdauh
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdauj ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:3/block/sdauj
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdauk ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:4/block/sdauk
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdaul ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:5/block/sdaul
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdaum ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:6/block/sdaum
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdaun ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:7/block/sdaun
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdauo ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:8/block/sdauo
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdaup ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:9/block/sdaup
lrwxrwxrwx 1 root root 0 Nov 27 15:34 sdauq ->
../devices/pci0000:00/0000:00:01.0/0000:07:00.0/host3/rport-3:0-
0/target3:0:0/3:0:0:10/block/sdauq
(...)

Best regards,

Bruno
