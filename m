From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: qla4xxx & "device-mapper: table: 253:0: multipath:
	error getting device" error
Date: Wed, 4 Jun 2008 10:36:04 -0400
Message-ID: <20080604143603.GA1801@mars.virtualiron.com>
References: <4845C73F.7030009@online.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4845C73F.7030009@online.no>
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

On Wed, Jun 04, 2008 at 12:35:43AM +0200, Christopher wrote:
> Hi,
>
> I'm on my second atempt to configure iSCSI (Dell EqualLogic PS5000XV) on 
> linux (CentOS 5.1 x86_64). The first ended in a total caos and kernel panic 
> I didn't manage to recover from. No biggie, since it's a new server 
> (actually will be two identical running a cluster with iSCSI as shared 
> storage).
>
> I've got a dualport QLogic iSCSI HBA QLE4062C card. I am trying to 
> configure my server to use multipath to the EqualLogic, but i'm not 
> confident it's safe to put it in production since I get this error in my 
> message log (dmesg) when what I believe is correct configuration gives me 
> lots of these:
>
> device-mapper: table: 253:0: multipath: error getting device
> device-mapper: ioctl: error adding target to table

1) Diff of device mapper.
I've followed your post previously and I am wondering if you can do:

#dmsetup status > pre

 load your qla4xxx module
#modprobe qla4xxx

 wait till it has stabilized, see when that device-mapper error shows up,
 then:,

#dmsetup status > post

#diff pre post

And send it to this mailing list. You should see one new entry being
added (or rather, one for one set of LUNs). If there is a multipath
entry for your newly added block device you are OK. If it isn't
showing up (and multipath -ll doesn't show your EQLOGIC multipath
device-map) something is hosed.

2). Trace your udev creation.

The multipath error might be due to 'kpartx' being called on your
device. I don't remember the logic of how this works (and each 
distro has is differently), but do this:

 a). Make sure your /etc/udev* directory is virgin. Remove any
     changes you might have made in there.
 b). Edit the /etc/udev/udev.conf and change udev_log to be:
	udev_log="debug"

 c). Restart your machine, skip the multitude of debug messages, and
	when the machine has stabilized:

	1). modprobe qla4xxx
	2). look at the console output. If you have syslog it probably
	    stuck the output in /var/log/messages or /var/log/allmessages.
		You might need to edit your /etc/syslog.conf to make it log
		debug messages to a file (it could be defined as /var/log/debug?)

	3). Look at the output. Note down all the commands, and then
		unload the qla4xxx module, kill the udev or better yet move
		the /etc/udev/rules directory to another place. After that
		reload the qla4xx and do all of those commands the udev would
		have done and see which one causes the error to appear.
		Send the result to the device-mapper mailing list.. and people
		might have better ideas of what is wrong.

		
>
> First I used the drivers from QLogic and thought it was a bug in the 
> driver, but after I removed them the system loaded the kernel provided 
> qla4xxx driver and the error still showed in my log.
>
> Is this a but in device-mapper-multipath or is it my config?

I think it is a configuration bug in udev rules or that your block
devices might have some weird device-mapper rules in it (like maybe
crypt-loop or what-not) and your udev rules try to parse it but
do it wrong. Either way, I would blame udev :-)

>
> For more info on this, see my open-iscsi post on google groups:
> http://groups.google.com/group/open-iscsi/browse_thread/thread/8bf139d774eab658
>
> I posted there first, but ppl in the group told me to go to dm-devel.
>
> /Christopher
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
