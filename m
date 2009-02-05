From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Multipath setup and rdac questions
Date: Thu, 05 Feb 2009 11:29:06 -0800
Message-ID: <1233862146.27254.15.camel@chandra-ubuntu>
References: <1a4a774c0902050558r661093dag83e71a06250c24aa@mail.gmail.com>
	<498B00B3.5020402@redhat.com>
	<1a4a774c0902051048keb6e681g7dbf2643a88a6d9e@mail.gmail.com>
Reply-To: sekharan@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1a4a774c0902051048keb6e681g7dbf2643a88a6d9e@mail.gmail.com>
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
Cc: bmr@redhat.com
List-Id: dm-devel.ids


On Thu, 2009-02-05 at 19:48 +0100, Christian R=C3=B8snes wrote:

>=20
> Is mpp another type of rdac driver than the one in question here ?

Yes, MPP is a standalone out-of-tree driver provided by LSI to support
the rdac devices.

Now that rdac support is available in mainline and distro, you do not
need to use them anymore.

MPP driver sits below the SCSI layer and  manages all the
failover/failback. It takes the MD3000i devices and provides the
"virtual disk" to the SCSI layer. That is the reason why you do not see
the MD3000i from user space.

Once you remove the mpp driver and use the multipathy.conf provided by
Babu, you should see the behavior you expect.
>=20
>=20
>=20
> Thank you
> Christian
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
