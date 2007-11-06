From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: NIC and HBA based multipathing
Date: Tue, 6 Nov 2007 14:20:43 -0800
Message-ID: <20071106222043.GA23178@linux.vnet.ibm.com>
References: <342d47870710300956k3bde2d06j7a50acc6c8225fe5@mail.gmail.com>
	<5fb0f77b0710301040l4eeca0a7n2ccdc00b14285294@mail.gmail.com>
	<342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
	<472A2EA5.8050609@cs.wisc.edu>
	<342d47870711011321j1ff065c3jb54589988f3c499f@mail.gmail.com>
	<20071101215726.GB11002@linux.vnet.ibm.com>
	<342d47870711061308p77655083y7ac30a9e9e2a3b72@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <342d47870711061308p77655083y7ac30a9e9e2a3b72@mail.gmail.com>
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
> Thanks, Mike, I was just about to give this a try when I came upon
> another problem (unrelated to MPIO, though).  The server was down, and
> ever since bringing it back online I've been unable to get the HBA to
> mount.  I disabled the iSCSI initiator for the NIC so that I'm only
> dealing with the HBA, but I get this error:
> 
> # mount /dev/sdb1 /sanHBA
> mount: /dev/sdb1 already mounted or /sanHBA busy
> 
> I did a fresh config using the iscli tool, and /dev/sdb1 was the
> resulting partition that it found.
> 

It appears something else has claimed the device prior to your mount call. 
	- Is it lvm? Run pvs and see if the device was claimed. If that is
	  not what you want you may need to use the lvm.conf filters.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
