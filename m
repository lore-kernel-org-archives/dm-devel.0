From: malahal@us.ibm.com
Subject: Re: Use LVM on /dev/mapper/diskname and iSCSI
Date: Mon, 19 Nov 2007 10:50:21 -0800
Message-ID: <20071119185021.GA23100@us.ibm.com>
References: <1195480602.6074.3.camel@sanderbal> <47419854.2000508@linpro.no>
	<1195484847.6074.16.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1195484847.6074.16.camel@sanderbal>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "S. J. van Harmelen" <svh@dds.nl>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

S. J. van Harmelen [svh@dds.nl] wrote:
> Thanks for your help!
> 
> I executed the pvs command and it did find a few partitions. I use iSCSI
> to share the LUN's to a XenSource server, and XenSource creates the PV's
> and LV's in order to provision VM's. Didn't think of that, but that's on
> the disk of course. 
> 
> Is there any way to configure snapshots for these already created LVM
> partitions?

If I understand, you exported some LUNs to XenSource server. So you
should NOT be using those LUNs at this machine, right? You should be
able to create snapshots at the XenSource server though.
