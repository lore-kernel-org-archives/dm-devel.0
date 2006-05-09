From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Running open-iscsi with device mapper hangs
Date: Tue, 09 May 2006 11:55:20 -0500
Message-ID: <4460C978.7090803@cs.wisc.edu>
References: <4460A074.6030805@voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4460A074.6030805@voltaire.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: open-iscsi@googlegroups.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Erez Zilber wrote:
> Hi,
> 
> I'm trying to run open-iscsi with the multipath tool. I was able to 
> create a scenario in which the initiator machine hangs:
> 
> My initiator runs on a SLES 10 beta 8 machine. The db contains 2 targets:
> iscsiadm -m node
> [83347a] 192.168.10.106:3260,1 iqn.2005-12.com.voltaire.206000C0FF07C1D1
> [030479] 192.168.10.105:3260,1 iqn.2005-12.com.voltaire.206000C0FF07C1D1
> 

are you using the iscsi initiator in a SLES kernel, a mainline kernel or
svn or a open-iscsi.org tarball?
