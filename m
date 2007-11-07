From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: NIC and HBA based multipathing
Date: Tue, 6 Nov 2007 21:09:25 -0800
Message-ID: <20071107050925.GA25156@linux.vnet.ibm.com>
References: <342d47870710301211y42200594u444b7af7ae870e7@mail.gmail.com>
	<472A2EA5.8050609@cs.wisc.edu>
	<342d47870711011321j1ff065c3jb54589988f3c499f@mail.gmail.com>
	<20071101215726.GB11002@linux.vnet.ibm.com>
	<342d47870711061308p77655083y7ac30a9e9e2a3b72@mail.gmail.com>
	<20071106222043.GA23178@linux.vnet.ibm.com>
	<342d47870711061433h6dce42baj705aca5ae7baa466@mail.gmail.com>
	<20071106230157.GA23800@linux.vnet.ibm.com>
	<342d47870711061746s64daeaa0wcb6adf060506686c@mail.gmail.com>
	<20071107025935.GA22697@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20071107025935.GA22697@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Scott Moseman <scmoseman@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

malahal@us.ibm.com <malahal@us.ibm.com> wrote:
> On redhat, there is a script (can't recollect but rc.sysinit, I believe)
> that creates this without multipathd.  You do need multipathd though for
> renaming/creating/acting on multipath events there after.
> 

Yes it is rc.sysinit that calls /sbin/multipath.static if nompath was not
specified on the cmdline and /etc/multipath.conf exists. One could return
the /etc/multipath.conf to its original state and blacklist everything
which would be why one would not see this behavior on a fresh no mpath
install.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
