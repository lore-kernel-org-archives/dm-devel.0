From: "goggin, edward" <egoggin@emc.com>
Subject: RE: dm-devel Digest, Vol 18, Issue 2
Date: Tue, 2 Aug 2005 14:50:48 -0400
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AB98@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 1 Aug 2005 11:02:38 -0700
Joel Becker <Joel.Becker@oracle.com> wrote
> 
> 	This reports a LUN_Z, which is what I expected after I
> was explained a LUN_Z is the same as a ghost report.
> 	I get this in dmesg at multipath(8):
> 
> device-mapper: dm-multipath: 66:144: Error trying to 
> initialize PG, failing path
> device-mapper: dm-multipath: Failing path 66:144

This is a known problem.  The LUN_Z logical unit will respond
with error to the scsi command used to initialize by the pg_init
callout.  After this failure happens on all 4 paths the io (and
any processes waiting for its completion) hang since the CLARiiON
is configured to queue io if there are no active paths.

Current work around is to allocate at least one logical unit on
each CLARiiON.  Enhancing multipath-tools to support blacklisting
based on scsi attributes like model, vendor, and revision is a
reasonable longer-term solution.
