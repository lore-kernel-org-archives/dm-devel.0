From: Andy <genanr@emsphone.com>
Subject: Re: Device Mapper MultiPath
Date: Thu, 2 Apr 2009 16:50:08 -0500
Message-ID: <20090402215008.GA14752@thumper2>
References: <af7b4eb20903311707o925902dn14a6dc8030498001@mail.gmail.com>
	<20090401002559.GA3213@mars.virtualiron.com>
	<20090401200841.GA9078@thumper2>
	<20090401203108.GA17991@mars.virtualiron.com>
	<20090402190956.GA12661@thumper2>
	<20090402193233.GC615@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090402193233.GC615@mars.virtualiron.com>
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

On Thu, Apr 02, 2009 at 03:32:33PM -0400, Konrad Rzeszutek wrote:
> On Thu, Apr 02, 2009 at 02:09:56PM -0500, Andy wrote:
> > On Wed, Apr 01, 2009 at 04:31:08PM -0400, Konrad Rzeszutek wrote:
> > > On Wed, Apr 01, 2009 at 03:08:41PM -0500, Andy wrote:
> > > > On Tue, Mar 31, 2009 at 08:25:59PM -0400, Konrad Rzeszutek wrote:
> > > > > On Tue, Mar 31, 2009 at 09:07:08PM -0300, Rodrigo Nascimento wrote:
> > > > > > Hi All,
> > > > > > 
> > > > > > I'm a student of computer sciences and I'd like to collaborate with the
> > > > > > development of the DM-MP.
> > > > > > I know that maybe you received this kind of message during all time, but I
> > > > > 
> > > > > I think you are the first :-)
> > > > > 
> > > > > > really want to help, with anything.
> > > > > 
> > > > > Shakedown help would be nice. As in, trying to yank stuff underneath it, 
> > > > > add new block disks, remove them, add them, remove them, edit the
> > > > > multipath.conf file and issue 'reconfigure', resize the maps, 
> > > > > then add 1000+LUNs, and while they are being added, start removing the
> > > > > LUNs, then for extra fun call 'dmsetup remove_all' while in another
> > > > > thread you run 'multipath'. Ooh, and see if there are any memory leaks
> > > > > while this all is being done.
> > > > > 
> > > > 
> > > > What I would really like to see is online resizing of non-partitioned dm
> > > > block devices.  I would love to be able to resize an underlying dm-mp block
> > > > device, and the just grow the filesystem without using a extra, un-needed,
> > > 
> > > Benjamin posted a CVS patch of this, that I've forward-ported to work with
> > > the latest git. It is attached.
> > > 
> > > 
> > 
> > Thanks, I must have missed that post.  Unfortantly, I am having problems with
> > multipathd in the latest git.  It fails all my paths and hangs.  It I go
> 
> Ugh. That doesn't bode well. Try running it with 'strace' to see if it is hanging
> on the ioctl or what not.
> 

The multipathd process is just sitting there polling, but I don't think it
gets to a point where it can handle requests from an interactive version of
itself.

I do see detecting or failing the paths in the log:

Apr 02 16:24:01 | sdc: ownership set to test1_vm1
Apr 02 16:24:01 | sdc: not found in pathvec
Apr 02 16:24:01 | sdc: mask = 0xc
Apr 02 16:24:01 | sdc: path checker = directio (controller setting)
Apr 02 16:24:01 | sdc: state = running
Apr 02 16:24:01 | directio: starting new request
Apr 02 16:24:01 | directio: async io getevents returns -14 (errno=No such file or directory)
Apr 02 16:24:01 | directio: abort check on timeout
Apr 02 16:24:01 | sdc: state = 2
Apr 02 16:24:01 | sdc: checker msg is "directio checker reports path is down"
Apr 02 16:24:01 | sde: ownership set to test1_vm1
Apr 02 16:24:01 | sde: not found in pathvec
Apr 02 16:24:01 | sde: mask = 0xc
Apr 02 16:24:01 | sde: path checker = directio (controller setting)
Apr 02 16:24:01 | sde: state = running
Apr 02 16:24:01 | directio: starting new request
Apr 02 16:24:01 | directio: async io getevents returns -14 (errno=No such file or directory)
Apr 02 16:24:01 | directio: abort check on timeout
Apr 02 16:24:01 | sde: state = 2
Apr 02 16:24:01 | sde: checker msg is "directio checker reports path is down"
Apr 02 16:24:01 | test1_vm1: pgfailover = -1 (internal default)
Apr 02 16:24:01 | test1_vm1: pgpolicy = multibus (LUN setting)
Apr 02 16:24:01 | test1_vm1: selector = round-robin 0 (LUN setting)
Apr 02 16:24:01 | test1_vm1: features = 0 (controller setting)
Apr 02 16:24:01 | test1_vm1: hwhandler = 0 (controller setting)
Apr 02 16:24:01 | test1_vm1: rr_weight = 1 (controller setting)
Apr 02 16:24:01 | test1_vm1: minio = 1 (LUN setting)
Apr 02 16:24:01 | test1_vm1: no_path_retry = NONE (internal default)
Apr 02 16:24:01 | pg_timeout = NONE (internal default)
Apr 02 16:24:01 | test1_vm1: set ACT_NOTHING (no usable path)
Apr 02 16:24:01 | sdb: ownership set to u01_vm1
Apr 02 16:24:01 | sdb: not found in pathvec
Apr 02 16:24:01 | sdb: mask = 0xc
Apr 02 16:24:01 | sdb: path checker = directio (controller setting)
Apr 02 16:24:01 | sdb: state = running
Apr 02 16:24:01 | directio: starting new request
Apr 02 16:24:01 | directio: async io getevents returns -14 (errno=No such file or directory)
Apr 02 16:24:01 | directio: abort check on timeout
Apr 02 16:24:01 | sdb: state = 2
Apr 02 16:24:01 | sdb: checker 

Other than that, I did not see anything significant in the strace or the
debugging messages.

Andy
