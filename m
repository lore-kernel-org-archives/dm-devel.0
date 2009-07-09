From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/3] scsi_dh: Add ability to set parameters
	for scsi device handler
Date: Thu, 09 Jul 2009 12:55:46 -0700
Message-ID: <1247169346.28322.0.camel@chandra-ubuntu>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
	<1246563299.8018.9.camel@eddie-laptop>
	<1246566564.8018.21.camel@eddie-laptop>
	<1246567622.7381.7.camel@chandra-ubuntu>
	<1246970082.6646.9.camel@eddie-laptop>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1246970082.6646.9.camel@eddie-laptop>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eddie Williams <Eddie.Williams@steeleye.com>
Cc: inux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, dm-devel@redhat.com, Benoit_Arthur@emc.com, agk@redhat.com
List-Id: dm-devel.ids

Did you try to port/apply my patches to the SLES11 tree and see if it
works ?

On Tue, 2009-07-07 at 08:34 -0400, Eddie Williams wrote:
> I was testing with the SLES 11 kernel.  Initially I was using
> 2.6.27.19-5 and also verified the same issue with their errata kernel
> 2.6.27.23-0.1.
> 
> Eddie
> On Thu, 2009-07-02 at 13:47 -0700, Chandra Seetharaman wrote:
> > On Thu, 2009-07-02 at 16:29 -0400, Eddie Williams wrote:
> > > On Thu, 2009-07-02 at 15:34 -0400, Eddie Williams wrote:
> > > > I have tried to set this up but have run into a problem probably due to
> > > > my error.  It has been a while since I have had to build kernels...
> > > > 
> > > > I pulled 2.6.31-rc1, applied the two patches below and then applied the
> > > > 3 patches for the interface.  The new kernel loads fine but when a
> > > > trespass command is sent I get an panic.  I am looking though how I
> > > > built the kernel and perhaps build with your 3 patches to see if it
> > > > happened before.  
> > > 
> > > I backed out the 3 patches with the same panic.
> > > 
> > Which version of the kernel were you originally testing with ? (when you
> > found the feature was gone).
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
