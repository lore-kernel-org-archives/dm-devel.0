From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: RHEL6.2: path failures during good path I/O
Date: Wed, 13 Jun 2012 09:16:13 -0400
Message-ID: <20120613131613.GA18293@redhat.com>
References: <4FD87335.3040300@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4FD87335.3040300@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian May <cmay@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Jun 13 2012 at  7:02am -0400,
Christian May <cmay@linux.vnet.ibm.com> wrote:

> Hi,
> I've setup RHEL 6.2 on a VIO server. Two pathes to the DS4300
> storage server are established using two VIO server.
> Ten SCSI LUNs were assigned to the RHEL system:
...
> After starting filesystem and block I/O against the multipath
> devices I've noticed path failures. In order to get some more
> information I've changed verbosity to 3:

There are very few kernel messages.  And none that report the initial
failure(s) that trigger multipath to fail paths.  Pretty odd.

> Jun 13 10:14:14 jabulan-lp4 multipathd: checker failed path 8:80 in
> map mpathk
> Jun 13 10:14:14 jabulan-lp4 multipathd: mpathk: remaining active paths: 1
> Jun 13 10:14:14 jabulan-lp4 kernel: device-mapper: multipath:
> Failing path 8:80.
> Jun 13 10:14:15 jabulan-lp4 multipathd: mpathi: sdi - directio
> checker reports path is down
> Jun 13 10:14:15 jabulan-lp4 multipathd: checker failed path 8:128 in
> map mpathi
> Jun 13 10:14:15 jabulan-lp4 multipathd: mpathi: remaining active paths: 1
> Jun 13 10:14:15 jabulan-lp4 kernel: device-mapper: multipath:
> Failing path 8:128.
> Jun 13 10:14:15 jabulan-lp4 multipathd: mpathe: sdp - directio
> checker reports path is down
> Jun 13 10:14:15 jabulan-lp4 multipathd: checker failed path 8:240 in
> map mpathe
> Jun 13 10:14:15 jabulan-lp4 multipathd: mpathe: Entering recovery
> mode: max_retries=60
> Jun 13 10:14:15 jabulan-lp4 multipathd: mpathe: remaining active paths: 0
> Jun 13 10:14:15 jabulan-lp4 kernel: device-mapper: multipath:
> Failing path 8:240.
> Jun 13 10:14:15 jabulan-lp4 multipathd: mpathe: Entering recovery
> mode: max_retries=60
> Jun 13 10:14:16 jabulan-lp4 multipathd: mpathe: sde - directio
> checker reports path is up
> Jun 13 10:14:16 jabulan-lp4 multipathd: 8:64: reinstated
> Jun 13 10:14:16 jabulan-lp4 multipathd: mpathe: queue_if_no_path enabled
> Jun 13 10:14:16 jabulan-lp4 multipathd: mpathe: Recovered to normal mode
> Jun 13 10:14:16 jabulan-lp4 multipathd: mpathe: remaining active paths: 1
> Jun 13 10:14:19 jabulan-lp4 multipathd: mpathk: sdf - directio
> checker reports path is up
> Jun 13 10:14:19 jabulan-lp4 multipathd: 8:80: reinstated
> Jun 13 10:14:19 jabulan-lp4 multipathd: mpathk: remaining active paths: 2
> Jun 13 10:14:20 jabulan-lp4 multipathd: mpathi: sdi - directio
> checker reports path is up
> Jun 13 10:14:20 jabulan-lp4 multipathd: 8:128: reinstated
> Jun 13 10:14:20 jabulan-lp4 multipathd: mpathi: remaining active paths: 2
> Jun 13 10:14:20 jabulan-lp4 multipathd: mpathe: sdp - directio
> checker reports path is up
> Jun 13 10:14:20 jabulan-lp4 multipathd: 8:240: reinstated
> Jun 13 10:14:20 jabulan-lp4 multipathd: mpathe: remaining active paths: 2
> Jun 13 10:14:21 jabulan-lp4 kernel: sd 1:0:1:0: aborting command.
> lun 0x8100000000000000, tag 0xc00000026d1719d0
> Jun 13 10:14:21 jabulan-lp4 kernel: sd 1:0:1:0: aborted task tag
> 0xc00000026d1719d0 completed
> Jun 13 10:14:27 jabulan-lp4 multipathd: mpathb: sdm - directio
> checker reports path is down
> Jun 13 10:14:27 jabulan-lp4 multipathd: checker failed path 8:192 in
> map mpathb
> Jun 13 10:14:27 jabulan-lp4 multipathd: mpathb: remaining active paths: 1
> Jun 13 10:14:27 jabulan-lp4 kernel: device-mapper: multipath:
> Failing path 8:192.
> Jun 13 10:14:32 jabulan-lp4 multipathd: mpathb: sdm - directio
> checker reports path is up
> Jun 13 10:14:32 jabulan-lp4 multipathd: 8:192: reinstated
> Jun 13 10:14:32 jabulan-lp4 multipathd: mpathb: remaining active paths: 2
> Jun 13 10:14:40 jabulan-lp4 kernel: sd 3:0:1:0: aborting command.
> lun 0x8100000000000000, tag 0xc00000026d372890
> Jun 13 10:14:40 jabulan-lp4 kernel: sd 3:0:1:0: aborted task tag
> 0xc00000026d372890 completed
> Jun 13 10:14:56 jabulan-lp4 kernel: sd 15:0:1:0: aborting command.
> lun 0x8100000000000000, tag 0xc00000026d7084c0
> Jun 13 10:14:57 jabulan-lp4 kernel: sd 15:0:1:0: aborted task tag
> 0xc00000026d7084c0 completed
> Jun 13 10:15:05 jabulan-lp4 kernel: sd 14:0:1:0: aborting command.
> lun 0x8100000000000000, tag 0xc00000026d6bb2d8
> Jun 13 10:15:05 jabulan-lp4 kernel: sd 14:0:1:0: aborted task tag
> 0xc00000026d6bb2d8 completed
> :
> 
> Any ideas why pathes get marked as failed?

Do you have any additional kernel log messages that might shed some
light on what (if anything ) is failing (be it the transport or target,
etc)?
