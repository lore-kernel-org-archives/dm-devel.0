From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: LVM on dmraid breakage
Date: Wed, 8 Aug 2007 22:45:38 +0100
Message-ID: <20070808214538.GR2064@agk.fab.redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
	<20070802065012.GA28687@percy.comedia.it>
	<46B1B5E1.1050406@redhat.com> <46B251BB.1010004@cfl.rr.com>
	<20070807210359.GA2064@agk.fab.redhat.com>
	<46BA2FCC.1040001@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46BA2FCC.1040001@cfl.rr.com>
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
Cc: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 08, 2007 at 05:04:12PM -0400, Phillip Susi wrote:
> https://bugs.launchpad.net/ubuntu/+source/dmraid/+bug/129285
 
There's something not quite right there:
  Why doesn't the 'lvdisplay' issue a message about the duplicate PV?
  - run 'vgscan -vvvv' to see what lvm2 is really doing with all the
    relevant devices

  What lvm2 version? 
   - could be old and not containing the code to do the detection
     correctly?

  Are there non-upstream-default config settings that had the effect of turning
off the detection?  
   - see 'lvm dumpconfig' output or /etc/lvm/lvm.conf plus any compile-time
     default changes


Standard procedure these days is to ask people to run 'lvmdump -a'
(scripts/lvm_dump.sh in the source tree) to capture the relevant information
for examination.

> This is do to the fact that the lvm tools open /dev/sd* and look for lvm 
> partitions, which it finds.
 
But I don't yet see why it didn't also open the other devices, write a warning
message about duplicate IDs, and do the right thing and give them
precedence.
 
Alasdair
-- 
agk@redhat.com
