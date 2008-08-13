From: Jim Lester <Jim.Lester@compellent.com>
Subject: RE: Custom priority callout
Date: Wed, 13 Aug 2008 11:51:01 -0500
Message-ID: <A7519D7FDEF2A144BA6D40BDF13100FEF4A96A@ex2.Beer.Town>
References: <A7519D7FDEF2A144BA6D40BDF13100FEF14CB5@ex2.Beer.Town><20080813145159.GB17006@mars.virtualiron.com><A7519D7FDEF2A144BA6D40BDF13100FEF14D7B@ex2.Beer.Town>
	<20080813164313.GA27816@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
In-Reply-To: <20080813164313.GA27816@mars.virtualiron.com>
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

By "faster" I just meant conceptually, fibre->iSCSI HBA->iSCSI software.
I didn't have any intention of actually polling the link somehow.=20

And I will absolutely post it back to the list once we get it written, I
already posted the hardware table definition, so that should be working
its way in here.=20

---
Jim Lester

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Konrad Rzeszutek
Sent: Wednesday, August 13, 2008 11:43 AM
To: device-mapper development
Subject: Re: [dm-devel] Custom priority callout

On Wed, Aug 13, 2008 at 09:57:22AM -0500, Jim Lester wrote:
> Compellent SANs can do a mix of both Fibre connections and iSCSI
> connections to the same volume. So some of our customers are looking
for
> ways to do more complex set ups with iSCSI as a failover situation
> behind multiple fibre connections.=20

Nice. I would suggest you develop a library implementation and post it
here. This way it could be integrated in all of the Linux distributions
over time and your customers won't have to download a package.

>=20
> Multibus works fine if they are using like connections, but if not, we
> wanted to be able to make sure that the faster connections come up on
> top.=20

I am curious how you are going to figure this out on the iSCSI
connection?
Nop-out latency?

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
