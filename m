From: malahal@us.ibm.com
Subject: Re: [RFC][PATCH 0/4] dm-log: support multi-log devices
Date: Mon, 5 Jan 2009 08:24:35 -0800
Message-ID: <20090105162435.GB18452@us.ibm.com>
References: <492C91DF.7040507@redhat.com>
	<ACCFADCE-51D8-4183-803D-32050E3BE436@redhat.com>
	<49467039.6060801@redhat.com> <20081220001305.GA8574@us.ibm.com>
	<49502F7E.9040300@redhat.com> <20081223180228.GA24831@us.ibm.com>
	<49622ADB.7040200@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49622ADB.7040200@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Takahiro Yasui <tyasui@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Takahiro Yasui [tyasui@redhat.com] wrote:
> Hi Malahal,
> 
> my patch doesn't handle transient error now. I expect log devices
> to be failed and got in a blockage status once an error has happened.
> 
> > With our user level only implementation, the log device handling would
> > be as good as the real mirror *leg* handling. We get all the benefits of
> > the mirror without doing any code! Wouldn't it be nice?
> 
> I agree that simple implementation is better, but log could be handled
> without any additional layer, and also I'm thinking that log could be
> handled in the simpler way.
> 
> Lower layer, such as SCSI, also has retry feature based on error type
> and will be done in the proper way. Do you mean that it isn't enough
> and should dm-layer handle errors for log device, too?

Not really. What I meant is re-integrating a failed log device when it
comes back again. That is also what I mean by handling 'transient
errors'.
