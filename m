From: "Eric Van Hensbergen" <ericvh@gmail.com>
Subject: Re: Device Mapper as a cache for SAN?
Date: Mon, 10 Apr 2006 19:28:45 -0500
Message-ID: <a4e6962a0604101728o42596adaldb5a2ceb9348f37e@mail.gmail.com>
References: <a4e6962a0604101058w75a7147cy8860bc9ebf8f269e@mail.gmail.com>
	<20060410184531.GA12908@www.ewilts.org>
	<a4e6962a0604101246y5f912a01y72519a6c58291f5@mail.gmail.com>
	<1144704325.8591.170.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1144704325.8591.170.camel@localhost.localdomain>
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
To: mingz@ele.uri.edu, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 4/10/06, Ming Zhang <mingz@ele.uri.edu> wrote:
> On Mon, 2006-04-10 at 14:46 -0500, Eric Van Hensbergen wrote:
> > On 4/10/06, Ed Wilts <ewilts@ewilts.org> wrote:
> > >
> > > The obvious question is why?  What would this provide that the kern=
el
> > > and file systems don't already provide?
> > >
> >
> > Well, kernel provides in-memory page cache, not local disk page cache=
.
> >  There is some ongoing remote file system local disk cache work being
> > done, but it applies primarily to AFS and NFS - not block-based
> > transports such as iSCSI and AOE.  The various cluster file systems
> > may provide something more akin to this, but again, this doesn't
> > really cover SAN technologies -- not in any sort of a generic way.
> > Let me know if I'm missing something.
>
> still, what is the main benefit of this cache? what u mean "local disk
> page cache"? use "local disk" as page cache or page cache for "local
> disk" or something else?
>

Okay, I suppose I wasn't exactly clear.  What I want is something that
will let me use a local disk (or local disks) as a cache for a storage
area network volume (or volumes).  There are a variety of scenarios -
my primary interest is in using it for large clusters with shared
read-only volumes or with exclusive-access read/write volumes.   So,
local disk page cache is probably not the right terminology -- it is
simply a local block cache for a remote block device.

       -eric
