From: "Jim Lester" <Jim.Lester@compellent.com>
Subject: RE: [PATCH] libmultipath/hwtable.c: Compellent Definition
Date: Mon, 14 Jul 2008 10:38:12 -0500
Message-ID: <A7519D7FDEF2A144BA6D40BDF13100FEA3F5B2@ex2.Beer.Town>
References: <A7519D7FDEF2A144BA6D40BDF13100FEA01806@ex2.Beer.Town>
	<20080711165328.GB29126@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080711165328.GB29126@mars.virtualiron.com>
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

I know, but that's when dumps out when you do a "show config" So
obviously my statement was slightly redundant. But I just wanted to make
sure it was clear what settings I wanted.=20

---
Jim Lester

-----Original Message-----
From: Konrad Rzeszutek [mailto:konrad@virtualiron.com]=20
Sent: Friday, July 11, 2008 11:53 AM
To: device-mapper development
Subject: Re: [dm-devel] [PATCH] libmultipath/hwtable.c: Compellent
Definition

On Fri, Jul 11, 2008 at 11:17:03AM -0500, Jim Lester wrote:
> The following is the patch to include a hardware definition for
> Compellent's SAN. This is my first patch so hopefully I did everything
> correctly. The definition in config form is below, if for some reason
my
> code doesn't match that, please inform me.
>=20
>         device {
>                 vendor "COMPELNT"
>                 product "Compellent Vol"
>                 path_grouping_policy multibus
>                 path_checker tur
>                 checker tur

That is bogus. There are no 'checker' field in the .conf file. Hopefully
that isn't in your product release notes.

>                 failback immediate
>                 no_path_retry queue
>         }
