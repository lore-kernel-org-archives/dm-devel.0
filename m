From: "S. J. van Harmelen" <svh@dds.nl>
Subject: Help needed with RDAC in production environment!!
Date: Wed, 14 Nov 2007 21:38:24 +0100
Message-ID: <1195072704.5881.16.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi all,

Please look at the output from "multipath -ll"

backup (360019b9000d7e1100000444b46be82c4) dm-1 DELL    ,MD3000        
[size=200G][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:1:2 sdh 8:112 [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:2 sdd 8:48  [active][ghost]
xen (360019b9000d7e1100000445a47314b36) dm-0 DELL    ,MD3000        
[size=200G][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][enabled]
 \_ 1:0:0:3 sde 8:64  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:3 sdi 8:128 [active][ghost]
vmware (360019b9000d7e1100000444846be81b6) dm-3 DELL    ,MD3000        
[size=200G][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][enabled]
 \_ 1:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:1:0 sdf 8:80  [active][ghost]
data (360019b9000d7ddab0000493846be81e5) dm-2 DELL    ,MD3000        
[size=200G][features=0][hwhandler=1 rdac]
\_ round-robin 0 [prio=3][active]
 \_ 1:0:1:1 sdg 8:96  [active][ready]
\_ round-robin 0 [prio=0][enabled]
 \_ 1:0:0:1 sdc 8:32  [active][ghost]

See the xen and vmware disks. They both display enable / enable instead
of active / enable. Is this correct? Or is a disaster waiting to happen?

Please advice!

Sander
