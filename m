From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [patch]: [multipath-tool] Add check for
	removeddevice in rdac checker
Date: Tue, 28 Oct 2008 10:10:39 -0400
Message-ID: <20081028141039.GA15229@mars.virtualiron.com>
References: <00FE57DD11E3A94893D5BD54C3358BE884BFA6@AUSX3MPC128.aus.amer.dell.com>
	<20081027170113.GA6167@mars.virtualiron.com>
	<46A00B48CC54E4468EF6911F877AC4CA01B6255E@blrx3m10.blr.amer.dell.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CA01B6255E@blrx3m10.blr.amer.dell.com>
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

On Tue, Oct 28, 2008 at 03:11:08PM +0530, Shyam_Iyer@Dell.com wrote:
> Konrad Wrote:
> > On Mon, Oct 27, 2008 at 10:11:28AM -0500, Yanqing_Liu@Dell.com wrote:
> > > Hi,
> > >
> > > This patch adds a check for removed device in rdac checker. After
> > > volume access inquiry returns, the checker will check the peripheral
> > > qualifier field to see if the device is deleted/unmapped. If so,
> mark
> > > path as failed.
> 
> > How does multipathd behaves when this fix is not in? Does it still
> mark the path down? I would presume so, but it would take longer (the
> default SCSI timeout value?)
> 
> Absolutely. But that would also be after some IOs on the failed path and
> the device being marked offline. Instead if the controller device is
> intelligent to support a feature to know if the path is down through an
> inquiry then it is worth marking the path down earlier. 

I concur.
> 
> Thanks for reviewing.

You are welcome.

+1
