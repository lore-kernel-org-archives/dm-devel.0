From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Problem with ALUA Handler
Date: Fri, 9 Nov 2007 11:48:46 -0800
Message-ID: <110b17190711091148t4c59ccfxfd59ab6298c10cc0@mail.gmail.com>
References: <110b17190711081232p41664102tfc0f3dea861d322a@mail.gmail.com>
	<47340EB2.5090109@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47340EB2.5090109@suse.de>
Content-Disposition: inline
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

Thanks Hannes.

Actually I could get it to work after making some changes;
In the function prepare_req(), I replaced

//rq->cmd_flags |=3D REQ_FAILFAST | REQ_NOMERGE;
	rq->flags |=3D REQ_FAILFAST | REQ_NOMERGE;

with following:

rq->flags |=3D REQ_BLOCK_PC | REQ_SPECIAL | REQ_QUIET;

This worked for me.

Thanks for your support.
Regards,
Pradipmaya.

On 11/9/07, Hannes Reinecke <hare@suse.de> wrote:
> Pradipmaya Maharana wrote:
> > Hi,
> >
> > I tried compiling ALUA handler code from Hannes Reincke
> > (https://www.redhat.com/archives/dm-devel/2007-October/msg00033.html)
> > on kernel 2.6.18 and with few modifications it did fine.
> >
> > I was even able to load it, but it fails for the std inquiry and henc=
e
> > does not do anything further. It returns error that the controller
> > does not support TPGS.
> >
> This is preliminary code only. I've done a rework of the ALUA handler
> and will post the updated code here shortly.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
