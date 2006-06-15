From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: Re: Hard drives shutting themselves off in RAID mode
Date: Thu, 15 Jun 2006 18:18:39 -0400
Message-ID: <87f94c370606151518m3ae02e39v345b4cb1e674f081@mail.gmail.com>
References: <20060613235316.7f982af7@localhost>
	<62b0912f0606140419s60c30535pbcc97c30ef99c50d@mail.gmail.com>
	<Pine.LNX.4.63.0606141609310.7019@pingle.local.rsnet>
	<20060614215258.6aa76d0f@localhost>
	<87f94c370606151329y4132e53dgf964a093683435e3@mail.gmail.com>
	<20060615232542.6b085337@localhost>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060615232542.6b085337@localhost>
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

On 6/15/06, Tom Wirschell <Tom@wirschell.nl> wrote:
> On 15 Jun 2006, Greg Freemyer wrote:
> >
> > In 2.6.17-mm there is a huge SATA error handler (EH) rewrite.  Is is
> > planned to hit the stable Linus kernel with 2.6.18 towards the end of
> > the summer, but even then it will only have a few of the actual
> > drivers modified to use the EH infrastructure.
>
> Damn. I read about this in the LWN.net Kernel pages for may 17th. I
> figured that once it was in, everything would automagically be using it
> too (i.e. the drivers wouldn't need to be updated to the new system).
> Guess I was a tad na=EFve about that.
> I tried 2.6.17-rc5-mm2 and ran into some BUG()s which went away when I
> just stuck to 2.6.17-rc5.
>
I guess you know that the -mm kernels get everybody's not for
primetime code added to it, so the BUG() you got could have come from
anywhere.

If your comfortable with the process, I would start with 2.6.17-rc6
then get the #upstream patch(upgrade) from libata and compile up a new
kernel.  (Think thousands of lines of modified code.)

If you get any issues with it the lkml-ide devs will jump right on it I s=
uspect.

Greg
--=20
Greg Freemyer
The Norcross Group
Forensics for the 21st Century
