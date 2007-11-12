From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Problem with ALUA Handler
Date: Sun, 11 Nov 2007 23:28:59 -0800
Message-ID: <110b17190711112328s1dc3010cv7c5b74e3b3dc59cd@mail.gmail.com>
References: <110b17190711081232p41664102tfc0f3dea861d322a@mail.gmail.com>
	<47340EB2.5090109@suse.de>
	<110b17190711091148t4c59ccfxfd59ab6298c10cc0@mail.gmail.com>
	<4737FE63.6020803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4737FE63.6020803@suse.de>
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

Yes, you are right. I am evaluating it on 2.6.18 (that explains why
the changes work);
I am willing to wait for your patch but have no idea which release of
linux would include it.

Could you please let me know.

Thank and Regards,
Pradipmaya.

On 11/11/07, Hannes Reinecke <hare@suse.de> wrote:
> Pradipmaya Maharana wrote:
> > Thanks Hannes.
> >
> > Actually I could get it to work after making some changes;
> > In the function prepare_req(), I replaced
> >
> > //rq->cmd_flags |=3D REQ_FAILFAST | REQ_NOMERGE;
> >       rq->flags |=3D REQ_FAILFAST | REQ_NOMERGE;
> >
> > with following:
> >
> > rq->flags |=3D REQ_BLOCK_PC | REQ_SPECIAL | REQ_QUIET;
> >
> > This worked for me.
> >
>
> Errm. Which version you're compiling against?
> The hardware handler is done against scsi-misc; by the
> looks of it you're compiling against some older version
> (2.6.19? 2.6.16?)
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
