From: malahal@us.ibm.com
Subject: Re: dm mirror with failed device
Date: Sun, 7 Sep 2008 08:57:32 -0700
Message-ID: <20080907155732.GA5517@us.ibm.com>
References: <200809071149.46888.lists@octopus-technologies.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200809071149.46888.lists@octopus-technologies.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

If I remember, anything older than 2.6.25 can't handle errors in
dm-mirror. The I/O errors you saw were from your block device driver and
not from your dm-mirror. DM-mirror module itself is unaware of anything
to your iSCSI device! At least this is the expected behaviour if your
kernel is not patched, and that seems to be the case with your kernel. I
don't use Ubuntu! You may have a better luck with 2.6.26 or 27.

RHEL kernels are patched so handle these errors correctly!

--Malahal.

Stephen Beynon [lists@octopus-technologies.com] wrote:
> 
> This is probably a stupid question, in which case I apologise in advance.
> 
> I am looking to set up a number of machines with internal disks mirrored onto 
> an iscsi server.  I aim to provide resiliance against disk failures, and the 
> iscsi server will be a handy single point to backup.
> 
> I set up the following test mirror.
> 
> # dmsetup status mirror
> 0 16777216 mirror 2 254:8 8:16 32768/32768 0 1 core
> # dmsetup table mirror
> 0 16777216 mirror core 1 512 2 254:8 0 8:16 0
> 
> As a test I shutdown the iscsi server and continued writes to the mirror 
> device.  As expected syslog recorded i/o errors on the iscsi lun, but writes 
> to the mirror continued.  After waiting a few minutes I expected to see that 
> parts of the mirror were out of sync, however dmsetup status gave exactly the 
> same results as above.
> 
> When I restarted the iscsi server blocks started to be written to the iscsi 
> server again, but the changes that happened during the iscsi server down time 
> were never replicated.  Clearly this left the mirror in an inconsistent state 
> with the only indication of problems being in syslog.
> 
> Is there any way I can configure dm-mirror to either mark the blocks as out of 
> sync when a write fails, and re-try the write later ?
> 
> I am currently running Ubuntu gutsy on the client machines, so it does not 
> have dmeventd, but from reading the docs it it not clear that dmeventd would 
> help.
> 
> Regards
> 
> Stephen 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
