From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: NIC and HBA based multipathing
Date: Mon, 12 Nov 2007 12:18:35 -0800
Message-ID: <20071112201835.GB23668@linux.vnet.ibm.com>
References: <20071101215726.GB11002@linux.vnet.ibm.com>
	<342d47870711061308p77655083y7ac30a9e9e2a3b72@mail.gmail.com>
	<20071106222043.GA23178@linux.vnet.ibm.com>
	<342d47870711061433h6dce42baj705aca5ae7baa466@mail.gmail.com>
	<20071106230157.GA23800@linux.vnet.ibm.com>
	<342d47870711061746s64daeaa0wcb6adf060506686c@mail.gmail.com>
	<20071107025935.GA22697@us.ibm.com>
	<20071107050925.GA25156@linux.vnet.ibm.com>
	<342d47870711070707s7ac0fca2w1fdda12fb73fc548@mail.gmail.com>
	<342d47870711120954p56f41b30ob2c0956d11740244@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <342d47870711120954p56f41b30ob2c0956d11740244@mail.gmail.com>
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

Scott Moseman <scmoseman@gmail.com> wrote:
> Maybe no one wants to open my attachment, here's an abbreviated
> version of the "multipath -v" output...
> 
> # multipath -v4
> load path identifiers cache
> #
> # all paths in cache :
> #
>   #:#:#:#  hda 3:0  [faulty] //
> 30690a018f015191a6472441d1500f057  1:0:1:0 sdb 8:16  [active][ready] EQLOGIC /
>   3:0:0:0 sdc 8:32  [faulty] EQLOGIC /100E-00         /2.3
> 
> Per my previous email, the "sdc" device is the iSCSI connection
> through the NIC.  The HBA connection, "sdb", is working fine.

Based on the previous multipath -v4 output you provided (snippet shown
below) it appears there is a problem accessing the device node of sdc as
it complete sysfs_pathinfo and then appears to fail when it tries to open
the device node.
...
h:b:t:l = 3:0:0:0
tgt_node_name =

Is /dev/sdc ok? Can you do a dd read of the device?

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
