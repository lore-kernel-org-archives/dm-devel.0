From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH] improve atomicity of device creation
Date: Tue, 11 Dec 2007 19:03:09 +0100
Message-ID: <3ae72650712111003u5f8fd2aau14b4dcf4cc95c594@mail.gmail.com>
References: <1197389316.25082.27.camel@quest>
	<3ae72650712110935n20398423t1da02c585a72aead@mail.gmail.com>
	<1197394828.25082.39.camel@quest>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1197394828.25082.39.camel@quest>
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
Cc: linux-hotplug-devel@lists.sourceforge.net
List-Id: dm-devel.ids

On Dec 11, 2007 6:40 PM, Scott James Remnant <scott@ubuntu.com> wrote:
>
> On Tue, 2007-12-11 at 18:35 +0100, Kay Sievers wrote:
>
> > On Dec 11, 2007 5:08 PM, Scott James Remnant <scott@ubuntu.com> wrote:
> > > This is a patch we've written and applied in Ubuntu to improve the
> > > atomicity of devmapper device creation somewhat, and avoid races with
> > > udev.
> >
> > Without synchronization between libdevmapper and udev, you can't
> > predict which one will win in creating the node, right?
> > So this patch makes is more likely to create a valid device node, but
> > it can still happen, that libdevmapper replaces the udev nodes, which
> > is not what we want, right?
> >
> No, the patch is slightly skewed so that udev always wins.  udev will
> always adopt an existing device node, adjusting permissions as
> necessary.  The patch makes devmapper "back off" if the device node
> exists.
>
> So you end up with either:
>
>  1) devmapper creates device node
>  2) udev adopts device node and sets permissions
>
> or:
>
>  1) udev creates device node and sets permissions
>  2) devmapper no-ops since it already exists

There is a  window between stat() and rename() in libdevmapper,
how can you konw that "udev always wins"?

Kay
