From: Edward Goggin <egoggin@emc.com>
Subject: RE: Why is device mapper unable to remove a mapped
	devicewhich is open?
Date: Fri, 22 Sep 2006 20:03:10 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D13DB@CORPUSMX40A.corp.emc.com>
References: <20060922204312.GY17654@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20060922204312.GY17654@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Friday, September 22, 2006 4:43 PM, Alasdair G Kergon wrote:

> On Fri, Sep 22, 2006 at 04:26:16PM -0400, goggin, edward wrote:
> > Why shouldn't the kernel's reference counting for the
> > mapped device's md structure account for properly=20
> > handling the de-allocation of the md structure upon
> > the last close in this case?
>=20
> This behaviour has flipped a couple of times during the
> development.
>=20
> It would be fine if devices could never be suspended.
> You can't close a suspended device you've written to
> until it gets resumed.  If you've removed it you can't
> resume it because it has gone.
>=20
> It's similar in a way to how the kernel used to (at least I=20
> assume someone
> fixed it?) let you unlink a swap file and then it was impossible to
> 'swapoff' because you couldn't reference the device any more.

What about having mapped device specific dm ioctls be issued
to (the file descriptor of) the affected mapped device instead
of to the dm control device?  I think this would include
at least such dm ioctls as dev_remove, dev_rename, dev_suspend,
dev_status, dev_wait, table_load, table_clear, table_deps,
table_status, target_message, and dev_set_geometry.  The dm
ioctls such as remove_all, list_devices, dev_create, list_versions,
and version would remain associated with the dm control device.

While this approach would require having both the dm control
device and the actual mapped devices service ioctls and requires
reserving a range of ioctls for exclusive use by dm, the clear
advantage is that name translation for these ioctls would not
be required.
