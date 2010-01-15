From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [dm-devel] [PATCH] dm-mpath: Two minor fixes while processing
	activate_path
Date: Fri, 15 Jan 2010 12:42:29 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF487870601@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4877BC98C@cosmail01.lsi.com>
 <20100115175708.GE17760@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20100115175708.GE17760@agk-dp.fab.redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: dm-devel.ids

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Alasdair G Kergon
> Sent: Friday, January 15, 2010 11:57 AM
> To: device-mapper development
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [dm-devel] [PATCH] dm-mpath: Two minor fixes while
> processing activate_path
> 
> On Tue, Jan 05, 2010 at 03:43:44PM -0700, Moger, Babu wrote:
> > -		DMERR("Cannot failover device because scsi_dh_%s was not "
> > -		      "loaded.", m->hw_handler_name);
> > +		DMERR("Could not failover device. Error %d.", errors);
> 
> Would it be meaningful still to include m->hw_handler_name in that
> message?

Fine with me.  I will re-post the patch..
